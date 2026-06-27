#!/usr/bin/env bash

set -euo pipefail

function symlink() {
  export MISE_GLOBAL_CONFIG_FILE="$HOME/dotfiles/.config/mise/config.toml"

  mise_env=()
  if [ ! -f "$HOME/.personal_device_marker" ]; then
    mise_env=(-E work)
  fi

  mise "${mise_env[@]}" dotfiles apply --yes

  chmod 700 "$HOME/.ssh"
  chmod 644 "$HOME/.ssh/config"
}

function dependencies() {
  # Install homebrew if needed
  command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  grep -q homebrew "$HOME/.zprofile" || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Install packages
  brew bundle install --file=.config/brew/Brewfile
}

function macos_settings() {
  export MISE_GLOBAL_CONFIG_FILE="$HOME/dotfiles/.config/mise/config.toml"

  mise bootstrap macos-defaults apply --yes

  # Show the ~/Library folder.
  chflags nohidden ~/Library

  # Save settings
  killall Dock
  killall Finder
  killall SystemUIServer

  echo "killall complete"
}

function all() {
  dependencies
  symlink
  macos_settings
}

TARGET=${@:-all}

for target in ${TARGET}; do
  echo "Running ${target}..."
  ${target}
  echo "${target} complete."
done
