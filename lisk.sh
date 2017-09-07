#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} [command] args ...
#%
#% DESCRIPTION
#%    Lisk Docker Utility Script
#%
#% OPTIONS
#%    start [network] [forging ip]    Start All docker containers for a specific network
#%                                    default network is main
#%    stop [network]                  Stop all docker containers for a specific network
#%                                    default network is main
#%    uninstall [network]             uninstall all docker containers for a specific network
#%                                    default network is main
#%    upgrade [network] [forging ip]  upgrade all docker containers for a specific network
#%                                    default network is main
#%    logs [network] [args ...]       get logs for a specific network
#%                                    default network is main
#%                                    optional args:
#%                                    --details (Show extra details provided to logs)
#%                                    --follow, -f (Follow log output)
#%                                    --since (logs since timestamp e.g. 2013-01-02T13:23:37 or relative e.g. 42m)
#%                                    --tail (Number of lines to show from the end of the logs)
#%                                    --timestamps, -t (Show timestamps)
#%    reset [network] [url]           Reset the database and start syncing blocks again.
#%                                    default network is main
#%                                    Optianal snapshot url, default is from LiskHQ
#%    ssh [network]                   Log in to the container for a specific network
#%                                    default network is main
#%    status                          Prints the status of lisk-docker.
#%    help                            Print this help
#%    version                         Print script information
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} start main
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} 0.0.1
#-    author          Ruben Callewaert (https://github.com/5an1ty/)
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
  FORGINGWHITELISTIP=$2

  docker network inspect lisk &> /dev/null
  if [ $? != 0 ]; then
    docker network create lisk
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

  if [ ! "$(docker ps -q -f name=redis)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=redis)" ]; then
      docker start redis
    else
      docker run -d --restart=always \
      --net lisk \
      --name redis \
      redis
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
      -e REDIS_ENABLED=true \
      -e REDIS_HOST=redis \
      -e REDIS_PORT=6379 \
      -e REDIS_DB=${REDISINSTANCE} \
      -e FORGING_WHITELIST_IP=${FORGINGWHITELISTIP:=127.0.0.1} \
      -e LOG_LEVEL=info \
      --name ${NAME} \
      --net lisk \
      ${IMAGE}
    fi
  fi
}

stop() {
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME}; fi
  docker rm ${NAME}
}

upgrade() {
  FORGINGWHITELISTIP=$2
  if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME} &> /dev/null; fi
  docker rm ${NAME} &> /dev/null
  if [ "$1" != "local" ]; then docker pull ${IMAGE} &> /dev/null; fi
  docker run -d --restart=always \
    -p ${PORT}:${PORT} \
    -e DATABASE_HOST=postgresql \
    -e DATABASE_NAME=${DB} \
    -e DATABASE_USER=lisk \
    -e DATABASE_PASSWORD=password \
    -e REDIS_ENABLED=true \
    -e REDIS_HOST=redis \
    -e REDIS_PORT=6379 \
    -e REDIS_DB=${REDISINSTANCE} \
    -e FORGING_WHITELIST_IP=${FORGINGWHITELISTIP:=127.0.0.1} \
    -e LOG_LEVEL=info \
    --name ${NAME} \
    --net lisk \
    ${IMAGE}
}

uninstall() {
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
          if [ "$(docker ps -q -f name=redis)" ]; then docker stop redis &> /dev/null; fi
          docker rm redis &> /dev/null
          if [ "$(docker ps -q -f name=postgresql)" ]; then docker stop postgresql &> /dev/null; fi
          docker network rm lisk &> /dev/null
        fi
      fi
    fi
  fi
}

logs() {
  shift
  docker logs $@ ${NAME}
}

reset() {
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

ssh() {
  docker exec -it ${NAME} /bin/bash
}

status() {
  docker ps
}

setupnetwork() {
  NETWORK=${2:-main}
  if [[ "$NETWORK" == "main" || "$NETWORK" == "test" || "$NETWORK" == "local" ]]; then

    if [ "$NETWORK" == "main" ]
    then
      NAME=mainnet
      DB=lisk_main
      IMAGE=lisk/mainnet:latest
      PORT=8000
      OTHER1=testnet
      OTHER2=localnet
      REDISINSTANCE=0
    elif [ "$NETWORK" == "test" ]
    then
      NAME=testnet
      DB=lisk_test
      IMAGE=lisk/testnet:latest
      PORT=7000
      OTHER1=mainnet
      OTHER2=localnet
      REDISINSTANCE=1
    else
      NAME=localnet
      DB=lisk_local
      IMAGE=lisk-docker:latest
      PORT=4000
      OTHER1=mainnet
      OTHER2=testnet
      REDISINSTANCE=2
    fi

  else 
    echo "Incorrect network, valid options are: main, test, local"
  fi
}

case "$1" in
  start)
    setupnetwork $@
    echo "starting ${NAME}..."
    start $NETWORK $3
    ;;
  stop)
    setupnetwork $@
    echo "stopping ${NAME}..."
    stop $NETWORK
    ;;
  uninstall)
    setupnetwork $@
    echo "uninstalling ${NAME}..."
    uninstall $NETWORK
    ;;
  upgrade)
    setupnetwork $@
    echo "upgrading ${NAME}..."
    upgrade $NETWORK $3
    ;;
  logs)
    setupnetwork $@
    shift
    shift
    logs $NETWORK $@
    ;;
  reset)
    setupnetwork $@
    echo "resetting ${NAME}..."
    reset $NETWORK $3
    ;;
  ssh)
    setupnetwork $@
    echo "logging into ${NAME}..."
    ssh $NETWORK
    ;;
  status)
    echo "status of lisk-docker..."
    setupnetwork $@
    status
    ;;
  version)
    scriptinfo
    ;;
  *)
    usagefull
    ;;
esac