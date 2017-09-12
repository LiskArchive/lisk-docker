#!/bin/bash

NETWORK="$1"

download_blockchain() {
	DEFAULT_SNAPSHOT_URL="https://downloads.lisk.io/lisk/$NETWORK/blockchain.db.gz"
	echo "Downloading blockchain snapshot... (${SNAPSHOT_URL:=$DEFAULT_SNAPSHOT_URL})"
	curl -o blockchain.db.gz "${SNAPSHOT_URL:=$DEFAULT_SNAPSHOT_URL}" &> /dev/null
	if [ $? == 0 ] && [ -f blockchain.db.gz ]; then
		gunzip -q blockchain.db.gz &> /dev/null
	fi
	if [ $? != 0 ]; then
		rm -f blockchain.*
		echo "X Failed to download blockchain snapshot."
		exit 1
	else
		echo "√ Blockchain snapshot downloaded successfully."
	fi
}

restore_blockchain() {
	echo "Restoring blockchain..."
	if [ -f blockchain.db ]; then
		psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_NAME" -w < blockchain.db &> /dev/null
		rm $PGPASSFILE
	fi
	rm -f blockchain.*
	if [ $? != 0 ]; then
		echo "X Failed to restore blockchain."
		exit 1
	else
		echo "√ Blockchain restored successfully."
	fi
}

populate_database() {
	if [ "${NETWORK}" == "local" ]; then
			return
	fi

	echo "Looking for blocks table"
	psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "$DATABASE_NAME" -w -c "select * from blocks limit 1;" &> /dev/null
	if [ $? == 1 ]; then
		download_blockchain
		restore_blockchain
	else
		echo "Found blocks table"
		rm $PGPASSFILE
	fi
}

populate_database