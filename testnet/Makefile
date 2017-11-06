.PHONY: all clean down drop-database force-restore mrproper pgadmin testnet up
all: testnet

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/test/blockchain.db.gz

clean:
	rm -f .pgpass blockchain.db.gz

down:
	docker rm -f testnet_pgadmin || true
	docker-compose down --volumes
	rm -f restore

drop-database:
	docker-compose stop lisk
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet psql -w --dbname=lisk --command="drop table ready;"
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet dropdb -w lisk_test
	rm -f restore

force-restore: drop-database restore
	docker-compose start lisk

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

pgadmin:
	docker run --name testnet_pgadmin --detach \
		--network=testnet_lisk-test --publish 5070:5050 thajeztah/pgadmin4
	@echo
	@echo "pgAdmin is running at http://localhost:5070/"
	@echo "Click 'Add New Server' and use the following information:"
	@echo "  Hostname: db"
	@echo "  Username: lisk"
	@echo "  Password: password"

restore: blockchain.db.gz
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env lisk/testnet --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet createdb -w lisk_test
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet psql -w
	docker run --rm --interactive --network=testnet_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/testnet psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

testnet: up restore
	@echo
	@echo "All done; try the following:"
	@echo "> cd testnet; docker-compose ps"

up: .pgpass
	docker-compose up -d
