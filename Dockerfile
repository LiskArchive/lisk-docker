FROM node:6
MAINTAINER support@lisk.io

ARG network=test
ARG version=1.4.2

LABEL name="Lisk ${network}net" description="Lisk Docker Image - ${network}net" version="${version}"

# Install Essentials
WORKDIR /root
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends \
	autoconf \
	automake \
	build-essential \
	curl \
	git \
	gzip \
	libtool \
	nano \
	python \
	wget \
	tar \
	jq \
	sudo \
	postgresql-client-9.6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Lisk User
RUN useradd lisk -s /bin/bash -m
RUN echo "lisk:password" | chpasswd
RUN echo "%lisk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

VOLUME ["/home/lisk/lisk"]

# Install Start Lisk
WORKDIR /home/lisk
COPY scripts/ /home/lisk/
RUN chown lisk:lisk -R /home/lisk

# Install Lisk
USER lisk
RUN echo ${network} > ./.NETWORK
RUN ./install.sh ${network}
RUN rm install.sh

USER root
RUN rm -rf /tmp/*
USER lisk

ENV TOP=true
ENV TERM=xterm

CMD ["./setup.sh"]
