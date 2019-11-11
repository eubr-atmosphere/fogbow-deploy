#!/bin/bash

CONF_FILE_SOURCE_DIR="$(pwd)/conf-files"
CLIENT_CONF_FILE_NAME="auditing-client.conf"
SERVICES_CONF_FILE_NAME="services.conf"
CONF_FILE_DEST_DIR="services/auditing-client"
echo $(pwd)
yes | cp -f $CONF_FILE_SOURCE_DIR/$CLIENT_CONF_FILE_NAME $CONF_FILE_DEST_DIR
yes | cp -f $CONF_FILE_SOURCE_DIR/$SERVICES_CONF_FILE_NAME $CONF_FILE_DEST_DIR