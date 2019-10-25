#!/bin/bash

KEY_PATH=$1

CONTAINER_NAME="auditing-server"

sudo docker exec $CONTAINER_NAME /bin/bash -c "mkdir /root/auditing-server/src/main/resources/private/clientkeys"
sudo docker cp $KEY_PATH $CONTAINER_NAME:/root/auditing-server/src/main/resources/private/clientkeys