# My personal dotfiles

This repo contains my personal dotfiles. I use Ubuntu (with i3). I love (Neo)vim. I work on Ruby, Golang, and C.

![Dotfiles](./Review.png)

## Setup guide

- Install dependencies:

```bash
sudo apt-get install git xclip curl tmux ripgrep zsh lua5.3 python-pip python3-pip clang
```

- Clone this repository and `cd` into cloned folder

- Setup zsh

```bash
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting.git
git clone git@github.com:skywind3000/z.lua $HOME/.zsh/z.lua
```

- Make `zsh` default terminal with `chsh`

- Setup tmux

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
```

- Download and install nvim

```bash
sudo curl https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage -L --output /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim
mkdir -p $HOME/.config/nvim/
sudo ln -s $(pwd)/.vimrc $HOME/.vimrc
sudo ln -s $(pwd)/.vimrc $HOME/.config/nvim/init.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

- Symlink vim to nvim

```bash
sudo ln -s $(which nvim) /usr/local/bin/vim
```

- Plug Install

- Install Node and NPM: https://linuxize.com/post/how-to-install-node-js-on-ubuntu-18.04/

- Install python neovim:

```bash
pip2 install pynvim
pip3 install pynvim
```

- Install desired languages:
  - https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04
  - https://golang.org/dl/

- Install Coc lang servers: https://github.com/neoclide/coc.nvim/wiki/Language-servers
- Install lazygit
