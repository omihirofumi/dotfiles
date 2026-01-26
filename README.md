# dotfiles

Git とシンボリックリンクだけで管理するシンプルな構成です。

## 初期セットアップ
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omihirofumi/dotfiles/main/install.sh)"
```
- 既存のクローンを使いたい場合: `DOTFILES_DIR=/path/to/dotfiles ./install.sh`

## 運用
- 設定ファイルは `home/` 以下に置き、`dot_` は先頭の `.` に、`private_` は除去されて `$HOME` 直下へ展開されます。
- 変更を反映するときはリポジトリで `./link-dotfiles.sh` を実行してリンクを貼り直します。
- 事前確認は `./link-dotfiles.sh --list`。
- 既存の実ファイルがある場合は `*.bak.<timestamp>` に退避してからシンボリックリンクを作成します。

## macOS セットアップスクリプト
- `./run_once_after_create-directory.sh` : `~/Development` などのディレクトリを作成。
- `./run_onchange_after_01-brew-install.sh` : `home/dot_Brewfile` を使って Homebrew パッケージをインストール（事前に `brew` を用意）。
- `./run_onchange_after_02-gh-extensions.sh` : `gh-dash` など GitHub CLI 拡張を導入（事前に `gh` を用意）。
- `./run_onchange_after_03-configure-dock.sh` : Dock から既定アプリを除去（事前に `dockutil` を `brew install dockutil` などで用意）。
- `./run_onchange_macos-defaults.sh` : キーボード/Dock/トラックパッド/Finder の設定をまとめて適用。

## Tips
#### .Brewfileの管理
```bash
brew bundle dump --global --force
```
