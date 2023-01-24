#!/usr/bin/env bash

# TODO: add this
# git clone https://github.com/aabouzaid/kubech ~/.kubech

function symlink() {
  # zprofile
  if [ ! -f "$HOME/.zprofile" ]; then echo 'export ZDOTDIR=$HOME/.config/zsh' > "$HOME/.zprofile"; fi

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
}

function asdf-install () {
  asdf plugin add $1
  asdf install $1 $2
  asdf global $1 $2
}

function dependencies() {
  # asdf
  if [ ! -d '~/.asdf' ]; then git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0; fi
  source "$HOME/.asdf/asdf.sh"

  # asdf-managed
  asdf-install awscli latest
  asdf-install cfssl latest
  asdf-install direnv latest
  asdf-install dive latest
  asdf-install golang '1.16.14'
  asdf-install golangci-lint latest
  asdf-install helm '3.8.0'
  asdf-install jq latest
  asdf-install kind '0.11.1'
  asdf-install kubectl '1.23.3'
  asdf-install kubectx '0.9.4'
  asdf-install kustomize '4.5.2'
  asdf-install oc latest
  asdf-install ruby '2.7.5'
  asdf-install stern latest
  asdf-install yq latest
  asdf reshim

  ## TMUX's TPM
  if [ ! -d "~/.tmux/plugins/tpm" ]; then git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; fi

  # Install homebrew if needed
  command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  grep homebrew "$HOME/.zprofile" || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Install packages
  brew bundle install --file=.config/brew/Brewfile

  # FZF
  if [ ! -d '~/.fzf' ]; then (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install); fi

  # neovim
  mkdir -p "$HOME/go"
  GOPATH="$HOME/go" nvim --headless +GoInstallBinaries +qa

  # solargraph for NVIM LSP
  gem install solargraph
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
  # Save settings
  killall Dock
}

setup_git() {
  # git settings
  git config --global user.name "Mitchell Nielsen"
  git config --global user.email "mnielsen@gitlab.com"
  git config --global pull.rebase false # don't automatically rebase on `git pull`
  git config --global fetch.prune true # delete branches that no longer exist upstream (merged)
  git config --global rebase.autosquash true # automatically squash fixup/squash commits
  git config --global alias.co checkout
  git config --global alias.cm 'commit --verbose'
  git config --global alias.st status
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.db "!git remote show origin | sed -n '/HEAD branch/s/.*: //p'"
  git config --global alias.d diff
  git config --global alias.ds 'diff --staged'
  git config --global alias.dm '!git diff $(git merge-base HEAD $(git db))'
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.l 'log --all --graph --decorate --oneline --simplify-by-decoration'
  git config --global alias.pl '!git pull origin $(git branch --show-current)'
  git config --global alias.plm '!git fetch origin && git pull origin $(git db)'
  git config --global alias.ps '!git push origin $(git branch --show-current)'

  git config --global commit.template ~/.config/git/gitmessage
}

function all() {
  symlink
  dependencies
  macos_settings
  setup_git
}

TARGET=${@:-all}

for target in ${TARGET}; do
  echo "Running ${target}..."
  ${target}
  echo "${target} complete."
done

