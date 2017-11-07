.PHONY: all clean test
all: test

test-lisk-source.tar.gz:
	curl https://downloads.lisk.io/lisk/test/lisk-source.tar.gz --output test-lisk-source.tar.gz

main-lisk-source.tar.gz:
	curl https://downloads.lisk.io/lisk/main/lisk-source.tar.gz --output main-lisk-source.tar.gz

lisk-node-Linux-x86_64.tar.gz:
	curl -O https://downloads.lisk.io/lisk-node/lisk-node-Linux-x86_64.tar.gz

test: test-lisk-source.tar.gz lisk-node-Linux-x86_64.tar.gz
	# the ADD instruction does support build-time variables
	rm -f lisk-source.tar.gz
	ln test-lisk-source.tar.gz lisk-source.tar.gz
	docker build --build-arg network=test --tag lisk/testnet .

main: main-lisk-source.tar.gz lisk-node-Linux-x86_64.tar.gz
	rm -f lisk-source.tar.gz
	ln main-lisk-source.tar.gz lisk-source.tar.gz
	docker build --build-arg network=main --tag lisk/mainnet .

clean:
	rm -f lisk-*.tar.gz
