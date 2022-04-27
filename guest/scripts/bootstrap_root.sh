#!/usr/bin/env bash

# Packages
apt-get update
apt-get install -y \
  autoconf \
  bison \
  build-essential \
  cmake \
  curl \
  git \
  libdb-dev \
  libffi-dev \
  libgdbm6 \
  libncurses5-dev \
  libreadline6-dev \
  libssl-dev \
  libyaml-dev \
  skopeo \
  stow \
  tmux \
  tree \
  unzip \
  xdg-utils \
  zlib1g-dev \
  zsh

# Change default shell
chsh --shell /bin/zsh vagrant

# Set locale
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
