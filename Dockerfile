FROM ubuntu
MAINTAINER LiskHQ
LABEL description="Lisk Docker Image" version="1.0.0"

# Install Essentials
WORKDIR /~
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential curl git nano python wget unzip

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Install SQLite3
RUN curl -sL http://downloads.lisk.io/scripts/setup_sqlite3 | sudo -E bash -
RUN sudo apt-get install -y sqlite3

# Install Lisk
RUN wget http://downloads.lisk.io/lisk-source.zip -O lisk-source.zip
RUN unzip lisk-source.zip -d lisk
RUN rm lisk-source.zip
WORKDIR lisk
RUN npm install --production

# Install Lisk Node
RUN wget http://downloads.lisk.io/lisk-node.zip -O lisk-node.zip
RUN unzip lisk-node.zip
RUN rm lisk-node.zip

# Install Start Lisk
RUN wget http://downloads.lisk.io/scripts/start_lisk -O start_lisk
RUN chmod ugo+x start_lisk

ENV TOP=true
ENV TERM=xterm

EXPOSE 8040
ENTRYPOINT ./start_lisk
