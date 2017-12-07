.PHONY: clean help image-mainnet image-testnet images mainnet testnet
help:
	@echo Usage:
	@echo '  make <mainnet|testnet|local>'

clean:
	make -C images clean
	make -C local clean
	make -C mainnet clean
	make -C testnet clean

image-local:
	make -C images local

image-testnet:
	make -C images testnet

image-mainnet: 
	make -C images mainnet

images: image-local image-testnet image-mainnet

local: image-local
	make -C local
	@echo
	@echo "All done; try the following:"
	@echo "> cd local; docker-compose ps"

mainnet: image-mainnet
	make -C mainnet
	@echo
	@echo "All done; try the following:"
	@echo "> cd mainnet; docker-compose ps"

mrproper: clean
	make -C local mrproper
	make -C mainnet mrproper
	make -C testnet mrproper

testnet: image-testnet
	make -C testnet
	@echo
	@echo "All done; try the following:"
	@echo "> cd testnet; docker-compose ps"
