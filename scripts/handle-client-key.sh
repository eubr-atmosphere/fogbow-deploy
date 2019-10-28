#!/bin/bash

CONF_FILES_PATH="../conf-files"

client_id=$(grep ^client_id $CONF_FILES_PATH/auditing-client.conf | awk -F "=" '{print $2}')
sudo bash generate-ssh-key-pair $client_id 2048
mv $client_id.priv private.key

# PASTE KEYS ON CLIENT MACHINE

PERMISSION_FILE_PATH=
REMOTE_USER=
HOST_IP=
HOST_FILE_PATH=

#PASTE CLIENT PUB KEY IN THE SERVER MACHINE

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $PERMISSION_FILE_PATH $client_id $REMOTE_USER@$HOST_IP:$HOST_FILE_PATH