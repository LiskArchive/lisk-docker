.PHONY: all clean down drop-database force-restore local mrproper pgadmin up
all: local

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/local/blockchain.db.gz

clean:
	rm -f .pgpass blockchain.db.gz

down:
	docker rm -f local_pgadmin || true
	docker-compose down --volumes
	rm -f restore

drop-database:
	docker-compose stop lisk
	docker run --rm --interactive --network=local_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local psql -w --dbname=lisk --command="drop table ready;"
	docker run --rm --interactive --network=local_lisk-test --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local dropdb -w lisk_test
	rm -f restore

force-restore: drop-database restore
	docker-compose start lisk

local: up restore
	@echo All done; try the following: 'cd local; docker-compose ps'

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

pgadmin:
	docker run --name local_pgadmin --detach \
		--network=local_lisk-test --publish 5040:5050 thajeztah/pgadmin4
	@echo
	@echo "pgAdmin is running at http://localhost:5040/"
	@echo "Click 'Add New Server' and use the following information:"
	@echo "  Hostname: db"
	@echo "  Username: lisk"
	@echo "  Password: password"

restore: blockchain.db.gz
	docker run --rm --interactive --network=local_lisk-local --env-file db.env lisk/local --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass psql -w --dbname=lisk --command="\d ready" >/dev/null 2>&1 || sleep 10
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local createdb -w lisk_local
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local psql -w
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volume $(shell pwd)/.pgpass:/home/lisk/.pgpass lisk/local psql -w --dbname=lisk --command="create table ready(id int);"
	touch restore

up: .pgpass
	docker-compose up -d
