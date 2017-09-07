#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} [-spdulrhv] args ...
#%
#% DESCRIPTION
#%    Lisk Docker Utility Script
#%
#% OPTIONS
#%    -s [network], --start [network]                 Start All docker containers for a specific network
#%                                                    default network is main
#%    -p [network], --stop [network]                  Stop all docker containers for a specific network
#%                                                    default network is main
#%    -d [network], --delete [network]                uninstall all docker containers for a specific network
#%                                                    default network is main
#%    -u [network], --upgrade [network]               upgrade all docker containers for a specific network
#%                                                    default network is main
#%    -l [network], --logs [network] [args ...]       get logs for a specific network
#%                                                    default network is main
#%                                                    optional args:
#%                                                    --details (Show extra details provided to logs)
#%                                                    --follow, -f (Follow log output)
#%                                                    --since (logs since timestamp e.g. 2013-01-02T13:23:37 or relative e.g. 42m)
#%                                                    --tail (Number of lines to show from the end of the logs)
#%                                                    --timestamps, -t (Show timestamps)
#%    -r [network] [url], --reset [network] [url]     Reset the database and start syncing blocks again.
#%                                                    Optianal snapshot url, default is from LiskHQ
#%    -h, --help                                      Print this help
#%    -v, --version                                   Print script information
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} -s main
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} 0.0.1
#-    author          Ruben Callewaert
#-    license         GNU General Public License
#-
#================================================================
# END_OF_HEADER
#================================================================

 #== needed variables ==#
SCRIPT_HEADSIZE=$(head -200 ${0} |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename ${0})"

  #== usage functions ==#
usage() { printf "Usage: "; head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

start() {
  docker network inspect lisk &> /dev/null
  if [ $? != 0 ]; then
    docker network create lisk
  fi

  if [ "$1" == "main" ]
  then
    NAME=mainnet
    DB=lisk_main
    IMAGE=lisk/mainnet:latest
    PORT=8000
  elif [ "$1" == "test" ]
  then
    NAME=testnet
    DB=lisk_test
    IMAGE=lisk/testnet:latest
    PORT=7000
  else
    NAME=localnet
    DB=lisk_local
    IMAGE=lisk-docker:latest
    PORT=4000
  fi

  if [ ! "$(docker ps -q -f name=postgresql)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=postgresql)" ]; then
      docker start postgresql
    else
      docker run -d --restart=always \
      -e POSTGRES_USER=lisk \
      -e POSTGRES_PASSWORD=password \
      --name postgresql \
      --net lisk \
      postgres:9.6.3
    fi
  fi

  if [ ! "$(docker ps -q -f name=pgadmin)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=pgadmin)" ]; then
      docker start pgadmin
    else
      docker run  -d --restart=always \
      -p 5050:5050 \
      -e DEFAULT_USER=admin \
      -e DEFAULT_PASSWORD=admin \
      --name pgadmin \
      --net lisk \
      fenglc/pgadmin4
    fi
  fi

  if [ ! "$(docker ps -q -f name=${NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then
      docker start ${NAME}
    else
      docker run -d --restart=always \
      -p ${PORT}:${PORT} \
      -e DATABASE_HOST=postgresql \
      -e DATABASE_NAME=${DB} \
      -e DATABASE_USER=lisk \
      -e DATABASE_PASSWORD=password \
      -e LOG_LEVEL=info \
      --name ${NAME} \
      --net lisk \
      ${IMAGE}
    fi
  fi
}

stop() {
  if [ "$1" == "main" ]
  then
    NAME=mainnet
  elif [ "$1" == "test" ]
  then
    NAME=testnet
  else
    NAME=localnet
  fi
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME}; fi
}

upgrade() {
  if [ "$1" == "main" ]
  then
    NAME=mainnet
    IMAGE=lisk/mainnet:latest
    PORT=8000
  elif [ "$1" == "test" ]
  then
    NAME=testnet
    IMAGE=lisk/testnet:latest
    PORT=7000
  fi
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME} &> /dev/null; fi
  docker rm ${NAME} &> /dev/null
  docker pull ${IMAGE} &> /dev/null
  docker run -d --restart=always \
    -p ${PORT}:${PORT} \
    -e DATABASE_HOST=postgresql \
    -e DATABASE_NAME=${DB} \
    -e DATABASE_USER=lisk \
    -e DATABASE_PASSWORD=password \
    -e LOG_LEVEL=info \
    --name ${NAME} \
    --net lisk \
    ${IMAGE}
}

uninstall() {
  if [ "$1" == "main" ]
  then
    NAME=mainnet
    OTHER1=testnet
    OTHER2=localnet
  elif [ "$1" == "test" ]
  then
    NAME=testnet
    OTHER1=mainnet
    OTHER2=localnet
  else
    NAME=localnet
    OTHER1=mainnet
    OTHER2=testnet
  fi
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME} &> /dev/null; fi
  docker rm ${NAME} &> /dev/null

  if [ ! "$(docker ps -q -f name=${OTHER1})" ]; then
    if [ ! "$(docker ps -aq -f status=exited -f name=${OTHER1})" ]; then
      if [ ! "$(docker ps -q -f name=${OTHER2})" ]; then
        if [ ! "$(docker ps -aq -f status=exited -f name=${OTHER2})" ]; then
          if [ "$(docker ps -q -f name=pgadmin)" ]; then docker stop pgadmin &> /dev/null; fi
          docker rm pgadmin &> /dev/null
          if [ "$(docker ps -q -f name=postgresql)" ]; then docker stop postgresql &> /dev/null; fi
          docker rm postgresql &> /dev/null
          docker network rm lisk &> /dev/null
        fi
      fi
    fi
  fi
}

logs() {
  if [ "$1" == "main" ]
  then
    NAME=mainnet
  elif [ "$1" == "test" ]
  then
    NAME=testnet
  else
    NAME=localnet
  fi
  shift
  docker logs $@ ${NAME}
}

reset() {
  if [ "$1" == "main" ]
  then
    NAME=mainnet
    DB=lisk_main
    IMAGE=lisk/mainnet:latest
  elif [ "$1" == "test" ]
  then
    NAME=testnet
    DB=lisk_test
    IMAGE=lisk/testnet:latest
  else
    NAME=localnet
    DB=lisk_local
    IMAGE=lisk-docker:latest
  fi
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME} &> /dev/null; fi
  sleep 5
  if [ -z "$2" ]
  then
    docker run --rm \
      -e DATABASE_HOST=postgresql \
      -e DATABASE_NAME=${DB} \
      -e DATABASE_USER=lisk \
      -e DATABASE_PASSWORD=password \
      -e LOG_LEVEL=info \
      --net lisk \
      ${IMAGE} \
      reset
  else
    docker run --rm \
      -e DATABASE_HOST=postgresql \
      -e DATABASE_NAME=${DB} \
      -e DATABASE_USER=lisk \
      -e DATABASE_PASSWORD=password \
      -e LOG_LEVEL=info \
      -e SNAPSHOT_URL="$2" \
      --net lisk \
      ${IMAGE} \
      reset
  fi
  docker start ${NAME} &> /dev/null
}

case "$1" in
  -s|--start)
    echo "starting lisk-docker..."
    INPUT=${2:-main}
    if [[ "$INPUT" == "main" || "$INPUT" == "test" || "$INPUT" == "local" ]]; then
        start $INPUT
    else 
      echo "Incorrect network, valid options are: main, test, local"
    fi
    ;;
  -p|--stop)
    echo "stopping lisk-docker..."
    INPUT=${2:-main}
    if [[ "$INPUT" == "main" || "$INPUT" == "test" || "$INPUT" == "local" ]]; then
        stop $INPUT
    else 
      echo "Incorrect network, valid options are: main, test, local"
    fi
    ;;
  -d|--delete)
    echo "deleting lisk-docker..."
    INPUT=${2:-main}
    if [[ "$INPUT" == "main" || "$INPUT" == "test" || "$INPUT" == "local" ]]; then
        uninstall $INPUT
    else 
      echo "Incorrect network, valid options are: main, test, local"
    fi
    ;;
  -u|--upgrade)
    echo "upgrading lisk-docker..."
    INPUT=${2:-main}
    if [[ "$INPUT" == "main" || "$INPUT" == "test" ]]; then
        upgrade $INPUT
    else 
      echo "Incorrect network, valid options are: main, test"
    fi
    ;;
  -l|--logs)
    INPUT=${2:-main}
    shift
    shift
    if [[ "$INPUT" == "main" || "$INPUT" == "test" || "$INPUT" == "local" ]]; then
        logs $INPUT $@
    else 
      echo "Incorrect network, valid options are: main, test, local"
    fi
    ;;
  -r|--reset)
    echo "resetting lisk-docker..."
    INPUT=${2:-main}
    shift
    shift
    if [[ "$INPUT" == "main" || "$INPUT" == "test" || "$INPUT" == "local" ]]; then
        reset $INPUT $3
    else 
      echo "Incorrect network, valid options are: main, test, local"
    fi
    ;;
  -v|--version)
    scriptinfo
    ;;
  *)
    usagefull
    ;;
esac