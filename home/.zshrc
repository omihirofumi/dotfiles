######## PATH ###########
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
######## core env ########
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export EDITOR=hx
export HELIX_RUNTIME=$HOME/ghq/github.com/helix-editor/helix/runtime
export DOCKER_HOST="unix:///${HOME}/.rd/docker.sock"
export MISE_EXPERIMENTAL=1

HISTSIZE=100000
SAVEHIST=100000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

alias g="git"
alias lgit="lazygit"
alias lg="lazygit"
alias cat="bat"
alias ls="eza -l"
alias ll="eza -la"

######## prompt / helpers ########
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# opam (OCaml)
if command -v opam >/dev/null 2>&1; then
  eval "$(opam env --shell=zsh)"
fi

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# oh-my-posh
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/negligible.omp.json")"
fi

if command -v ww >/dev/null 2>&1; then
  eval "$(ww init zsh)"
fi

######## fzf ########
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

######## key bindings ########
# ctrl + M for ghostty
bindkey '\e[109;5u' accept-line

# emacs keybinds
bindkey -e

######## zinit ########
if [ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zinit/zinit.zsh" ]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zinit/zinit.zsh"
  autoload -Uz _zinit
  (( $+_comps )) && _comps[zinit]=_zinit

  # annex（light-mode / turbo なし）
  zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

  # async / colors
  zinit light mafredri/zsh-async
  # Defer 256color setup to reduce startup cost.
  zinit ice wait'1' silent
  zinit light chrissicool/zsh-256color

  # completions（compinit 前）
  zinit ice blockf
  zinit light zsh-users/zsh-completions

  # compinit（ここで一度だけ）
  autoload -Uz compinit
  compinit -C

  # fzf-tab（compinit 後）
  zinit light Aloxaf/fzf-tab

  # syntax highlight / history substring / autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-history-substring-search
  zinit light zsh-users/zsh-autosuggestions

  # emojify（command）
  zinit ice as"command"
  zinit light mrowa44/emojify

  # z
  zinit light agkozak/zsh-z

  # git-fuzzy（command）
  zinit ice as"command" pick"bin/git-fuzzy"
  zinit light bigH/git-fuzzy
fi

######## jj completion ########
# jj がある時だけ
if command -v jj >/dev/null 2>&1; then
  source <(COMPLETE=zsh jj)
fi

######## functions ########

# fzf x ghq
function ghq-dup () {
  local repo src base_dir repo_name

  # 元リポジトリを選択（agentコピーは除外）
  repo=$(ghq list | grep -v -e '-agent[0-9]' | fzf --reverse --prompt="Dup repo: ")
  [ -z "$repo" ] && return

  src=$(ghq list --full-path --exact "$repo")
  base_dir=$(dirname "$src")
  repo_name=$(basename "$src")

  for suffix in agent1 agent2; do
    local dst="${base_dir}/${repo_name}-${suffix}"
    if [ -d "$dst" ]; then
      echo "already exists: $dst"
    else
      echo "cloning -> $dst"
      git clone "$src" "$dst"
    fi
  done
}

function fzf-src () {
  local repo

  repo=$(ghq list | awk '
    /-agent[0-9]+$/ { printf "\033[33m[agent] %s\033[0m\n", $0; next }
                    { print }
  ' | fzf --reverse --ansi --prompt="repo: ")

  # ラベル除去
  repo=$(echo "$repo" | sed 's/\[agent\] //')

  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact "$repo")
    BUFFER="cd $repo"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-src
bindkey '^g' fzf-src

# fzf x Development
function fzf-dev () {
  local selected_dir
  selected_dir=$(find "$HOME/Development" -type d -mindepth 1 -maxdepth 3 \
    -not -path "*/.*" \
    -not -path "*/node_modules*" \
    -not -path "*/target*" \
    -not -path "*/build*" | \
    sed "s|$HOME/||" | \
    fzf --reverse --preview "ls -la ~/{}"
  )
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ~/$selected_dir"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-dev
bindkey '^j' fzf-dev

# pr [-a] => gh dash
function pr() {
  if [ "$1" = "-a" ]; then
    (cd "$HOME" && gh dash)
  else
    gh dash "$@"
  fi
}

# fzf x favorite directories (~/.config/favdirs)
function fzf-favdir () {
  local config_file
  config_file="$HOME/.config/favdirs"

  if [ ! -f "$config_file" ]; then
    echo "~/.config/favdirs が見つかりません" >&2
    return 1
  fi

  local selected_dir
  selected_dir=$(cat "$config_file" | fzf --reverse --prompt="Favorite dirs > ")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $selected_dir"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-favdir
bindkey '^]' fzf-favdir

function fzf-tmux-session () {
  tmux has-session -t main   2>/dev/null || tmux new -s main   -d
  tmux has-session -t agent1 2>/dev/null || tmux new -s agent1 -d
  tmux has-session -t agent2 2>/dev/null || tmux new -s agent2 -d
  local session
  if [ -z "$TMUX" ]; then
    session=$(tmux ls | fzf --layout=reverse | cut -d: -f1)
    [ -n "$session" ] && BUFFER="tmux attach -t $session"
  else
    session=$(tmux ls | fzf --layout=reverse | cut -d: -f1)
    [ -n "$session" ] && BUFFER="tmux switch -t $session"
  fi
  zle accept-line
}
zle -N fzf-tmux-session
bindkey '^t' fzf-tmux-session

# Allow Ctrl-z to toggle between suspend and resume
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# Rancher Desktop（外部が管理するので存在時のみ）
if [ -d "$HOME/.rd/bin" ]; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

# ww completion（存在時のみ）
if command -v ww >/dev/null 2>&1; then
  eval "$(ww completion zsh)"
fi

# Per-machine or untracked local overrides.
if [ -f "$HOME/.zshrc_local" ]; then
  source "$HOME/.zshrc_local"
fi
