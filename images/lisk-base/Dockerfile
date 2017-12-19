FROM node:6

COPY files/ /
RUN apt-key add /tmp/pgdg.asc && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install --no-install-recommends \
        postgresql-client-9.6 \
        jq \
        moreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --gid 1100 lisk && \
    useradd lisk --shell /bin/bash --uid 1100 --gid 1100 && \
    chown lisk:lisk -R /home/lisk && \
    chmod 1777 /tmp
