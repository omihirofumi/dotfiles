# スクリプトや zellij の Run など非対話の zsh にも届くよう .zshrc ではなくここで足す
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
# journal などを kitty から非対話の zsh で開いても helix がテーマや構文定義を見つけられるよう、.zshrc ではなくここで設定する
export HELIX_RUNTIME=$HOME/ghq/github.com/helix-editor/helix/runtime
