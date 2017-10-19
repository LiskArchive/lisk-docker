.PHONY: all clean mainnet mrproper up
all: mainnet

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/main/blockchain.db.gz

clean:
	rm -f blockchain.db.gz

down:
	docker-compose down --volumes
	rm -f restore

mainnet: up restore

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

restore: blockchain.db.gz
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env lisk/mainnet --volume ${PWD}/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --tty --network=mainnet_lisk-main --env-file db.env --volume ${PWD}/.pgpass:/home/lisk/.pgpass lisk/mainnet createdb -w lisk_main
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume ${PWD}/.pgpass:/home/lisk/.pgpass lisk/mainnet psql -w
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume ${PWD}/.pgpass:/home/lisk/.pgpass lisk/mainnet psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

up: .pgpass
	docker-compose up -d
