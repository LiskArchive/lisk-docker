#!/bin/bash

# generate config
confd -onetime -backend env

# launch Lisk Core
export PATH=/home/lisk/lisk-Linux-x86_64/bin:$PATH
export LD_LIBRARY_PATH=/home/lisk/lisk-Linux-x86_64/pgsql/lib
node app.js
