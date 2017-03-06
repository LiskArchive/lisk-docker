# Lisk Docker

**The official Lisk docker image.** This document details how to build your own version of the image. If all you want to do is install the official Lisk docker image, please read the following: https://github.com/LiskHQ/lisk-wiki/wiki/Docker-Install

***

## Build Instructions

**NOTE:** The following is applicable to: **Ubuntu 14.04 (LTS) - x86_64**.

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

## License

The MIT License (MIT)  

Copyright (c) 2016-2017 Lisk  
Copyright (c) 2015 Crypti  

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:  

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
