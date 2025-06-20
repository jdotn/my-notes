# Created by newuser for 5.8

# python alias
alias python="python3"

# read zsh-git-prompt
source "/home/linuxbrew/.linuxbrew/opt/zsh-git-prompt/zshrc.sh"

autoload -Uz colors %% colorsj

# Don't show branches outside of the git repository
git_prompt() {
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
      PROMPT='%F{green}%n%f %F{36}($(arch))%f:%F{blue}%~%f $(git_super_status ) '$'\n''%#'
  else
    PROMPT='%F{green}%n%f %F{36}($(arch))%f:%F{blue}%~%f '$'\n''%#'
  fi
}

precmd() {
  git_prompt
}

# nvim path and alias
export PATH=$PATH:/opt/nvim-linux64/bin
alias vim='nvim'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GOPATH
export PATH=$PATH:$(go env GOPATH)/bin

#RUST PATH
export PATH=$PATH:/.cargo/bin

. "$HOME/.cargo/env"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Load Angular CLI autocompletion.
source <(ng completion script)

# omission of cd
setopt auto_cd

# auto_ls
function chpwd(){
    if [[ $(pwd) != $HOME ]]; then;
        ls
    fi
}
autoload chpwd
