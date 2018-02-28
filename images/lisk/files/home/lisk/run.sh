#!/bin/bash

function jq_config {
	jq -c "$1" config.json |sponge config.json
}

jq -c ".api.access.public = true" config.json |sponge config.json

jq_config ".consoleLogLevel = \"${LISK_CONFIG_CONSOLE_LOG_LEVEL:=info}\""

if [ "${LISK_CONFIG_FORGING_WHITELIST_IP:=127.0.0.1}" != "127.0.0.1" ]
then
	jq_config ".forging.access.whiteList = [\"127.0.0.1\",\"$FORGING_WHITELIST_IP\"]"
fi
jq_config ".db.host = \"${LISK_CONFIG_DB_HOST:=db}\""
jq_config ".db.port = ${LISK_CONFIG_DB_PORT:=5432}"
jq_config ".db.database = \"${LISK_CONFIG_DB_DATABASE:=lisk_test}\""
jq_config ".db.user = \"${LISK_CONFIG_DB_USER:=lisk}\""
jq_config ".db.password = \"${LISK_CONFIG_DATABASE_PASSWORD:=password}\""

export PATH=/home/lisk/lisk-Linux-x86_64/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LD_LIBRARY_PATH=/home/lisk/lisk-Linux-x86_64/pgsql/lib
node app.js
