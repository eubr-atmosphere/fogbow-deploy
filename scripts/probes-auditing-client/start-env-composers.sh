#!/bin/bash

SERVICES_DIR="../../services"

PROBES_DIR="$SERVICES_DIR/probes"
AUDITING_CLIENT_DIR="$SERVICES_DIR/auditing-client"

SERVICES_LIST="$PROBES_DIR $AUDITING_CLIENT_DIR"

for service in $SERVICES_LIST; do
  echo ""
	echo "Running $service/env-composer.sh"
	echo ""
	bash $service/"env-composer.sh"
done