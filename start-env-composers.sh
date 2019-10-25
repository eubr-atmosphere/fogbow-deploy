#!/bin/bash

SERVICES_DIR="services"

PROBES_DIR="$SERVICES_DIR/probes"
AUDITING_SERVER_DIR="$SERVICES_DIR/auditing-client"
AUDITING_CLIENT_DIR="$SERVICES_DIR/auditing-server"

SERVICES_LIST="$PROBES_DIR $AUDITING_SERVER_DIR $AUDITING_CLIENT_DIR"

for service in $SERVICE_LIST; do
  echo ""
	echo "Running $service/env-composer.sh"
	echo ""
	bash $service/"env-composer.sh"
done