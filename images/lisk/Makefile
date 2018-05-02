.PHONY: all clean testnet
all: base

tag = latest

base:
	docker build --build-arg network=betanet --tag lisk/base:$(tag) .
