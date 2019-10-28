#!/bin/bash

CONTAINER_NAME="auditing-client"
cd /home/ubuntu/auditing

IMAGE_NAME="eubraatmosphere/auditing-client"

IMAGE_BASE_NAME=$(basename $IMAGE_NAME)
SERVICES_CONF=services.conf
TAG=$(grep $IMAGE_BASE_NAME $SERVICES_CONF | awk -F "=" '{print $2}')

if [ -z ${TAG// } ]; then
	TAG="latest"
fi

IMAGE=$IMAGE_NAME:$TAG
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME
sudo docker pull $IMAGE

container_id=`sudo docker run --name $CONTAINER_NAME -idt -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker $IMAGE`

sudo docker exec $container_id /bin/bash -c "mkdir src/main/resources/private"
client_id=$(grep ^client_id auditing-client.conf | awk -F "=" '{print $2}')
sudo bash generate-ssh-key-pair $client_id 2048
mv $client_id.priv private.key
sudo docker cp private.key $container_id:/root/auditing-client/src/main/resources/private
sudo docker cp auditing-client.conf $container_id:/root/auditing-client/src/main/resources/private
sudo docker exec $container_id /bin/bash -c "chmod +x src/main/java/cloud/fogbow/auditingclient/core/scripts/scan*"
sudo docker exec $container_id /bin/bash -c "mvn spring-boot:run -X > log.out 2> log.err" &