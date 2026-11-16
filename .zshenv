# 非対話シェルでも Homebrew コマンドを使えるよう、.zprofile ではなくここで設定する
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# 非対話シェルにも届くよう .zshrc ではなくここで足す
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
export FZF_DEFAULT_OPTS='--layout=reverse'
