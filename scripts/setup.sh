#!/bin/bash
sudo chown lisk:lisk ./lisk
sudo -E -u lisk ./entrypoint.sh $(cat ./NETWORK)