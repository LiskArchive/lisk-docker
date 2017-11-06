.PHONY: all clean down drop-database force-restore mainnet mrproper pgadmin up
all: mainnet

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/main/blockchain.db.gz

clean:
	rm -f .pgpass blockchain.db.gz

down:
	docker rm -f mainnet_pgadmin || true
	docker-compose down --volumes
	rm -f restore

drop-database:
	docker-compose stop lisk
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/mainnet psql -w --dbname=lisk --command="drop table ready;"
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/mainnet dropdb -w lisk_main
	rm -f restore

force-restore: drop-database restore
	docker-compose start lisk

mainnet: up restore
	@echo All done; try the following: 'cd mainnet; docker-compose ps'

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

pgadmin:
	docker run --name mainnet_pgadmin --detach \
		--network=mainnet_lisk-main --publish 5080:5050 thajeztah/pgadmin4
	@echo
	@echo "pgAdmin is running at http://localhost:5080/"
	@echo "Click 'Add New Server' and use the following information:"
	@echo "  Hostname: db"
	@echo "  Username: lisk"
	@echo "  Password: password"

restore: blockchain.db.gz
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env lisk/mainnet --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/mainnet createdb -w lisk_main
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/mainnet psql -w
	docker run --rm --interactive --network=mainnet_lisk-main --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/mainnet psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

up: .pgpass
	docker-compose up -d
