#!/usr/bin/env zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  unlink "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
