#!/bin/bash
git clone https://github.com/eubr-atmosphere/fogbow-site-probe.git

CONTAINER_NAME="probes"

IMAGE_NAME="eubraatmosphere/fogbow-probes"

IMAGE_BASE_NAME=$(basename $IMAGE_NAME)
SERVICES_CONF=services.conf
TAG=$(grep $IMAGE_BASE_NAME $SERVICES_CONF | awk -F "=" '{print $2}')

if [ -z ${TAG// } ]; then
	TAG="latest"
fi

IMAGE=$IMAGE_NAME:$TAG

CONF_FILE=probe-fogbow.conf
ip=`awk -F ' *= *' '$1=="monitor_ip"{print $2}' $CONF_FILE`/monitor
endpoint_attr="DEFAULT_ENDPOINT ="

sudo docker pull $IMAGE
container_id=`sudo docker run --name $CONTAINER_NAME -idt $IMAGE`
sudo docker cp ./fogbow-site-probe/java-client-lib $container_id:/app/
sudo docker cp ./fogbow-site-probe/probes $container_id:/app/
sudo docker cp $CONF_FILE $container_id:/app/probes/src/main/resources/private
sudo docker cp ./cert.pem $container_id:/app/
sudo docker cp ./cert.pem $container_id:/app/java-client-lib
sudo docker exec $container_id /bin/bash -c "sed -i 's,$endpoint_attr.*,$endpoint_attr\"$ip\";,' /app/java-client-lib/src/main/java/eu/atmosphere/tmaf/monitor/client/MonitorClient.java"
sudo docker cp ./application.properties $container_id:/app/probes/src/main/resources
sudo docker exec $container_id /bin/bash -c "rm -rf /usr/share/maven/boot/plexus-classworlds-2.5.2.jar"
sudo docker exec $container_id /bin/bash -c "keytool -import -trustcacerts -keystore /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/cacerts -storepass changeit -noprompt -alias monitor -file cert.pem"
sudo docker exec $container_id /bin/bash -c "cd /app/java-client-lib && mvn clean install && cd /app/probes && mvn clean install && mvn spring-boot:run -X > log.out 2> log.err" &

rm -rf fogbow-site-probe