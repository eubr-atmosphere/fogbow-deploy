#!/bin/bash

CONF_FILE_SOURCE_DIR="$(pwd)/conf-files"
CLIENT_CONF_FILE_NAME="auditing-client.conf"
SERVICES_CONF_FILE_NAME="services.conf"
CONF_FILE_DEST_DIR="services/auditing-client"

yes | cp -f $CONF_FILE_SOURCE_DIR/$CLIENT_CONF_FILE_NAME $CONF_FILE_DEST_DIR
yes | cp -f $CONF_FILE_SOURCE_DIR/$SERVICES_CONF_FILE_NAME $CONF_FILE_DEST_DIR

host_ip=$(grep ^host_ip general.conf | awk -F "=" '{print $2}')
db_container_port=$(grep ^container_port general.conf | awk -F "=" '{print $2}')
db_name=$(grep ^db_name general.conf | awk -F "=" '{print $2}')
db_url=$host_ip:$db_container_port/$db_name
db_user=$(grep ^db_user general.conf | awk -F "=" '{print $2}')
db_password=$(grep ^db_password general.conf | awk -F "=" '{print $2}')

sed -i "s,spring.datasource.url.*,spring.datasource.url=jdbc:postgresql://$db_url," ./application.properties
sed -i "s,spring.datasource.username.*,spring.datasource.username=$db_user," ./application.properties
sed -i "s,spring.datasource.password.*,spring.datasource.password=$db_password," ./application.properties
sed -i "s,server.port.*,server.port=8085," ./application.properties