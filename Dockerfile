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

# PHP
# ---------------------------------------------------------------
RUN wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
RUN apt-get install -y apache2
RUN apt-get install -y php7.0
RUN apt-get install -y libapache2-mod-php7.0

# RUN echo 'set nocompatible' >> '/root/.vimrc'
# RUN echo 'set backspace=indent,eol,start' >> '/root/.vimrc'
