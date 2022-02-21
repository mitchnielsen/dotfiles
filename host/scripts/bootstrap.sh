#!/usr/bin/env bash

# Symlink dotfiles
stow .config --target="$HOME/.config"

# Install homebrew if needed
command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew bundle install --file=.config/brew/Brewfile

# Set up vagrant
vagrant plugin install vagrant-vbguest
