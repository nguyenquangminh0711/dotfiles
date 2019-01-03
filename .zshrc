# Configuration for Pure. https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure
# Store all aliases
[ -f ~/.zsh/aliases.sh ] && source ~/.zsh/aliases.sh
# Store local secrets
[ -f ~/.zsh/secrets.sh ] && source ~/.zsh/secrets.sh
# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Sytax highlighting: git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ~/.zsh/
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# I use rbenv, not rvm
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi

export TERM=xterm-256color

export EDITOR='nvim'

export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=${PATH}:/usr/local/mysql/bin/
export PATH=$PATH:/usr/local/sbin
export PATH="$HOME/.cargo/bin:$PATH"
