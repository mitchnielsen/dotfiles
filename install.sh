#!/bin/bash
stow .
printf "\nSuccessfully stowed dotfiles.\n"

# If on MacOS
espanso_config="$HOME/Library/Preferences/espanso"
lazygit_config="$HOME/Library/Application\\ Support/jesseduffield/lazygit"
if [ "$(uname -p)" == 'i386' ]; then
  command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  mkdir -p "${lazygit_config}" && rm "${lazygit_config}/config.yml"
  ln -s "$HOME/dotfiles/.config/lazygit/default.yml" "${lazygit_config}/config.yml"

  mkdir -p "${espanso_config}" && rm "${espanso_config}/config.yml"
  ln -s "$HOME/dotfiles/.config/espanso/default.yml" "${espanso_config}/config.yml"
fi
