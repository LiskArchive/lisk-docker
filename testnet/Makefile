.PHONY: all clean down mrproper testnet up
all: testnet

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/test/blockchain.db.gz

clean:
	rm -f .pgpass blockchain.db.gz

down:
	docker-compose down --volumes
	rm -f restore

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

restore: blockchain.db.gz
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env lisk/testnet --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet createdb -w lisk_test
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet psql -w
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

testnet: up restore

up: .pgpass
	docker-compose up -d
