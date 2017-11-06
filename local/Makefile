.PHONY: all clean down local mrproper up
all: local

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/local/blockchain.db.gz

clean:
	rm -f blockchain.db.gz

down:
	docker-compose down --volumes
	rm -f restore

local: up restore
	@echo All done; try the following: 'cd local; docker-compose ps'

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

restore: blockchain.db.gz
	docker run --rm --interactive --network=local_lisk-local --env-file db.env lisk/local --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local createdb -w lisk_local
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local psql -w
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

up: .pgpass
	docker-compose up -d
