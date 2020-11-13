#!/bin/bash

# For most config files:
stow .

# For alacritty:
alacritty_link="$HOME/.config/alacritty/alacritty.yml"
if [ ! -L $alacritty_link ]; then
  ln -s $PWD/alacritty.yml $alacritty_link
fi
