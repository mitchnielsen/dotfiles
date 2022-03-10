#!/usr/bin/env bash

# Packages
apt-get update
apt-get install -y \
  cmake \
  curl \
  stow \
  tree \
  tmux \
  unzip \
  xdg-utils \
  zlib1g-dev \
  zsh

# Change default shell
chsh --shell /bin/zsh vagrant
