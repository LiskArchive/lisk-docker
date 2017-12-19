.PHONY: all clean lisk-base mainnet testnet

all: local mainnet testnet

clean:
	make -C lisk clean
	make -C lisk-dev clean

lisk-base:
	make -C lisk-base

local: lisk-base
	make -C lisk-dev

mainnet: lisk-base
	make -C lisk main

testnet: lisk-base
	make -C lisk test
