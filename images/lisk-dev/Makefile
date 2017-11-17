.PHONY: all clean local
all: local

development.tar.gz:
	curl -O --location https://github.com/LiskHQ/lisk/archive/development.tar.gz

lisk-node-Linux-x86_64.tar.gz:
	curl -O https://downloads.lisk.io/lisk-node/lisk-node-Linux-x86_64.tar.gz

local: development.tar.gz lisk-node-Linux-x86_64.tar.gz
	docker build --build-arg network=local --tag lisk/local .

clean:
	rm -f development.tar.gz lisk-*.tar.gz
