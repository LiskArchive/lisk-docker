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
#%    install [network] [forging ip]  Install All docker containers for a specific network
#%                                    default network is main
#%                                    optional whitelist ip for forging
#%    start [network]                 Start the docker container for a specific network
#%                                    default network is main
#%    stop [network]                  Stop the docker container for a specific network
#%                                    default network is main
#%    forge [network] [ip]            Enable forging for a specified network
#%                                    default network is main
#%                                    ip that is allowed to enable forging
#%    uninstall [network]             uninstall all docker containers for a specific network
#%                                    default network is main
#%    upgrade [network]               upgrade all docker containers for a specific network
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
#%    pgadmin [command] [password]    Starts or stops pgadmin.
#%                                    valid options for command: start, stop, changepw, uninstall
#%                                    optional password to set for logging in
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
#-    license         GNU General Public License v3.0
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

install() {
	FORGINGWHITELISTIP=$2

	if [ ! "$(docker network ls -q -f name=lisk)" ]; then
		docker network create lisk > /dev/null
	fi

	if [ ! "$(docker ps -q -f name=postgresql)" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=postgresql)" ]; then
			docker start postgresql > /dev/null
		else
			if [ ! "$(docker volume ls -q -f name=postgresdata)" ]; then docker volume create postgresdata > /dev/null; fi
			docker run -d --restart=always \
			-e POSTGRES_USER=lisk \
			-e POSTGRES_DB=postgres \
			-e POSTGRES_PASSWORD=password \
			-v postgresdata:/var/lib/postgresql/data \
			-v /etc/localtime:/etc/localtime:ro \
			--name postgresql \
			--net lisk \
			${POSTGRESIMAGE} > /dev/null
		fi
	fi

	if [ ! "$(docker ps -q -f name=redis)" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=redis)" ]; then
			docker start redis > /dev/null
		else
			docker pull ${REDISIMAGE} > /dev/null
			docker run -d --restart=always \
			--net lisk \
			--name redis \
			-v /etc/localtime:/etc/localtime:ro \
			${REDISIMAGE} > /dev/null
		fi
	fi

	if [ ! "$(docker ps -q -f name=${NAME})" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then
			docker start ${NAME} &> /dev/null
		else
			if [ "$NETWORK" == "local" ]; then
				if [ ! "$(docker image ls -q -f reference=lisk-local)" ]; then
					echo "Building ${NAME} image, this can take a very long time..."
					docker build --no-cache -f Dockerfile -t ${IMAGE} --build-arg CONTEXT=local . &> /dev/null
					if [ $? != 0 ]; then
						echo "${red}✘${reset} Local image build failed, exiting..."
						exit 1
					fi
				fi
			fi
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
			-v /etc/localtime:/etc/localtime:ro \
			--name ${NAME} \
			--net lisk \
			${IMAGE} > /dev/null
		fi
	fi

	echo "${green}✔${reset} ${NAME} installed and started correctly"

}

pgAdmin() {
	case "$1" in
		stop)
			if [ "$(docker ps -q -f name=pgadmin)" ]; then docker stop pgadmin > /dev/null; fi
			echo "${green}✔${reset} pgadmin stopped successfully"
			;;
		changepw)
			if [ "$(docker ps -q -f name=pgadmin)" ]; then docker stop pgadmin > /dev/null ; fi
			if [ "$(docker ps -aq -f status=exited -f name=pgadmin)" ]; then docker rm pgadmin > /dev/null ; fi
			pgAdmin start $2
			;;
		uninstall) 
			if [ "$(docker ps -q -f name=pgadmin)" ]; then docker stop pgadmin > /dev/null ; fi
			if [ "$(docker ps -aq -f status=exited -f name=pgadmin)" ]; then docker rm pgadmin > /dev/null ; fi
			echo "${green}✔${reset} pgadmin uninstalled successfully"
			;;
		*)
			if [ ! "$(docker ps -q -f name=pgadmin)" ]; then
				if [ "$(docker ps -aq -f status=exited -f name=pgadmin)" ]; then
					docker start pgadmin > /dev/null
				else
					if [ ! "$(docker image ls -q -f reference=pgadmin)" ]; then
						echo "Building pgadmin image, this can take a very long time..."
						docker build --no-cache -f Dockerfile.pgadmin -t pgadmin:latest . &> /dev/null
					fi
					PASS=$2
					PGADMINPASS=$(< /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c 10; echo)
					docker run  -d --restart=always \
					-p 5050:5050 \
					-e DEFAULT_USER=admin \
					-e DEFAULT_PASSWORD=${PASS:-$PGADMINPASS} \
					-v /etc/localtime:/etc/localtime:ro \
					--name pgadmin \
					--net lisk \
					${PGADMINIMAGE} > /dev/null

					echo "${green}✔${reset} Everything set up correctly, if you would like to investigate the lisk database you can do so by browsing to:"
					echo "- http://localhost:5050"
					echo "You can log in with the default credentials:"
					echo "- user: admin"
					echo "- password: ${PASS:-$PGADMINPASS}"
					echo "You can change the password by executing lisk-docker.sh pgadmin change yourpassword"
					echo "You can add a database connection with the following settings:"
					echo "- hostname: postgresql"
					echo "- port: 5432"
					echo "- user: lisk"
					echo "- password: password"
				fi
			fi
			echo "${green}✔${reset} pgadim started successfully"
			;;
	esac
}

start() {
	if [ "$(docker ps -aq -f status=exited -f name=${1})" ]; then
		docker start ${1} > /dev/null
		echo "${green}✔${reset} ${1} started successfully"
	else
		echo "${red}✘${reset} Could not find ${1}"
	fi
}

stop() {
	if [ "$(docker ps -q -f name=${1})" ]; then docker stop ${1} > /dev/null; fi
	echo "${green}✔${reset} ${1} stopped successfully"
}

forge() {
	stop $NAME
	docker rm $NAME > /dev/null
	install $@ 
}

upgrade() {
	if [ "$(docker ps -q -f name=${NAME})" ] || [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then

		install $@ > /dev/null
		FORGINGWHITELISTIP=$(docker exec ${NAME} sh -c 'echo "$FORGING_WHITELIST_IP"')
		if [ "$(docker ps -aq -f status=exited -f name=pgadmin)" ]; then pgAdmin start; fi

		if [ "$(docker ps -q -f name=${NAME})" ]
		then
			stop ${NAME}
		fi
		if [ "$(docker ps -q -f name=${OTHERNAME1})" ]
		then
			OTHER1FOUND=true
			stop ${OTHERNAME1}
		fi
		if [ "$(docker ps -q -f name=${OTHERNAME2})" ]
		then
			OTHER2FOUND=true
			stop ${OTHERNAME2}
		fi

		if [ "$(docker ps -q -f name=pgadmin)" ]; then
			PGADMINFOUND=true
			PGADMINPASS=$(docker exec pgadmin sh -c 'echo "$PGADMIN_SETUP_PASSWORD"')
			pgAdmin uninstall
			docker rmi pgadmin > /dev/null
		fi

		if [ "$(docker ps -q -f name=redis)" ]; then docker stop redis &> /dev/null; fi
		docker rm redis &> /dev/null
		docker pull ${REDISIMAGE} > /dev/null

		if [ "$(docker ps -q -f name=postgresql)" ]; then docker stop postgresql &> /dev/null; fi
		docker rm postgresql &> /dev/null
		docker pull ${POSTGRESIMAGE} > /dev/null

		docker rm ${NAME} &> /dev/null
		if [ "$NETWORK" != "local" ]; then
			docker pull ${IMAGE} &> /dev/null
		else
			docker rmi ${IMAGE} > /dev/null
		fi

		install $NETWORK $FORGINGWHITELISTIP

		if [ ! -z "$OTHER1FOUND" ]; then start ${OTHERNAME1}; fi
		if [ ! -z "$OTHER2FOUND" ]; then start ${OTHERNAME2}; fi
		if [ ! -z "$PGADMINFOUND" ]; then pgAdmin start ${PGADMINPASS}> /dev/null; fi

		docker volume rm $(docker volume ls -f dangling=true -q) &> /dev/null
		echo "${green}✔${reset} ${NAME} upgraded successfully"
	else 
		echo "${red}✘${reset} ${NAME} not installed"
	fi
}

uninstall() {
	if [ "$(docker ps -q -f name=${NAME})" ]; then docker stop ${NAME} &> /dev/null; fi
	if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then docker rm ${NAME} &> /dev/null; fi

	if [ ! "$(docker ps -q -f name=${OTHERNAME1})" ]; then
		if [ ! "$(docker ps -aq -f status=exited -f name=${OTHERNAME1})" ]; then
			if [ ! "$(docker ps -q -f name=${OTHERNAME2})" ]; then
				if [ ! "$(docker ps -aq -f status=exited -f name=${OTHERNAME2})" ]; then
					if [ "$(docker ps -q -f name=pgadmin)" ]; then docker stop pgadmin &> /dev/null; fi
					docker rm pgadmin &> /dev/null
					if [ "$(docker ps -q -f name=postgresql)" ]; then docker stop postgresql &> /dev/null; fi
					docker rm postgresql &> /dev/null
					if [ "$(docker ps -q -f name=redis)" ]; then docker stop redis &> /dev/null; fi
					docker rm redis &> /dev/null
					if [ "$(docker volume ls -q -f name=postgresdata)" ]; then docker volume rm postgresdata &> /dev/null; fi
					if [ "$(docker network ls -q -f name=lisk)" ]; then docker network rm lisk &> /dev/null; fi
				fi
			fi
		fi
	fi
	docker volume rm $(docker volume ls -f dangling=true -q) &> /dev/null
	echo "${green}✔${reset} ${NAME} uninstalled successfully"
}

logs() {
	shift
	if [ "$(docker ps -q -f name=${NAME})" ]; then
		docker logs $@ ${NAME}
	else
		echo "${red}✘${reset} ${NAME} does not seem to be running, try lisk-docker.sh start ${NETWORK}"
	fi
}

reset() {
	stop ${NAME} &> /dev/null
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
			reset > /dev/null
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
			reset > /dev/null
	fi
	start ${NAME} &> /dev/null
	echo "${green}✔${reset} ${NAME} reset successfully"
}

ssh() {
	if [ "$(docker ps -q -f name=${NAME})" ]; then
		docker exec -it ${NAME} /bin/bash
	else
		echo "${red}✘${reset} ${NAME} does not seem to be running, try lisk-docker.sh start ${NETWORK}"
	fi
}

status() {
	docker ps
}

setupNetwork() {
	NETWORK=${2:-main}
	if [[ "$NETWORK" == "main" || "$NETWORK" == "test" || "$NETWORK" == "local" ]]; then

		REDISIMAGE=redis:4.0
		POSTGRESIMAGE=postgres:9.6.5
		PGADMINIMAGE=pgadmin:latest

		if [ "$NETWORK" == "main" ]
		then
			OTHERNETWORK1=test
			OTHERNETWORK2=local
			NAME=mainnet
			OTHERNAME1=testnet
			OTHERNAME2=localnet
			DB=lisk_main
			IMAGE=lisk/mainnet:latest
			PORT=8000
			REDISINSTANCE=0
		elif [ "$NETWORK" == "test" ]
		then
			OTHERNETWORK1=main
			OTHERNETWORK2=local
			NAME=testnet
			OTHERNAME1=mainnet
			OTHERNAME2=localnet
			DB=lisk_test
			IMAGE=lisk/testnet:latest
			PORT=7000
			REDISINSTANCE=1
		else
			OTHERNETWORK1=main
			OTHERNETWORK2=test
			NAME=localnet
			OTHERNAME1=mainnet
			OTHERNAME2=testnet
			DB=lisk_local
			IMAGE=lisk-docker:latest
			PORT=4000
			REDISINSTANCE=2
		fi

	else 
		echo "${red}✘${reset} Incorrect network, valid options are: main, test, local"
		exit 1
	fi
}

run() {
	red=`tput setaf 1`
	green=`tput setaf 2`
	reset=`tput sgr0`

	case "$1" in
		install)
			setupNetwork $@
			echo "installing ${NAME}..."
			install $NETWORK $3
			;;
		start)
			setupNetwork $@
			echo "starting ${NAME}..."
			start $NAME
			;;
		stop)
			setupNetwork $@
			echo "stopping ${NAME}..."
			stop $NAME
			;;
		forge)
			setupNetwork $@
			echo "enabling forging on ${NAME}..."
			forge $NETWORK $3
			;;
		uninstall)
			setupNetwork $@
			echo "uninstalling ${NAME}..."
			uninstall $NETWORK
			;;
		upgrade)
			setupNetwork $@
			echo "upgrading ${NAME}..."
			upgrade $NETWORK
			;;
		logs)
			setupNetwork $@
			shift
			shift
			logs $NETWORK $@
			;;
		reset)
			setupNetwork $@
			echo "resetting ${NAME}..."
			reset $NETWORK $3
			;;
		ssh)
			setupNetwork $@
			echo "logging into ${NAME}..."
			ssh $NETWORK
			;;
		status)
			echo -e "status of lisk-docker..."
			setupNetwork $@
			status
			;;
		pgadmin)
			echo "running pgadmin ${2}..."
			setupNetwork
			pgAdmin $2 $3
			;;
		version)
			scriptinfo
			;;
		*)
			usagefull
			;;
	esac
}

run $@