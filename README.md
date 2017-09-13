# Lisk Docker

**The official Lisk docker image.** This document details how to build your own version of the image. If all you want to do is install the official Lisk docker image, please go to our public repository on Docker hub: https://hub.docker.com/u/lisk/

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

***

## Build Instructions

**NOTE:** The following information is applicable to: **Ubuntu 14.04, 16.04 (LTS) or 16.10 - x86_64**.

If you are new to docker, we highly recommend reading the [Official Docker Documentation](https://docs.docker.com/) before proceeding.

#### 1. Install Docker

```
curl -sL https://downloads.lisk.io/scripts/setup_docker.Linux | sudo -E bash -
sudo apt-get install -y docker-engine
```

Add the current user to a new docker group (avoids having to use sudo for each command):

```
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
```

#### 2. Log into Docker

```
docker login {username}
```

**NOTE:** If you don't have a docker account you can sign up [here](https://hub.docker.com/).

#### 3. Build the image

```
docker build -t {image_name}:{tag} -f Dockerfile --build-arg CONTEXT={local|test|main} .
```

#### 4. Push the image

```
docker push {image_name}:{tag}
```

#### 5. Run the image

```
docker run -d --restart=always \
-p {4000:4000|7000:7000|8000:8000} \
-e DATABASE_HOST=postgresql \
-e DATABASE_NAME={lisk_local|lisk_test|lisk_main} \
-e DATABASE_USER=lisk \
-e DATABASE_PASSWORD=password \
-e REDIS_ENABLED=true \
-e REDIS_HOST=redis \
-e REDIS_PORT=6379 \
-e REDIS_DB=0 \
-e FORGING_WHITELIST_IP=127.0.0.1 \
-e LOG_LEVEL=info \
--name {localnet|testnet|mainnet} \
{image_name}:{tag}
```

For more details please read: https://docs.lisk.io/docs/core-installation-docker-main

#### 7. Archive the image

```
docker save {image_name} > lisk-docker.tar
gzip -9 lisk-docker.tar.gz
```

***

## Using lisk-docker.sh

This script provides easy management for all the essential components used by Lisk nodes. It helps to build several containers, installation process, start|stop nodes and uninstall them.
Optionally allows launching a pgadmin container which enables management of the databases directly on the browser.

#### 1. Install environment

In order to perform a Lisk-Docker installation, the following command should be run depending on the network:

```
git clone https://github.com/liskHQ/lisk-docker
cd lisk-docker
./lisk-docker.sh install {local|test|main}
```

#### 2. Starting environment

```
./lisk-docker.sh start {local|test|main}
```

#### 3. Stopping environment

```
./lisk-docker.sh stop {local|test|main}
```

#### 4. lisk-docker.sh help

```
./lisk-docker.sh
 SYNOPSIS
    lisk-docker.sh [command] args ...

 DESCRIPTION
    Lisk Docker Utility Script

 OPTIONS
    install [network] [forging ip]  Install docker containers for a specific network
                                    default network is main
                                    optional whitelist ip for forging
    start [network]                 Start the docker container for a specific network
                                    default network is main
    stop [network]                  Stop the docker container for a specific network
                                    default network is main
    forge [network] [ip]            Enable forging for a specified network
                                    default network is main
                                    ip that is allowed to enable forging
    uninstall [network]             uninstall all docker containers for a specific network
                                    default network is main
    upgrade [network]               upgrade all docker containers for a specific network
                                    default network is main
    logs [network] [args ...]       get logs for a specific network
                                    default network is main
                                    optional args:
                                    --details (Show extra details provided to logs)
                                    --follow, -f (Follow log output)
                                    --since (logs since timestamp e.g. 2013-01-02T13:23:37 or relative e.g. 42m)
                                    --tail (Number of lines to show from the end of the logs)
                                    --timestamps, -t (Show timestamps)
    reset [network] [url]           Reset the database and start syncing blocks again.
                                    default network is main
                                    Optianal snapshot url, default is from LiskHQ
    ssh [network]                   Log in to the container for a specific network
                                    default network is main
    status                          Prints the status of lisk-docker.
    pgadmin [command] [password]    Starts or stops pgadmin.
                                    valid options for command: start, stop, changepw, uninstall
                                    optional password to set for logging in
    help                            Outputs utility help
    version                         Outputs script version

 EXAMPLES
    lisk-docker.sh start main

 IMPLEMENTATION
    version         lisk-docker.sh 0.0.1
    author          Ruben Callewaert (https://github.com/5an1ty/)
    license         GNU General Public License v3.0

```

## Using Docker Compose

#### 1. Starting a container with Docker Compose

In order to perform a Lisk-Docker installation, the following command should be run depending on the network:

** Mainnet **
```
wget https://raw.githubusercontent.com/LiskHQ/lisk-docker/development/docker-compose-liskmain.yml
docker-compose -f docker-compose-liskmain.yml up -d
```

** Testnet **
```
wget https://raw.githubusercontent.com/LiskHQ/lisk-docker/development/docker-compose-lisktest.yml
docker-compose -f docker-compose-lisktest.yml up -d
```

#### 2. Stopping a container with Docker Compose

** Mainnet **
```
docker-compose -f docker-compose-liskmain.yml down
```

** Testnet **
```
docker-compose -f docker-compose-lisktest.yml down
```

### 3. Enable forging using docker compose

Edit the compose files and change the following to your ip:

```
FORGING_WHITELIST_IP=172.0.0.1
```

### 4. Starting two environments (testnet and mainnet) at once

```
wget https://raw.githubusercontent.com/LiskHQ/lisk-docker/development/docker-compose-liskcombo.yml
docker-compose -f docker-compose-liskcombo.yml up -d
```

## Useful Commands
The next lines can be added on `~/.bash_aliases` to make Docker household easier:

```
# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'
```

***

## Authors

- Oliver Beddows <oliver@lightcurve.io>
- Michael Schmoock <michael@schmoock.net>
- Isabella Dell <isabella@lightcurve.io>
- Ruben Callewaert <rubencallewaertdev@gmail.com>
- Diego Garcia <diego@lightcurve.io>

## License

Copyright © 2016-2017 Lisk Foundation

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](https://github.com/LiskHQ/lisk-docker/tree/master/LICENSE) along with this program.  If not, see <http://www.gnu.org/licenses/>.

***

This program also incorporates work previously released with lisk-docker `1.3.3` (and earlier) versions under the [MIT License](https://opensource.org/licenses/MIT). To comply with the requirements of that license, the following permission notice, applicable to those parts of the code only, is included below:

Copyright © 2016-2017 Lisk Foundation  
Copyright © 2015 Crypti

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
