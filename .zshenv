# kitty のショートカットなど非対話の zsh から呼ぶスクリプトでも Homebrew のコマンドが見えるようにする。~/.zprofile に頼ると、dotfiles の管理外なので Mac ごとに差が出る
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# スクリプトや zellij の Run など非対話の zsh にも届くよう .zshrc ではなくここで足す
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
# journal などを kitty から非対話の zsh で開いても helix がテーマや構文定義を見つけられるよう、.zshrc ではなくここで設定する
export HELIX_RUNTIME=$HOME/ghq/github.com/helix-editor/helix/runtime
