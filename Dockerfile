FROM phusion/baseimage:latest
MAINTAINER Takanori Matsumoto <matscube@gmail.com>

# General
# ---------------------------------------------------------------
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "alias ll='ls -la'" > /root/.bashrc
RUN apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y \
    net-tools \
    tcpdump \
    nginx \
    apache2 \
    wget

# Go
# ---------------------------------------------------------------
RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
  tar xvf go1.8.3.linux-amd64.tar.gz && \
  mv go /usr/local
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH=/root

# Ruby
# ---------------------------------------------------------------
RUN apt-get install -y ruby

# Python
# ---------------------------------------------------------------
RUN apt-get install -y \
  python \
  python-pip
RUN python -m pip install --upgrade pip

# gRPC
# ---------------------------------------------------------------
RUN gem install grpc \
  grpc-tools
RUN python -m pip install grpcio \
  grpcio-tools

# Git
# ---------------------------------------------------------------
COPY resources/.gitconfig /root/.gitconfig
RUN apt-get install -y git
# RUN apt-get install -y bash-completion
RUN wget -P /etc/bash_completion.d/ https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
RUN wget -P /etc/bash_completion.d/ https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
RUN echo 'source /etc/bash_completion.d/git-prompt.sh' >> /root/.bashrc && \
  echo 'source /etc/bash_completion.d/git-completion.bash' >> /root/.bashrc && \
  echo 'GIT_PS1_SHOWDIRTYSTATE=true' >> /root/.bashrc && \
  echo "export PS1='\u@\h:\W\[\\033[31m\]\$(__git_ps1 [%s])\[\\033[00m\]\\$ '" >> /root/.bashrc

# Network utilities
# ---------------------------------------------------------------
RUN apt-get install -y iputils-ping net-tools
RUN apt-get install -y iproute2 traceroute
RUN apt-get install -y httperf

# Webserver
# ---------------------------------------------------------------
RUN apt-get install -y apache2

# PHP
# ---------------------------------------------------------------
ENV PHP_VERSION 7.1
ENV LC_ALL C.UTF-8
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update -y
RUN apt-get install -y php${PHP_VERSION}
RUN apt-get install -y php${PHP_VERSION}-mbstring
RUN apt-get install -y php${PHP_VERSION}-xml
RUN apt-get install -y php${PHP_VERSION}-zip
RUN apt-get install -y php${PHP_VERSION}-pgsql
RUN apt-get install -y libapache2-mod-php${PHP_VERSION}


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
# RUN php composer-setup.php
# RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN echo 'PATH=$PATH:~/.composer/vendor/bin' >> /root/.bashrc

#RUN wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
#RUN apt-get install -y php7.0
# RUN echo 'set nocompatible' >> '/root/.vimrc'
# RUN echo 'set backspace=indent,eol,start' >> '/root/.vimrc'


# DB
# ---------------------------------------------------------------
RUN apt-get install -y postgresql

# Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
