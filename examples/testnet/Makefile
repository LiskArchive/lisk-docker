.PHONY: clean coldstart mrproper up
all: up

blockchain.db.gz:
	curl -O https://downloads.lisk.io/lisk/test/blockchain.db.gz

up:
	docker-compose up -d

coldstart: blockchain.db.gz up
	docker-compose stop lisk
	docker-compose start db
	docker-compose run task dropdb --if-exists lisk_test
	docker-compose run task createdb lisk_test
	gzip --decompress --to-stdout blockchain.db.gz |docker-compose run task psql >/dev/null
	docker-compose start lisk

clean:
	rm -f blockchain.db.gz

mrproper: clean
	docker-compose down --volumes
