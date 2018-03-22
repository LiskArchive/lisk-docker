.PHONY: all clean testnet
all: testnet mainnet

tag = next

clean:
	rm -f *-lisk-Linux-x86_64.tar.gz*

mainnet-lisk-Linux-x86_64.tar.gz:
	curl --fail https://downloads.lisk.io/lisk/main/lisk-Linux-x86_64.tar.gz --output mainnet-lisk-Linux-x86_64.tar.gz
	curl --fail https://downloads.lisk.io/lisk/main/lisk-Linux-x86_64.tar.gz.SHA256 --output mainnet-lisk-Linux-x86_64.tar.gz.SHA256
	sed -i 's/  \(lisk-Linux-x86_64.tar.gz\)/  mainnet-\1/' mainnet-lisk-Linux-x86_64.tar.gz.SHA256
	sha256sum -c mainnet-lisk-Linux-x86_64.tar.gz.SHA256

mainnet: mainnet-lisk-Linux-x86_64.tar.gz
	docker build --build-arg network=mainnet --tag lisk/mainnet:$(tag) .

testnet-lisk-Linux-x86_64.tar.gz:
	curl --fail https://downloads.lisk.io/lisk/test/lisk-Linux-x86_64.tar.gz --output testnet-lisk-Linux-x86_64.tar.gz
	curl --fail https://downloads.lisk.io/lisk/test/lisk-Linux-x86_64.tar.gz.SHA256 --output testnet-lisk-Linux-x86_64.tar.gz.SHA256
	sed -i 's/  \(lisk-Linux-x86_64.tar.gz\)/  testnet-\1/' testnet-lisk-Linux-x86_64.tar.gz.SHA256
	sha256sum -c testnet-lisk-Linux-x86_64.tar.gz.SHA256

testnet: testnet-lisk-Linux-x86_64.tar.gz
	docker build --tag lisk/testnet:$(tag) .

