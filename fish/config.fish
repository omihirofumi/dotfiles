if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_right_prompt
    # Intentionally left blank
end

# PATH
set -x PATH /opt/homebrew/bin $PATH
set PATH ~/.cargo/bin $PATH
set PATH ~/.local/bin $PATH

# VIEW
set -g theme_display_git_default_branch yes

# MISE
mise activate fish | source

# ALIAS
alias cp='cp -r'
alias rm='rm -r'
alias ll='ls -l'
alias la='ls -la'
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

# command
alias myip='curl http://checkip.amazonaws.com'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hirofumiomi/google-cloud-sdk/path.fish.inc' ]; . '/Users/hirofumiomi/google-cloud-sdk/path.fish.inc'; end
