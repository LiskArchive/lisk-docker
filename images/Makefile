.PHONY: all lisk-base mainnet testnet

all: local mainnet testnet

lisk-base:
	make -C lisk-base

local: lisk-base
	make -C lisk-dev

mainnet: lisk-base
	make -C lisk main

testnet: lisk-base
	make -C lisk test
