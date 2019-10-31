#!/bin/bash

CONF_FILE_SOURCE_DIR="$(pwd)/conf-files"
PROBES_CONF_FILE_NAME="probes.conf"
SERVICES_CONF_FILE_NAME="services.conf"
CONF_FILE_DEST_DIR="services/probes"

yes | cp -f $CONF_FILE_SOURCE_DIR/$PROBES_CONF_FILE_NAME $CONF_FILE_DEST_DIR
yes | cp -f $CONF_FILE_SOURCE_DIR/$SERVICES_CONF_FILE_NAME $CONF_FILE_DEST_DIR
yes | cp -f $CONF_FILE_SOURCE_DIR/cert.pem $CONF_FILE_DEST_DIR

CONF_FILE="$(pwd)/services/probes/$PROBES_CONF_FILE_NAME"

RAS_DB_URL=$(grep ^ras_db_url $CONF_FILE| awk -F "=" '{print $2}')/ras
DB_USERNAME=$(grep ^db_username $CONF_FILE| awk -F "=" '{print $2}')
DB_PASSWORD=$(grep ^db_password $CONF_FILE| awk -F "=" '{print $2}')

APPLICATION_PROPERTIES_FILE="$(pwd)/services/probes/application.properties"

sed -i "s,spring.datasource.url.*,spring.datasource.url=jdbc:postgresql://$RAS_DB_URL," $APPLICATION_PROPERTIES_FILE
sed -i "s,spring.datasource.username.*,spring.datasource.username=$DB_USERNAME," $APPLICATION_PROPERTIES_FILE
sed -i "s,spring.datasource.password.*,spring.datasource.password=$DB_PASSWORD," $APPLICATION_PROPERTIES_FILE