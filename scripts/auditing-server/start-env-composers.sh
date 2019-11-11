#!/bin/bash

MAIN_COMPOSER_DIR=$(pwd)/scripts/auditing-server

SERVICES_DIR="services"
AUDITING_SERVER_DIR="$SERVICES_DIR/auditing-server"

cd ../..

SERVICES_LIST="$MAIN_COMPOSER_DIR $AUDITING_SERVER_DIR"

for service in $SERVICES_LIST; do
  echo ""
	echo "Running $service/env-composer.sh"
	echo ""
	bash $service/"env-composer.sh"
done