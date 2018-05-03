FROM ubuntu:16.04

ARG network=testnet

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install --no-install-recommends \
        jq moreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1100 lisk && \
    useradd lisk --create-home --home-dir /home/lisk --shell /bin/bash --uid 1100 --gid 1100

# the chown flag does not work with tarballs
ADD ${network}-lisk-Linux-x86_64.tar.gz /home/lisk/
RUN chown lisk:lisk --recursive /home/lisk/lisk-Linux-x86_64
COPY --chown=lisk:lisk files/ /

USER lisk
WORKDIR /home/lisk/lisk-Linux-x86_64
CMD ["/home/lisk/run.sh"]
