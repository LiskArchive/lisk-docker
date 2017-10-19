# Lisk Docker

**The official Lisk docker image.** This document details how to build your own version of the image. If all you want to do is install the official Lisk docker image, please go to our public repository on Docker hub: https://hub.docker.com/u/lisk/

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

***

## Build Instructions

#### 1. Install Docker

Please refer to the [official Docker documentation](https://docs.docker.com/engine/installation)

#### 3. Build the images

Make sure `make` is installed on your system, decide which image you want to build and run:

`make -C images <local|mainnet|testnet>`

E.g. to build test testnet image:

```
make -C images testnet
```

#### 3. Run the image

`make <local|mainnet|testnet>`

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
