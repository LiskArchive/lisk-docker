#!/bin/bash

if [[ "$1" == "main" || "$1" == "test" || "$1" == "local" ]]; then
  echo "Installing $1"
else
  echo "Not a valid context, options are: main, test, local!"
  exit 1
fi

cd /home/lisk

if  [ $1 == "local" ]; then

  sudo npm install -g babel-cli

  git clone --recursive https://github.com/LiskHQ/lisk.git src
  cd src
  npm install --production

  # set container to use test config from ./test
  cp ./test/config.json ./config.json
  cp ./test/genesisBlock.json ./genesisBlock.json
  cp ./test/genesisDelegates.json ./genesisDelegates.json
  # fix config.json to local settings
  sed -i 's/lisk_test/lisk_local/g' config.json
  sed -i 's/"masterpassword": ""/"masterpassword": "local"/g' config.json

else

  echo $1 > ./NETWORK
  wget -nv https://downloads.lisk.io/lisk/$1/lisk-source.tar.gz -O lisk-source.tar.gz
  tar -zxvf lisk-source.tar.gz
  mv -f lisk-source src
  rm lisk-source.tar.gz
  cd src
  npm install --production
  sed -i 's/"public": false,/"public": true,/g' config.json

fi

# Install Lisk Node
wget -nv https://downloads.lisk.io/lisk-node/lisk-node-Linux-x86_64.tar.gz -O lisk-node-Linux-x86_64.tar.gz
tar -zxvf lisk-node-Linux-x86_64.tar.gz
rm lisk-node-Linux-x86_64.tar.gz

if [ $1 == "local" ]; then
  sudo npm install -g babel
  cd /home/lisk
  git clone https://github.com/LiskHQ/lisky.git
  cd lisky

  npm install
  npm run build
  sudo npm install --global --production
  cd /home/lisk
  rm -r lisky
else
  sudo npm install --global --production lisky
  sudo sed '$d' /etc/sudoers
fi
