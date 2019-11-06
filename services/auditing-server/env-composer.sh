#!/bin/bash

CONF_FILE_SOURCE_DIR="$(pwd)/conf-files"
SERVER_CONF_FILE_NAME="auditing-server.conf"
SERVICES_CONF_FILE_NAME="services.conf"
AUDITING_SERVER_SERVICE_PATH="services/auditing-server"
SECRETS_FILE="secrets"
SHARED_INFO_FILE_PATH="$(pwd)/services/conf-files/shared.info"

yes | cp -f $CONF_FILE_SOURCE_DIR/$SERVER_CONF_FILE_NAME $AUDITING_SERVER_SERVICE_PATH
yes | cp -f $CONF_FILE_SOURCE_DIR/$SECRETS_FILE $AUDITING_SERVER_SERVICE_PATH
yes | cp -f $CONF_FILE_SOURCE_DIR/$SERVICES_CONF_FILE_NAME $AUDITING_SERVER_SERVICE_PATH
yes | cp -f $SHARED_INFO_FILE_PATH $AUDITING_SERVER_SERVICE_PATH

CONF_FILE_PATH="$(pwd)/$AUDITING_SERVER_SERVICE_PATH/$SERVER_CONF_FILE_NAME"
SECRETS_FILE_PATH="$(pwd)/$AUDITING_SERVER_SERVICE_PATH/$SECRETS_FILE"
host_ip=$(grep ^host_ip $CONF_FILE_PATH | awk -F "=" '{print $2}')
db_container_port=$(grep ^db_container_port $CONF_FILE_PATH | awk -F "=" '{print $2}')
db_name=$(grep ^db_name $CONF_FILE_PATH | awk -F "=" '{print $2}')
db_url=$host_ip:$db_container_port/$db_name
db_user=$(grep ^db_user $CONF_FILE_PATH | awk -F "=" '{print $2}')
db_password=$(grep ^db_password $SECRETS_FILE_PATH | awk -F "=" '{print $2}')
SERVER_PORT=$(grep ^server_port $SHARED_INFO_FILE_PATH | awk -F "=" '{print $2}')

sed -i "s,db_password=,db_password=$db_password," $CONF_FILE_PATH

APPLICATION_PROPERTIES_FILE_PATH="$(pwd)/services/auditing-server/application.properties"

sed -i "s,spring.datasource.url.*,spring.datasource.url=jdbc:postgresql://$db_url," $APPLICATION_PROPERTIES_FILE_PATH
sed -i "s,spring.datasource.username.*,spring.datasource.username=$db_user," $APPLICATION_PROPERTIES_FILE_PATH
sed -i "s,spring.datasource.password.*,spring.datasource.password=$db_password," $APPLICATION_PROPERTIES_FILE_PATH
sed -i "s,server.port.*,server.port=$SERVER_PORT," $APPLICATION_PROPERTIES_FILE_PATH