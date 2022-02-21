#!/usr/bin/env bash

# Packages
sudo add-apt-repository ppa:neovim-ppa/stable
sudo add-apt-repository ppa:lazygit-team/release
apt-get update
apt-get install -y \
  cmake \
  curl \
  direnv \
  git \
  lazygit \
  neovim \
  nodejs \
  npm \
  ripgrep \
  stow \
  tmux \
  xdg-utils \
  zlib1g-dev \
  zsh

# Change default shell
chsh --shell /bin/zsh vagrant
