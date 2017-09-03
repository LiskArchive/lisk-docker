#!/bin/bash

NETWORK="$1"
COMMAND="$2"

sudo chown lisk:lisk ./lisk

if [ ! -f ./lisk/config.json ]; then
  echo "Volume not yet initialized, setting up..."
  /bin/cp -rf ./src/* ./lisk/
elif ! diff -q <(jq '.version' ./lisk/config.json) <(jq '.version' ./src/config.json); then
  echo "Version changed, copying from source..."
  mv ./lisk/logs ./
  rm -rf ./lisk/*
  /bin/cp -rf ./src/* ./lisk/
  mv ./logs ./lisk/
else
  echo "Nothing changed, starting app..."
fi

cd ./lisk
jq -c ".consoleLogLevel = \"${LOG_LEVEL:=debug}\"" config.json > tmp.$$.json && mv tmp.$$.json config.json
if [ "${FORGING_WHITELIST_IP:=127.0.0.1}" != "127.0.0.1" ]
then
  jq -c ".forging.access.whiteList = [\"127.0.0.1\",\"$FORGING_WHITELIST_IP\"]" config.json > tmp.$$.json && mv tmp.$$.json config.json
fi

jq -c ".db.host = \"${DATABASE_HOST:=localhost}\"" config.json > tmp.$$.json && mv tmp.$$.json config.json
jq -c ".db.port = ${DATABASE_PORT:=5432}" config.json > tmp.$$.json && mv tmp.$$.json config.json
jq -c ".db.database = \"${DATABASE_NAME:=$DB_NAME}\"" config.json > tmp.$$.json && mv tmp.$$.json config.json
jq -c ".db.user = \"${DATABASE_USER}\"" config.json > tmp.$$.json && mv tmp.$$.json config.json
jq -c ".db.password = \"${DATABASE_PASSWORD:=password}\"" config.json > tmp.$$.json && mv tmp.$$.json config.json
echo "Running with config:"
cat config.json
cd /home/lisk

echo "Connecting to remote database"
touch ./.pgpass
PGPASSFILE="/home/lisk/.pgpass"
echo "$DATABASE_HOST:$DATABASE_PORT:$DATABASE_USER:$DATABASE_USER:$DATABASE_PASSWORD" >> $PGPASSFILE
echo "$DATABASE_HOST:$DATABASE_PORT:$DATABASE_NAME:$DATABASE_USER:$DATABASE_PASSWORD" >> $PGPASSFILE
sudo chmod 600 $PGPASSFILE
until psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_USER" -w -c '\l' &> /dev/null; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done
echo "Postgres is up - executing command"

if [ -z "$COMMAND" ]
then
  export PGPASSFILE
  export SNAPSHOT_URL
  export DATABASE_HOST
  export DATABASE_NAME
  export DATABASE_USER
  export DATABASE_PASSWORD
  psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_USER" -w -c "CREATE DATABASE ${DATABASE_NAME};" &> /dev/null
  exec ./start_lisk $NETWORK
elif [ "$COMMAND" == "reset" ]
then
  echo "Running reset"
  psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_USER" -w -c "DROP DATABASE ${DATABASE_NAME};" &> /dev/null
  psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_USER" -w -c "CREATE DATABASE ${DATABASE_NAME};" &> /dev/null
  rm $PGPASSFILE
else
  echo "Incorrect command, exiting..."
fi