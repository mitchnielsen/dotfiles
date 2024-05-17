#!/usr/bin/env bash

# TODO: add this
# git clone https://github.com/aabouzaid/kubech ~/.kubech

function symlink() {
  # zprofile
  if [ ! -f "$HOME/.zprofile" ]; then echo 'export ZDOTDIR=$HOME/.config/zsh' > "$HOME/.zprofile"; fi

  # Tmux's config (https://github.com/tmux/tmux/issues/142)
  [ -f ~/.tmux.conf ] && rm ~/.tmux.conf
  ln -s ~/dotfiles/.config/tmux/.tmux.conf ~/.tmux.conf

  # asdf's config
  [ -f ~/.tool-versions ] && rm ~/.tool-versions
  ln -s ~/dotfiles/.tool-versions ~/.tool-versions

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

setup_git() {
  # git settings
  # https://jvns.ca/blog/2024/02/16/popular-git-config-options/
  git config --global user.name "Mitchell Nielsen"
  git config --global user.email "mnielsen@gitlab.com"
  git config --global pull.rebase false # don't automatically rebase on `git pull`
  git config --global fetch.prune true # delete branches that no longer exist upstream (merged)
  git config --global rebase.autosquash true # automatically squash fixup/squash commits
  git config --global push.autosetupremote true # automatically set up the remote origin when pushing
  git config --global init.defaultBranch main # set the default project branch to 'main' instead of 'master'
  git config --global commit.verbose true # show the entire diff in the commit window for context
  git config --global interactive.diffFilter 'delta --color-only' # highlight syntax when running 'git add -p'
  git config --global diff.colorMoved default # uses different colours to highlight lines in diffs that have been “moved”
  git config --global diff.algorithm histogram # makes diffs easier to parse visually
  git config --global merge.conflictStyle zdiff3 # more context in diffs
  git config --global alias.co checkout
  git config --global alias.cm 'commit --verbose'
  git config --global alias.st status
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.default-branch "!git rev-parse --abbrev-ref origin/HEAD | cut -d '/' -f2"
  git config --global alias.db default-branch
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

