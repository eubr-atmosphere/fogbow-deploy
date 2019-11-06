#!/bin/bash

SERVER_CONF_FILE_NAME="auditing-server.conf"
SHARED_INFO="shared.info"
CONF_FILE_PATH="$(pwd)/$SERVER_CONF_FILE_NAME"
SERVER_PORT=$(grep ^server_port $SHARED_INFO | awk -F "=" '{print $2}')

git clone https://github.com/eubr-atmosphere/auditing-server.git
cp $CONF_FILE_PATH auditing-server/database-setup/general.conf
cd auditing-server/database-setup
bash deploy-script.sh

cd ../../

sudo rm -rf auditing-server

CONTAINER_NAME="auditing-server"

IMAGE_NAME="eubraatmosphere/auditing-server"

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

container_id=`sudo docker run --name $CONTAINER_NAME -p $SERVER_PORT:$SERVER_PORT -idt $IMAGE`

sudo docker exec $container_id /bin/bash -c "mkdir -p src/main/resources/private/clientkeys"
sudo docker cp $CONF_FILE_PATH $container_id:/root/auditing-server/src/main/resources/private
sudo docker cp ./application.properties $container_id:/root/auditing-server/src/main/resources/
sudo bash generate-ssh-key-pair server-key 2048
mv server-key.priv private.key
mv server-key.pub public.key
sudo docker cp ./private.key $container_id:/root/auditing-server/src/main/resources/private
sudo docker cp ./public.key $container_id:/root/auditing-server/src/main/resources/private
sudo docker cp ./*.pub  $container_id:/root/auditing-server/src/main/resources/private/clientkeys
sudo docker exec $container_id /bin/bash -c "mvn spring-boot:run -X > log.out 2> log.err" &