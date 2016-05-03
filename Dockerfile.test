FROM ubuntu:trusty
MAINTAINER LiskHQ
LABEL description="Lisk Docker Image" version="1.2.0"

# Install Essentials
WORKDIR /~
RUN apt-get update
RUN apt-get install -y build-essential curl git gzip nano python wget tar

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs

# Install PostgreSQL
ADD scripts/setup_postgresql.Linux /~
RUN bash setup_postgresql.Linux

# Add Lisk User
RUN useradd lisk -s /bin/bash -m
RUN echo "lisk:password" | chpasswd
RUN echo "%lisk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure PostgreSQL
RUN /etc/init.d/postgresql start && \
    sudo -u postgres createuser --createdb lisk && \
    sudo -u postgres psql -c "ALTER USER \"lisk\" WITH PASSWORD 'password';" && \
    sudo -u postgres createdb -O lisk lisk_test

# Install Lisk
USER lisk
WORKDIR /home/lisk
RUN wget https://downloads.lisk.io/lisk/test/lisk-source.tar.gz -O lisk-source.tar.gz
RUN tar -zxvf lisk-source.tar.gz
RUN mv -f lisk-source lisk
RUN rm lisk-source.tar.gz
WORKDIR lisk
RUN npm install --production

# Install Lisk Node
RUN wget https://downloads.lisk.io/lisk-node/lisk-node-Linux-x86_64.tar.gz -O lisk-node-Linux-x86_64.tar.gz
RUN tar -zxvf lisk-node-Linux-x86_64.tar.gz
RUN rm lisk-node-Linux-x86_64.tar.gz

# Install Start Lisk
USER root
ADD scripts/start_lisk /home/lisk/lisk
RUN chown lisk:lisk start_lisk
RUN chmod ug+x start_lisk
USER lisk

ENV TOP=true
ENV TERM=xterm

EXPOSE 7000
ENTRYPOINT ./start_lisk test
