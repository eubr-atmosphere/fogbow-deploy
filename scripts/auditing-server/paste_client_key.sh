#!/bin/bash
key_name=$1
SERVER_CONTAINER_NAME=auditing-server

sudo docker cp $key_name $SERVER_CONTAINER_NAME:/root/auditing-server/target/classes/private/clientkeys
sudo docker cp $key_name $SERVER_CONTAINER_NAME:/root/auditing-server/src/main/resources/private/clientkeys