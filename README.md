# Lisk Docker

**The official Lisk docker image.** This document details how to build your own version of the image. If all you want to do is install the official Lisk docker image, please go to our public repository on Docker hub: https://hub.docker.com/u/lisk/

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

***

## Prerequisites

### Install Docker

Please refer to the [official Docker documentation](https://docs.docker.com/engine/installation)

### Install make

Install `make` on your system.

## Build Instructions

### Build the images

Decide which image you want to build and run:

`make -C images <local|mainnet|testnet>`

E.g. to build test testnet image:

```
make -C images testnet
```

### Run the images

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
                                    valid options for command: install, start, stop, changepw, uninstall
                                    optional password to set for logging in
    help                            Outputs utility help
    version                         Outputs script version

 EXAMPLES
    lisk-docker.sh start main

 IMPLEMENTATION
    version         lisk-docker.sh 0.0.1
    author          Ruben Callewaert (https://github.com/5an1ty/)
    license         GNU General Public License v3.0

E.g. to run a testnet image:

```
make testnet
```

***

## Authors

- Oliver Beddows <oliver@lightcurve.io>
- Michael Schmoock <michael@schmoock.net>
- Isabella Dell <isabella@lightcurve.io>
- Ruben Callewaert <rubencallewaertdev@gmail.com>
- Diego Garcia <diego@lightcurve.io>
- François Chavant <francois@lightcurve.io>

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
