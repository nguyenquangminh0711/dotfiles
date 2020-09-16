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
export PATH="$HOME/.rbenv/bin:$PATH"
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi


ZSH_DISABLE_COMPFIX=true
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

export TERM=xterm-256color
export EDITOR='nvim'

export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--exact"
export FZF_CTRL_R_OPTS="--exact --sort"

bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
export SHELL=/usr/bin/zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
