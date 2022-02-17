#!/usr/bin/env bash

# FZF
if [ ! -d '~/.fzf' ]; then (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install); fi

# asdf
if [ ! -d '~/.asdf' ]; then git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0; fi
(cd ~/dotfiles && cut -d' ' -f1 .tool-versions | grep -v '^#' | xargs -i ~/.asdf/bin/asdf plugin add {} || true && ~/.asdf/bin/asdf install && ~/.asdf/bin/asdf reshim)

# oh-my-zsh
if [ ! -d "~/.oh-my-zsh" ]; then sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; fi
if [ ! -d "~/.zsh/zsh-syntax-highlighting" ]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting/; fi
if [ ! -d "~/.zsh/zsh-autosuggestions" ]; then git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions/; fi
if [ ! -d "~/.zsh/zsh-history-substring-search" ]; then git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search/; fi

# pure prompt
if [ ! -d "~/.zsh/pure" ]; then git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"; fi

## TMUX's TPM
if [ ! -d "~/.tmux/plugins/tpm" ]; then git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; fi

# Tmux's config (https://github.com/tmux/tmux/issues/142)
rm ~/.tmux.conf
ln -s ~/dotfiles/.config/tmux/.tmux.conf ~/.tmux.conf

# dotfiles
(rm ~/.zshrc && cd ~/dotfiles && stow .)

# neovim
nvim --headless +"lua require'pluginList'; require'packer'.sync()" +15sleep +qa
PATH=$PATH:/home/vagrant/.asdf/shims nvim --headless +GoInstallBinaries +qa
