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
    useradd lisk --shell /bin/bash && \
    chown lisk:lisk -R /home/lisk && \
    chmod 1777 /tmp
