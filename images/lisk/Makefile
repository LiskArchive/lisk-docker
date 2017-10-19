.PHONY: all clean test
all: test

lisk-source.tar.gz:
	curl -O https://downloads.lisk.io/lisk/test/lisk-source.tar.gz

lisk-node-Linux-x86_64.tar.gz:
	curl -O https://downloads.lisk.io/lisk-node/lisk-node-Linux-x86_64.tar.gz

test: lisk-source.tar.gz lisk-node-Linux-x86_64.tar.gz
	docker build --build-arg network=test --tag lisk/testnet .

main: lisk-source.tar.gz lisk-node-Linux-x86_64.tar.gz
	docker build --build-arg network=main --tag lisk/mainnet .

clean:
	rm -f lisk-*.tar.gz
