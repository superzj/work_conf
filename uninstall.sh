#/usr/bin/env sh

pwd=$PWD

home=$HOME

zsh ./stand_uni.zsh

unlink ${home}/.bash_profile
unlink ${home}/.vim
unlink ${home}/.vimrc
unlink ${home}/.zprezto
unlink ${home}/.autojump
unlink ${home}/.tmux.conf

