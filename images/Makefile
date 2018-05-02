.PHONY: all clean testnet
all: base betanet

tag = next

base:
	make -C lisk

betanet:
	docker build --build-arg network=betanet --tag lisk/betanet:$(version) --build-arg version="$(version)" --build-arg minVersion="$(minversion)" -f Dockerfile.betanet .
