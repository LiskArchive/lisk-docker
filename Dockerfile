FROM node:6.11.3
ARG CONTEXT
MAINTAINER LiskHQ
LABEL description="Lisk Docker Image - ${CONTEXT}net" version="1.4.2"

# Install Essentials
WORKDIR /root
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
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
	postgresql-client-9.6

# Add Lisk User
RUN useradd lisk -s /bin/bash -m
RUN echo "lisk:password" | chpasswd
RUN echo "%lisk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

VOLUME ["/home/lisk/lisk"]

# Install Start Lisk
WORKDIR /home/lisk
ADD scripts/setup.sh /home/lisk
RUN chown lisk:lisk setup.sh
RUN chmod ug+x setup.sh
ADD scripts/entrypoint.sh /home/lisk
RUN chown lisk:lisk entrypoint.sh
RUN chmod ug+x entrypoint.sh
ADD scripts/restore.sh /home/lisk
RUN chown lisk:lisk restore.sh
RUN chmod ug+x restore.sh
ADD scripts/install.sh /home/lisk
RUN chmod +x install.sh

# Install Lisk
USER lisk
RUN echo $CONTEXT > ./.NETWORK
RUN ./install.sh $CONTEXT
RUN rm install.sh

ENV TOP=true
ENV TERM=xterm

ENTRYPOINT "./setup.sh"
