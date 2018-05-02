FROM ubuntu:16.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install --no-install-recommends \
        curl wget sudo ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64 && \
    mv confd-0.15.0-linux-amd64 /usr/bin/confd && \
    chmod +x /usr/bin/confd

RUN groupadd --gid 1100 lisk && \
    useradd lisk --create-home --home-dir /home/lisk --shell /bin/bash --uid 1100 --gid 1100

COPY --chown=lisk:lisk files/ /
RUN chmod +x /home/lisk/wait-for-it.sh && \
    chmod +x /home/lisk/run.sh

WORKDIR /home/lisk
