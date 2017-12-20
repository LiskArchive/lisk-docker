.PHONY: all clean local
all: local

development.tar.gz:
	curl -O --location https://github.com/LiskHQ/lisk/archive/development.tar.gz

local: development.tar.gz
	docker build --build-arg network=local --tag lisk/local .

clean:
	rm -f development.tar.gz lisk-*.tar.gz
