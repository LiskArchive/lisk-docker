# Lisk Docker

**The official Lisk docker image.** This document details how to build your own version of the image. If all you want to do is install the official Lisk docker image, please read the following: https://docs.lisk.io/docs/core-pre-installation-docker

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
docker login username
```

**NOTE:** If you don't have a docker account you can sign up [here](https://hub.docker.com/).

#### 3. Build the image

```
docker build -t username/lisk:latest -f Dockerfile.test .
```

#### 4. Tag the image

```
docker tag username/lisk:latest username/lisk:version
```

#### 5. Push the image

```
docker push username/lisk
```

#### 6. Run the image

```
docker run -d --restart=always -p 0.0.0.0:7000:7000 username/lisk
```

For more details please read: https://github.com/LiskHQ/lisk-wiki/wiki/Docker-Install

#### 7. Archive the image

```
docker save username/lisk > lisk-docker.tar
gzip -9 lisk-docker.tar.gz
```

***

## Using Docker Compose 

#### 1. Starting a container with Docker Compose

In order to start a Lisk-Docker installation, the following command should be run depending on the network:

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


#### 3. Using an external postgresql database

Passing the following environment variables to the container using `-e VARX=VALX` will allow you to connect to an external postgresql server or container:

- DATABASE_HOST
- DATABASE_PORT
- DATABASE_NAME
- DATABASE_USER
- DATABASE_PASSWORD

#### 4. Docker Compose File Usage

Example:

```
version: '3'
services:
  lisk-node:
    restart: always
    image: lisk/mainnet:latest
    ports:
      - "8000:8000"
    environment:
      - DATABASE_HOST=postgresql
      - DATABASE_NAME=lisk_main
      - DATABASE_USER=lisk_main
      - DATABASE_PASSWORD=password
    links:
      - PostgreSQL:postgresql
  PostgreSQL:
    restart: always
    image: postgres:9.6.3
    environment:
      - POSTGRES_USER=lisk_main
      - POSTGRES_PASSWORD=password
```

## Useful Commands

#### Removing dangling images

```
docker rmi $(docker images -q -f "dangling=true")
```

#### Removing exited containers

```
docker rm $(docker ps -q -f status=exited)
```

***

## Authors

- Oliver Beddows <oliver@lightcurve.io>
- Michael Schmoock <michael@schmoock.net>
- Isabella Dell <isabella@lightcurve.io>
- Ruben Callewaert <rubencallewaertdev@gmail.com>

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
