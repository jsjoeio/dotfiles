FROM ubuntu:20.04

# Build-time argument
# it will only happen when we build
# Prevents prompts from popping up during build (we build a Docker image, not install)
ARG DEBIAN_FRONTEND="noninteractive"

# Each blue FROM RUN, etc is a step
# and Docker will cache deps at each step

# "Why did I need that again?" The benefit of adding new steps
# along with comments

# "Do we need to add `sh` as a dep?" "No, almost all OS's come with sh which is why you see
# that used more than bash"

# apt-get makes sure it has a local list of all the packages
# gets the lastest list or registry of packages

RUN apt-get update && apt-get install -y \
  # Development utilities
  # You would think they would have these
  # but Ubuntu base image tries to stay as slim as possible
  git \
  bash \
  curl \
  # htop
  # Similar to the performance monitor in Mac
  # might be used under the hood by Coder
  htop \
  # man
  # documentation for things
  # e.g. man curl -> explains how curl works
  man \
  vim \
  ssh \
  # surprised you have to install this
  sudo \
  # operating system info
  lsb-release \
  # allows Coder to talk securely with image over TLS
  ca-certificates \
  # Language support
  locales \
  gnupg \
  jq \
  # needed for neovim plugins that use make
  build-essential \
  ctags \
  # needed for Rust/Bevy
  g++ \
  libasound2-dev \
  libudev-dev

# Install the desired Node.js version into `/usr/local/`
ENV NODE_VERSION=16.15.0
RUN curl \
https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
 | tar xzfv - \
  --exclude CHANGELOG.md \
  --exclude LICENSE \
  --exclude README.md \
  --strip-components 1 -C /usr/local/

# Install the Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN curl https://bun.sh/install | bash

# code-server dependencies
RUN apt-get install -y \
  pkg-config \
  libsecret-1-dev \
  libx11-dev \
  libxkbfile-dev \ 
  python \
  quilt \
  ripgrep

# Install Deno
RUN apt-get install -y unzip
# We have to do this in Coder because otherwise Deno will be installed in the wrong place
RUN curl -fsSL https://deno.land/x/install/install.sh | sh && mv /root/.deno/bin/deno /bin/deno

# Install Go
# copied from https://github.com/cdr/enterprise-images/blob/main/images/golang/Dockerfile.ubuntu
# Install go1.17.1
RUN curl -L "https://dl.google.com/go/go1.18.1.linux-amd64.tar.gz" | tar -C /usr/local -xzvf -

# Install nvm
# used to switch between Node.js versions
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

# Setup go env vars
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin

ENV GOPATH /home/coder/go
ENV GOBIN $GOPATH/bin
ENV PATH $PATH:$GOBIN

# Download all VS Code extensions
RUN mkdir -p /vsix \
    && cd /vsix \
    && wget -q https://open-vsx.org/api/vscodevim/vim/1.21.10/file/vscodevim.vim-1.21.10.vsix 

# GitHub CLI Installation
RUN sudo apt update \
    && sudo apt install -y software-properties-common \
    && sudo apt update
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 \
    && apt-add-repository https://cli.github.com/packages \
    && sudo apt update \
    && sudo apt install -y gh

# Need tsc available globally for Neovim
RUN npm i -g typescript typescript-language-server

# Add configure script
COPY coder/configure /coder/configure

# Add a user `coder` so that you're not developing as the `root` user
# Makes it feel like "local" laptop experience
RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER coder

# Any commands below this run as coder
# Chances are you want to install stuff as root
# so place it above this previous block.

# How to update this image
# 1. Make changes
# 2. Build with: `docker build -t jsjoeio/joe-image .`
# 3. Push to Docker reigstry: `docker push jsjoeio/joe-image`

# Automated Updates on Change
# Two ways to do this
# 1. Connect to DockerHub -> they do it automatically like Vercel
# 2. GitHub Actions (better for a custom or "production" workflow)
