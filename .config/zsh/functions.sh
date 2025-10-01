#!/usr/bin/env bash

# mkdir + cd
function takedir() {
  mkdir -p "${@}" && cd "${@:$#}" || exit
}

function sshf() {
  local host
  host=$(grep "^Host " ~/.ssh/config | awk '{print $2}' | grep -v "\*" | fzf --prompt="Select SSH host: ")
  [ -n "$host" ] && ssh "$host"
}

# Decode base64-encoded values
function decode() {
  echo "${1}" | base64 --decode -
}

# Check running ports
function port() {
  lsof -i :"$1" 
}

function dns-flush() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# Adds a git worktree using the project and branch name
function gwa() {
  local branch_name="${1}"
  local branch_name_escaped

  branch_name_escaped="${branch_name//\//-}"
  local location="../${branch_name_escaped}"

  local args=""
  if [ $(git branch --all | grep -c "remotes/origin/${branch_name}") -eq 0 ]; then
    echo 'Branch does not exist on remote. Checking out a new branch...'
    args="-b"
  fi

  git worktree add "${location}" ${args} "${branch_name}"
  cd "${location}" || exit
  pre-commit install --allow-missing-config || true
}

function kget() {
    if [ $# -ne 4 ]; then
        echo "Usage: get_cluster_credentials <context_name> <cluster_name> <region> <project>"
        echo "Example: get_cluster_credentials my-context my-cluster us-central1-a my-project-id"
        return 1
    fi

    local context_name="$1"
    local cluster_name="$2"
    local region="$3"
    local project="$4"

    KUBECONFIG="$HOME/.kube/contexts/$context_name" \
        gcloud container clusters get-credentials \
            "$cluster_name" \
            --region "$region" \
            --project "$project"
}

function koff() {
  unset KUBECONFIG
}

function kon() {
  context=$(find "$HOME"/.kube/contexts -type f -printf "%f\n" | fzf)
  export KUBECONFIG=$HOME/.kube/contexts/$context
}

function kdelete() {
  contexts=$(find ~/.kube/contexts -type f -printf "%f\n" | sort)
  context=$(printf "${contexts}\nquit" \
    | fzf --header='Select context to delete')

  if [ "${context}" = "quit" ]; then
    echo 'No context selected, exiting...'
    return
  fi

  echo "deleting $context"
  rm ~/.kube/contexts/"$context"
}

function krename() {
  context=$(kubectl config current-context)
  read -r new_name\?"New name for ${context}: "

  echo "renaming $context"
  kubectl config rename-context "${context}" "${new_name}"
  mv ~/.kube/contexts/"${context}" ~/.kube/contexts/"${new_name}"
}

function digg() {
  dig "$1" +nocmd +multiline +noall +answer
}

function image-size() {
  compressed=$(skopeo inspect \
    --override-arch=amd64 \
    --override-os=linux \
    docker://"$1" \
    | jq '[.LayersData[].Size] | add' \
    | numfmt --to=iec-i --suffix=B --format="%9.2f")

  docker pull "$1"
  uncompressed=$(docker inspect \
    "$1" \
    | jq '.[].Size' \
    | numfmt --to=iec-i --suffix=B --format="%9.2f")

  printf "uncompressed: %s\ncompressed: %s\n" "${uncompressed}" "${compressed}"
}

# MacOS QuickLook
function ql() {
  qlmanage -p "$@"
}

# Node/NVM
function nvm-source {
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
