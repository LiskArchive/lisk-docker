FROM lisk-base AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install --no-install-recommends \
        build-essential \
        jq \
        moreutils

ADD development.tar.gz /home/lisk/
RUN mv /home/lisk/lisk-development /home/lisk/lisk
RUN chown lisk:lisk -R /home/lisk
USER lisk
RUN cd /home/lisk/lisk && \
    npm --quiet install --production && \
    mkdir /home/lisk/config && \
    cp -f /home/lisk/lisk/test/data/config.json /home/lisk/config/ && \
    rm -f /home/lisk/lisk/config.json && \
    ln -s ../config/config.json /home/lisk/lisk/config.json && \
    cp -f /home/lisk/lisk/test/data/genesis_block.json \
    /home/lisk/lisk/test/data/genesis_delegates.json /home/lisk/lisk/ && \
    jq -c ".db.database = \"lisk_local\"" config.json |sponge config.json && \
    jq -c ".dapp.masterpassword = \"local\"" config.json |sponge config.json


FROM lisk-base

COPY --from=builder /home/lisk /home/lisk
RUN chown lisk:lisk -R /home/lisk

ARG network=test
ENV NETWORK=${network}

USER lisk
WORKDIR /home/lisk/lisk
CMD ["/home/lisk/entrypoint.sh"]
