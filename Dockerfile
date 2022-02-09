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
                                               openssl \
                                               ca-certificates


# login to bash
RUN bash -s /bin/bash dev

# makes user from system, sets sudo perms, copies bashrc
ENV HOME=/home/dev
RUN useradd -ms /bin/bash dev && \
    usermod -aG sudo dev
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dev
ENV TERM=xterm-256color
WORKDIR /home/dev

COPY ./ca/root-ca.crt /usr/local/share/ca-certificates
RUN sudo update-ca-certificates