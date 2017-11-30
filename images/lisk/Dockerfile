FROM lisk-base AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install --no-install-recommends \
        build-essential \
        jq \
        moreutils

ADD lisk-source.tar.gz /home/lisk/
RUN mv /home/lisk/lisk-source /home/lisk/lisk
ADD lisk-node-Linux-x86_64.tar.gz /home/lisk/lisk/
RUN chown lisk:lisk -R /home/lisk
USER lisk
RUN cd /home/lisk/lisk && \
    npm --quiet install --production && \
    jq -c ".api.access.public = true" config.json |sponge config.json


FROM lisk-base

RUN npm --quiet install --global --production lisky
COPY --from=builder /home/lisk /home/lisk
RUN mkdir /home/lisk/config && \
    mv /home/lisk/lisk/config.json /home/lisk/config/ && \
    ln -s ../config/config.json /home/lisk/lisk/config.json && \
    chown lisk:lisk -R /home/lisk

ARG network=test
ENV NETWORK=${network}

USER lisk
WORKDIR /home/lisk/lisk
CMD ["/home/lisk/entrypoint.sh"]
