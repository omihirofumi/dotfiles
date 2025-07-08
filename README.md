# dotfiles

[chezmoi](https://github.com/twpayne/chezmoi)を使用したdotfilesの管理

## 新しい端末での初期設定

```bash
curl -fsSL https://raw.githubusercontent.com/omihirofumi/dotfiles/main/install.sh | sh
```

## 使い方

### 新しいファイルを管理に追加
```bash
chezmoi add <file>
```

### 管理しているファイルを編集
```bash
chezmoi edit <file>
```

### 編集したファイルを適用
```bash
chezmoi apply
```

### 管理しているファイルを修正した場合
```bash
chezmoi re-add <file>
```

### GitHubから更新を取得・適用
```bash
chezmoi update
```

### 現在の状態を確認
```bash
chezmoi status
chezmoi diff
```

## Tips
#### .Brewfileの管理
```bash
brew bundle dump --global --force
