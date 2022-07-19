#!/usr/bin/env bash

# Symlink dotfiles
if [ ! -f "$HOME/.zprofile" ]; then echo 'export ZDOTDIR=$HOME/.config/zsh' > "$HOME/.zprofile"; fi

# Install homebrew if needed
command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew bundle install --file=.config/brew/Brewfile

# Set up vagrant
vagrant plugin install vagrant-vbguest

# FZF
if [ ! -d '~/.fzf' ]; then (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install); fi

# asdf
if [ ! -d '~/.asdf' ]; then git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0; fi
source "$HOME/.asdf/asdf.sh"

function asdf-install () {
  asdf plugin add $1
  asdf install $1 $2
  asdf global $1 $2
}

asdf-install awscli latest
asdf-install bat latest
asdf-install cfssl latest
asdf-install direnv latest
asdf-install dive latest
asdf-install dyff '1.4.5'
asdf-install golang '1.16.14'
asdf-install golangci-lint latest
asdf-install helm '3.8.0'
asdf-install jq latest
asdf-install k9s '0.25.18'
asdf-install kind '0.11.1'
asdf-install kubectl '1.23.3'
asdf-install kubectx '0.9.4'
asdf-install kustomize '4.5.2'
asdf-install lazygit latest
asdf-install neovim nightly
asdf-install oc latest
asdf-install ripgrep latest
asdf-install ruby '2.7.5'
asdf-install starship latest
asdf-install stern latest
asdf-install task latest
asdf-install yq latest

asdf reshim

## TMUX's TPM
if [ ! -d "~/.tmux/plugins/tpm" ]; then git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; fi

# Tmux's config (https://github.com/tmux/tmux/issues/142)
[ -f ~/.tmux.conf ] && rm ~/.tmux.conf
ln -s ~/dotfiles/.config/tmux/.tmux.conf ~/.tmux.conf

# dotfiles
mkdir -p "$HOME/.config"
(cd "$HOME/dotfiles" && stow -v --target="$HOME/.config" .config)
rm "$HOME/.zshrc" || true
ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

# binaries
mkdir -p "$HOME/bin"
(cd "$HOME/dotfiles" && stow -v --target="$HOME/bin" bin)

# neovim
nvim --headless +"lua require'pluginList'; require'packer'.sync()" +15sleep +qa
mkdir -p "$HOME/go"
GOPATH="$HOME/go" nvim --headless +GoInstallBinaries +qa

# solargraph for NVIM LSP
gem install solargraph

# ZSH helpers
if [ ! -d "~/.zsh/zsh-syntax-highlighting" ]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting/; fi
if [ ! -d "~/.zsh/zsh-autosuggestions" ]; then git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions/; fi
if [ ! -d "~/.zsh/zsh-history-substring-search" ]; then git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search/; fi
if [ ! -d "~/.zsh/you-should-use" ]; then git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.zsh/you-should-use; fi

# MacOS settings
# Change screenshot type to jpg for smaller filesize
defaults write com.apple.screencapture type jpg
# Show hidden app icons as transparent in the dock
defaults write com.apple.Dock showhidden -bool TRUE
# Faster Dock animation
defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0
# Save settings
killall Dock
