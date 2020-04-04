fpath+=$HOME/.zsh/pure
# Configuration for Pure. https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
autoload -U compinit; compinit
autoload -U edit-command-line
prompt pure

zle -N edit-command-line

# Store all aliases
[ -f ~/.zsh/aliases.sh ] && source ~/.zsh/aliases.sh
# Store local secrets
[ -f ~/.zsh/secrets.sh ] && source ~/.zsh/secrets.sh
# FZF
if (( $+commands[fzf] )); then
  # Setup fzf
  # ---------
  if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

  # Key bindings
  # ------------
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi
# Sytax highlighting: git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ~/.zsh/
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Autojump: git clone git@github.com:skywind3000/z.lua ~/.zsh/
[ -f ~/.zsh/z.lua/z.lua ] && eval "$(lua ~/.zsh/z.lua/z.lua --init zsh enhanced)"
# I use rbenv, not rvm
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi


ZSH_DISABLE_COMPFIX=true
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

export TERM=xterm-256color
export EDITOR='nvim'

export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--exact"
export FZF_CTRL_R_OPTS="--exact --sort"

bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
export SHELL=/usr/bin/zsh
