.PHONY: help image-mainnet image-testnet images mainnet testnet
help:
	@echo Usage:
	@echo '  make <mainnet|testnet|local>'

image-local:
	make -C images local

image-testnet:
	make -C images testnet

image-mainnet: 
	make -C images mainnet

images: image-local image-testnet image-mainnet

local: image-local
	make -C local

mainnet: image-mainnet
	make -C mainnet

testnet: image-testnet
	make -C testnet
