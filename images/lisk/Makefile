.PHONY: all clean testnet
all: testnet mainnet

testnet-lisk-Linux-x86_64.tar.gz:
	curl https://downloads.lisk.io/lisk/test/lisk-Linux-x86_64.tar.gz --output testnet-lisk-Linux-x86_64.tar.gz

mainnet-lisk-Linux-x86_64.tar.gz:
	curl https://downloads.lisk.io/lisk/main/lisk-Linux-x86_64.tar.gz --output mainnet-lisk-Linux-x86_64.tar.gz

testnet: testnet-lisk-Linux-x86_64.tar.gz
	# the ADD instruction does not support build-time variables
	rm -f lisk-Linux-x86_64.tar.gz
	ln testnet-lisk-Linux-x86_64.tar.gz lisk-Linux-x86_64.tar.gz
	docker build --tag lisk/testnet .

mainnet: mainnet-lisk-Linux-x86_64.tar.gz
	rm -f lisk-Linux-x86_64.tar.gz
	ln mainnet-lisk-Linux-x86_64.tar.gz lisk-Linux-x86_64.tar.gz
	docker build --tag lisk/mainnet .

clean:
	rm -f *lisk-Linux-x86_64.tar.gz
