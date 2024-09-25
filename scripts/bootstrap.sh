#!/usr/bin/env bash

# TODO: add this
# git clone https://github.com/aabouzaid/kubech ~/.kubech

function symlink() {
  # zprofile
  if [ ! -f "$HOME/.zprofile" ]; then echo 'export ZDOTDIR=$HOME/.config/zsh' > "$HOME/.zprofile"; fi

  # Tmux's config (https://github.com/tmux/tmux/issues/142)
  [ -f ~/.tmux.conf ] && rm ~/.tmux.conf
  ln -s ~/dotfiles/.config/tmux/.tmux.conf ~/.tmux.conf

  # mise config
  [ -f ~/.mise.toml ] && rm ~/.mise.toml
  ln -s ~/dotfiles/.mise.toml ~/.mise.toml

  # ssh
  [ -f ~/.ssh/config ] && mv ~/.ssh/config ~/.ssh/config.bak.$(date '+%Y-%m-%d-%H:%M:%S')
  ln -s ~/dotfiles/.ssh/config ~/.ssh/config
  chmod 644 ~/.ssh/config

  # dotfiles
  mkdir -p "$HOME/.config"
  (cd "$HOME/dotfiles" && stow -v --target="$HOME/.config" .config)
  rm "$HOME/.zshrc" || true
  ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

  # binaries
  mkdir -p "$HOME/bin"
  (cd "$HOME/dotfiles" && stow -v --target="$HOME/bin" bin)

  # VSCode (VSCodium) configs
  ln -s ~/dotfiles/.config/vscodium/settings.json ~/Library/Application\ Support/VSCodium/User/settings.json
  ln -s ~/dotfiles/.config/vscodium/keybindings.json ~/Library/Application\ Support/VSCodium/User/keybindings.json
}

function dependencies() {
  # Install homebrew if needed
  command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  grep homebrew "$HOME/.zprofile" || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Install packages
  brew bundle install --file=.config/brew/Brewfile

  ## TMUX's TPM
  if [ ! -d "~/.tmux/plugins/tpm" ]; then git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; fi

  # FZF
  if [ ! -d '~/.fzf' ]; then (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install); fi

  # neovim
  mkdir -p "$HOME/go"
  GOPATH="$HOME/go" nvim --headless +GoInstallBinaries +qa
}


function macos_settings() {
  # Change screenshot type to jpg for smaller filesize
  defaults write com.apple.screencapture type jpg
  # Show hidden app icons as transparent in the dock
  defaults write com.apple.Dock showhidden -bool TRUE
  # Faster Dock animation
  defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0
  # Use thin strokes (https://github.com/alacritty/alacritty/releases/tag/v0.11.0)
  defaults write -g AppleFontSmoothing -int 0
  # Adjust key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)
  defaults write com.apple.dock no-bouncing -bool TRUE # disable app icon bouncing
  # Show hidden files in Finder
  defaults write com.apple.Finder AppleShowAllFiles true
  # Save settings
  killall Dock
}

function all() {
  dependencies
  symlink
  macos_settings
  setup_git
}

TARGET=${@:-all}

for target in ${TARGET}; do
  echo "Running ${target}..."
  ${target}
  echo "${target} complete."
done

