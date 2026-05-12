# Heavy / lazy-loaded shell init.
#
# Caches subprocess shell-init output (fzf --zsh, direnv hook, etc.) to disk,
# and defers Python-backed or rarely-used integrations (thefuck, gcloud
# completion) until first invocation. Cache lives under
# $XDG_CACHE_HOME/zsh/init and regenerates when the source binary is newer
# or the cached file is older than ZSH_INIT_CACHE_MAX_AGE_SECONDS.
#
# Run `zsh-init-cache-clear` to force regeneration of every cached file.
# `_cached_eval` is re-exported so .zshrc can use it for the prompt init,
# which must run after the syntax-highlighting plugins.

ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
ZSH_INIT_CACHE_MAX_AGE_SECONDS=86400
[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"
zmodload zsh/stat zsh/datetime

# _cached_eval <name> <binary-to-stat> <command...>
# Regenerates when: cache missing/empty, source binary newer, or cache >24h old.
_cached_eval() {
  local name=$1 bin=$2; shift 2
  local cache="$ZSH_INIT_CACHE_DIR/$name.zsh"
  local stale=0
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    stale=1
  else
    local mtime=$(zstat -L +mtime -- "$cache" 2>/dev/null)
    (( EPOCHSECONDS - mtime > ZSH_INIT_CACHE_MAX_AGE_SECONDS )) && stale=1
  fi
  (( stale )) && "$@" > "$cache"
  source "$cache"
}

zsh-init-cache-clear() { rm -f "$ZSH_INIT_CACHE_DIR"/*.zsh; print "cleared $ZSH_INIT_CACHE_DIR"; }

_cached_eval fzf     /opt/homebrew/bin/fzf      fzf --zsh
_cached_eval direnv  /opt/homebrew/bin/direnv   direnv hook zsh
_cached_eval mise    /opt/homebrew/bin/mise     mise activate zsh
_cached_eval wt      /opt/homebrew/bin/wt       wt config shell init zsh

# Lazy thefuck: alias requires running a Python interpreter. Defer to first use.
fuck() {
  unfunction fuck
  eval "$(thefuck --alias)"
  fuck "$@"
}

# Lazy gcloud completion: heavy source file, only needed on first `gcloud <tab>`.
# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke:
#   gcloud components install gke-gcloud-auth-plugin
_load_gcloud_completion() {
  unfunction _load_gcloud_completion gcloud 2>/dev/null
  source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
}
gcloud() { _load_gcloud_completion; gcloud "$@"; }
# Note: `compdef _load_gcloud_completion gcloud` is registered from .zshrc
# after compinit runs, where the other compdefs live.
