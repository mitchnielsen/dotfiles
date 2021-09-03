#!/bin/bash
stow .
printf "\nSuccessfully stowed dotfiles.\n"

printf "\nTo install brew dependencies, run:\n  brew install -f ~/.config/brew/Brewfile"
printf "\nTo update the list of brew dependencies, run:\n  brew bundle dump --force -f ~/.config/brew/Brewfile"
