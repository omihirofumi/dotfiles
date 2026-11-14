# 非対話シェルでも Homebrew コマンドを使えるよう、.zprofile ではなくここで設定する
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# 非対話シェルにも届くよう .zshrc ではなくここで足す
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
# 非対話シェルで起動した Helix もテーマや構文定義を見つけられるよう、.zshrc ではなくここで設定する
export HELIX_RUNTIME=$HOME/ghq/github.com/helix-editor/helix/runtime
export FZF_DEFAULT_OPTS='--layout=reverse'
