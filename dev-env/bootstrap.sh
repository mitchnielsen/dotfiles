#!/usr/bin/env bash
user_home=/home/vagrant

# Packages
sudo add-apt-repository ppa:neovim-ppa/stable
sudo add-apt-repository ppa:lazygit-team/release
apt-get update
apt-get install -y \
  curl \
  git \
  xdg-utils \
  cmake \
  tmux \
  neovim \
  zsh \
  nodejs \
  npm \
  stow \
  direnv \
  neovim \
  lazygit

# FZF
[ -d "${user_home}/.fzf" ] || (git clone --depth 1 https://github.com/junegunn/fzf.git "${user_home}/.fzf" && "${user_home}/.fzf/install")

# Golang
if ! command -v /usr/local/go/bin/go version &> /dev/null
then
  pushd /tmp
  go_version=1.17.7
  filename="go${go_version}.linux-amd64.tar.gz"
  wget "https://go.dev/dl/${filename}"
  rm -rf /usr/local/go && tar -C /usr/local -xzf "${filename}"
  /usr/local/go/bin/go version
  popd
fi

# asdf
[[ -d "${user_home}/.asdf" ]] || git clone https://github.com/asdf-vm/asdf.git "${user_home}/.asdf" --branch v0.9.0

# oh-my-zsh
[ -d "${user_home}/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[ -d "${user_home}/.zsh/zsh-syntax-highlighting" ]      || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git      "${user_home}/.zsh/zsh-syntax-highlighting/"
[ -d "${user_home}/.zsh/zsh-autosuggestions" ]          || git clone https://github.com/zsh-users/zsh-autosuggestions.git          "${user_home}/.zsh/zsh-autosuggestions/"
[ -d "${user_home}/.zsh/zsh-history-substring-search" ] || git clone https://github.com/zsh-users/zsh-history-substring-search.git "${user_home}/.zsh/zsh-history-substring-search/"

## TMUX's TPM
[ -d "${user_home}/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm "${user_home}/.tmux/plugins/tpm"

# # Gcloud
# if ! command -v "${user_home}/google-cloud-sdk" &> /dev/null
# then
#   pushd /tmp
#   curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-373.0.0-linux-x86_64.tar.gz
#   tar -xf google-cloud-sdk-373.0.0-linux-x86.tar.gz
#   ./google-cloud-sdk/install.sh --quiet --command-completion=true --usage-reporting=false
#   ./google-cloud-sdk/bin/gcloud init --no-browser
#   popd
# fi
