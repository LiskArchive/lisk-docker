#!/bin/bash

function jq_config {
	jq -c "$1" config.json |sponge config.json
}

if [ "$NETWORK" != "local" ] && [ "$NETWORK" != "test" ] && [ "$NETWORK" != "main" ]; then
	echo "X Invalid first argument (must be local, test or main)."
	exit 1
fi

DB_NAME="lisk_$NETWORK"

jq_config ".consoleLogLevel = \"${LOG_LEVEL:=debug}\""

if [ "${FORGING_WHITELIST_IP:=127.0.0.1}" != "127.0.0.1" ]
then
	jq_config ".forging.access.whiteList = [\"127.0.0.1\",\"$FORGING_WHITELIST_IP\"]"
fi

DATABASE_PASSWORD=$( head -n1 ~/.pgpass |cut -d ":" -f 5 )
RESOLVED_REDIS_HOST=$( getent hosts "${REDIS_HOST:=127.0.0.1}" | awk '{ print $1 }' )

jq_config ".db.host = \"${PGHOST:=localhost}\""
jq_config ".db.port = ${PGPORT:=5432}"
jq_config ".db.database = \"${PGDATABASE:=$DB_NAME}\""
jq_config ".db.user = \"${PGUSER}\""
jq_config ".db.password = \"${DATABASE_PASSWORD:=password}\""
jq_config ".redis.host = \"${RESOLVED_REDIS_HOST:=localhost}\""
jq_config ".redis.port = ${REDIS_PORT:=6380}"
jq_config ".redis.db = ${REDIS_DB:=0}"
jq_config ".cacheEnabled = ${REDIS_ENABLED:=false}"

psql --command='\d' >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
	echo "Database is not ready."
	sleep 60
	exit 1
fi
echo "Database is ready."

node app.js
