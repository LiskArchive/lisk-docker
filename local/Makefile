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

drop-database: up
	docker-compose stop lisk
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volumes-from=local_lisk-config_1 lisk/local psql -w --dbname=postgres --command="DROP DATABASE IF EXISTS lisk_local;"
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volumes-from=local_lisk-config_1 lisk/local createdb -w lisk_restoring || true
	rm -f restore

force-restore: drop-database restore
	docker-compose start lisk

local: restore
	@echo
	@echo "All done; try the following:"
	@echo "> cd local; docker-compose ps"

mrproper: down clean

.pgpass:
	echo "*:*:*:*:$(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )" >.pgpass
	chmod 0600 .pgpass

pgadmin:
	docker run --name local_pgadmin --detach \
		--network=local_lisk-local --publish 5040:5050 thajeztah/pgadmin4
	@echo
	@echo "pgAdmin is running at http://localhost:5040/"
	@echo "Click 'Add New Server' and use the following information:"
	@echo "  Hostname: $(shell grep PGHOST db.env |cut -d "=" -f 2 )"
	@echo "  Username: $(shell grep PGUSER db.env |cut -d "=" -f 2 )"
	@echo "  Password: $(shell grep POSTGRES_PASSWORD db.env |cut -d "=" -f 2 )"

restore: blockchain.db.gz up
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volumes-from=local_lisk-config_1 lisk/local psql -w --dbname=lisk_restoring --command="\d" >/dev/null 2>&1 || sleep 10
	gzip --decompress --to-stdout blockchain.db.gz |docker run --rm --interactive --network=local_lisk-local --env-file db.env --volumes-from=local_lisk-config_1 lisk/local psql -w --dbname=lisk_restoring
	docker run --rm --interactive --network=local_lisk-local --env-file db.env --volumes-from=local_lisk-config_1 lisk/local psql -w --dbname=postgres --command="ALTER DATABASE lisk_restoring RENAME TO lisk_local;"
	touch restore

up: .pgpass
	docker-compose up -d
