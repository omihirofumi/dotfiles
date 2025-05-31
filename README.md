## Requirement
- [homebrew](https://brew.sh/)
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

## 使い方
[chezmoi](https://github.com/twpayne/chezmoi)を使用して、管理している。

### dotfiles管理

#### 管理したいdotfilesを追加
```bash
chezmoi add <config-file>
```

#### 管理しているdotfilesを修正したとき
自動でcommit & pushされる設定をしている
```bash
chezmoi re-add
```

### 新しい端末でやること

#### 0. set github username 

```bash
export $GITHUB_USERNAME=omihirofumi
```


```bash
brew install chezmoi

chezmoi init --apply $GITHUB_USERNAME
```

### github上のdotfilesと同期
```bash
chezmoi update -v
```

### Tips
#### .Brewfileの管理
```bash
brew bundle dump --global --force 
```
