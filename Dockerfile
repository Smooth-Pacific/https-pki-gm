FROM ubuntu:20.04

# Set env to avoid user input interruption during installation
ENV TZ=America/Seattle
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install normal goodies
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ssh \
                                               sudo \
                                               git \
                                               curl \
                                               wget \
                                               vim \
                                               tree \
                                               zip \
                                               unzip \
                                               build-essential \
                                               pkg-config \
                                               clang \
                                               gdb \
                                               cscope \
                                               python3-dev \
                                               htop \
                                               iftop \
                                               iotop \
                                               openssl

# set user

# login to bash
RUN bash -s /bin/bash dev

# makes user from system
ENV HOME=/home/dev
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev
ENV TERM=xterm-256color