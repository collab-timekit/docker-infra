#!/bin/bash

REALM_FILE="/opt/keycloak/data/import/calendar-realm.json"
TEMP_FILE=$(mktemp)

cp "$REALM_FILE" "$TEMP_FILE"

for var in $(env | cut -d= -f1); do
  sed -i "s|\${$var}|${!var}|g" "$TEMP_FILE"
done

mv "$TEMP_FILE" "$REALM_FILE"

echo "Environment variables have been replaced in $REALM_FILE."