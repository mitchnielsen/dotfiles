#!/bin/bash
stow .
printf "\nSuccessfully stowed dotfiles.\n"

## Set up homebrew
command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Set up TMUX's TPM
[[ -d "~/.tmux/plugins/tpm" ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Setup oh-my-zsh
[[ -d "~/.oh-my-zsh" ]] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[[ -d "~/.zsh/zsh-syntax-highlighting" ]]      || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git      ~/.zsh/zsh-syntax-highlighting/
[[ -d "~/.zsh/zsh-autosuggestions" ]]          || git clone https://github.com/zsh-users/zsh-autosuggestions.git          ~/.zsh/zsh-autosuggestions/
[[ -d "~/.zsh/zsh-history-substring-search" ]] || git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search/

# Set up lazygit
mkdir -p "$HOME/Library/Application\\ Support/jesseduffield/lazygit"
rm "$HOME/Library/Application\ Support/jesseduffield/lazygit/config.yml"
ln -s "$HOME/dotfiles/.config/lazygit/default.yml" "$HOME/Library/Application\ Support/jesseduffield/lazygit/config.yml"
