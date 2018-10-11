# Lisk Docker

The official Lisk docker images can be found in our public repository on the Docker Hub: https://hub.docker.com/u/lisk/

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

***

## Prerequisites

### Install Docker Engine and Docker Compose

Please refer to the official documentation for
 - [Docker Engine](https://docs.docker.com/engine/installation) and
 - [Docker Compose](https://docs.docker.com/compose/install/)

### Install make

Install `make` on your system.

## Usage

There are example `.env` files for `mainnet`, `testnet` and `development` in the `examples/` directory.
A `Makefile` is also included to make restoring from a snapshot easier.

All commands must be run in the directory where the `docker-compose.yml` file lives.

### Start Lisk

```
make up
```

### Rebuild database from snapshot

```
make coldstart
```

### Rebuild database from latest snapshot

Delete any previously downloaded blockchain.db.gz ensure the latest is downloaded:

```
make clean
make coldstart
```

### Stop Lisk

```
docker-compose stop
```


### Delete all containers

```
docker-compose down --volumes
```

## Contributors

https://github.com/LiskHQ/lisk-docker/graphs/contributors

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
