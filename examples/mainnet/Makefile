.PHONY: clean coldstart mrproper up
all: up

lisk_net = main
lisk_database = lisk_$(lisk_net)

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/$(lisk_net)/blockchain.db.gz

up:
	docker-compose up -d

coldstart: blockchain.db.gz up
	docker-compose stop lisk
	docker-compose start db
	docker-compose run --rm task dropdb --if-exists $(lisk_database)
	docker-compose run --rm task createdb $(lisk_database)
	@echo Restoring database snapshot. This can take a few minutes.
	gzip --decompress --to-stdout blockchain.db.gz |docker-compose run --rm task psql >/dev/null
	docker-compose start lisk

clean:
	rm -f blockchain.db.gz

mrproper: clean
	docker-compose down --volumes
