{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
    };

    shellAliases = {
      g = "git";
      lgit = "lazygit";
      lg = "lazygit";
      cat = "bat";
      ls = "eza -l";
      ll = "eza -la";
    };

    initExtra = ''
      ######### env / eval #########
      # (移行段階)brew は完全排除
      # eval "$(/opt/homebrew/bin/brew shellenv)"

      # mise
      eval "$(${pkgs.mise}/bin/mise activate zsh)"

      # oh-my-posh（設定は Nix で ~/.config/negligible.omp.json を配る）
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config "$HOME/.config/negligible.omp.json")"
      # starship は使わないなら home/starship.nix を消す（もしくは下を無効化）

      # thefuck
      eval "$(${pkgs.thefuck}/bin/thefuck --alias)"

      # ww（正体不明なので存在時だけ）
      if command -v ww >/dev/null 2>&1; then
        eval "$(ww init zsh)"
      fi

      # fzf (keybindings/completion)
      source <(${pkgs.fzf}/bin/fzf --zsh)

      ######### exports #########
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
      export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
      export EDITOR=hx

      ######### bindkey #########
      # ctrl + M for ghostty
      bindkey '\e[109;5u' accept-line

      ######### zinit #########
      # Nix で配布される zinit を利用（自動インストールはしない）
      source "${pkgs.zinit}/share/zinit/zinit.zsh"
      autoload -Uz _zinit
      (( ''${+_comps} )) && _comps[zinit]=_zinit

      # annex
      zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust

      ################ plugins ################
      zinit light mafredri/zsh-async
      zinit light chrissicool/zsh-256color

      # completions（compinit 前）
      zinit ice blockf
      zinit light zsh-users/zsh-completions

      # compinit（ここで一度だけ）
      autoload -Uz compinit
      compinit

      # fzf-tab（compinit 後）
      zinit light Aloxaf/fzf-tab

      # syntax highlight / history substring / autosuggest
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-history-substring-search
      zinit light zsh-users/zsh-autosuggestions

      # emojify
      zinit ice as"command"
      zinit light mrowa44/emojify

      # z
      zinit light agkozak/zsh-z

      # git-fuzzy
      zinit ice as"command" pick"bin/git-fuzzy"
      zinit light bigH/git-fuzzy

      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      ######### jj completion #########
      if command -v jj >/dev/null 2>&1; then
        source <(COMPLETE=zsh jj)
      fi

      ################ functions ################
      function fzf-src () {
        local selected_dir
        selected_dir=$(${pkgs.ghq}/bin/ghq list -p | ${pkgs.fzf}/bin/fzf --reverse)
        if [ -n "$selected_dir" ]; then
          BUFFER="cd ''${selected_dir}"
          zle accept-line
        fi
        zle clear-screen
      }
      zle -N fzf-src
      bindkey '^g' fzf-src

      function fzf-dev () {
        local selected_dir
        selected_dir=$(find "$HOME/Development" -type d -mindepth 1 -maxdepth 3 \
          -not -path "*/.*" \
          -not -path "*/node_modules*" \
          -not -path "*/target*" \
          -not -path "*/build*" | \
          sed "s|$HOME/||" | \
          ${pkgs.fzf}/bin/fzf --reverse --preview "ls -la ~/"'{}'
        )
        if [ -n "$selected_dir" ]; then
          BUFFER="cd ~/${selected_dir}"
          zle accept-line
        fi
        zle clear-screen
      }
      zle -N fzf-dev
      bindkey '^j' fzf-dev

      function pr() {
        if [[ "$1" == "-a" ]]; then
          (cd ~ && gh dash)
        else
          gh dash "$@"
        fi
      }

      function fzf-favdir () {
        local config_file="$HOME/.config/favdirs"
        if [[ ! -f "$config_file" ]]; then
          echo "~/.config/favdirs が見つかりません" >&2
          return 1
        fi
        local selected_dir
        selected_dir=$(cat "$config_file" | ${pkgs.fzf}/bin/fzf --reverse --prompt="Favorite dirs > ")
        if [ -n "$selected_dir" ]; then
          BUFFER="cd ''${selected_dir}"
          zle accept-line
        fi
        zle clear-screen
      }
      zle -N fzf-favdir
      bindkey '^]' fzf-favdir

      ######### local bins #########
      alias claude="$HOME/.local/bin/claude"

      # Rancher Desktop（外部管理なので存在時のみ）
      if [ -d "$HOME/.rd/bin" ]; then
        export PATH="$HOME/.rd/bin:$PATH"
      fi

      # vi mode でなく emacs キーバインド
      bindkey -e

      # # ww completion
      # if command -v ww >/dev/null 2>&1; then
      #   eval "$(ww completion zsh)"
      # fi
    '';
  };
}
