check-tag:
	@: $(if $(tag),,$(error $$tag must be set))
	@echo Tag: $(tag)

.PHONY: clean
clean:
	rm -f lisk-*-Linux-x86_64.tar.gz*

# different flavours will never have the same version number (tag)
lisk-%-Linux-x86_64.tar.gz: check-tag
	wget --no-verbose --continue https://downloads.lisk.io/lisk/$(network)/$(tag)/lisk-$(tag)-Linux-x86_64.tar.gz
	wget --no-verbose --continue https://downloads.lisk.io/lisk/$(network)/$(tag)/lisk-$(tag)-Linux-x86_64.tar.gz.SHA256
	sha256sum -c lisk-$(tag)-Linux-x86_64.tar.gz.SHA256

.PHONY: betanet
betanet: network=beta
betanet: check-tag lisk-$(tag)-Linux-x86_64.tar.gz
	docker build --pull --build-arg tag=$(tag) --tag lisk/$@:$(tag) .

.PHONY: development
development: network=development
development: check-tag lisk-$(tag)-Linux-x86_64.tar.gz
	docker build --pull --build-arg tag=$(tag) --tag lisk/$@:$(tag) .

.PHONY: testnet
testnet: network=test
testnet: check-tag lisk-$(tag)-Linux-x86_64.tar.gz
	docker build --pull --build-arg tag=$(tag) --tag lisk/$@:$(tag) .

.PHONY: mainnet
mainnet: network=main
mainnet: check-tag lisk-$(tag)-Linux-x86_64.tar.gz
	docker build --pull --build-arg tag=$(tag) --tag lisk/$@:$(tag) .
