#!/usr/bin/env bash


# Dotfiles
cd ~/.dotfiles
git add .
git commit -a -m 'sync script'
gitpp

# Private
cd ~/.dotfiles/private
git add .
git commit -a -m 'sync script'
gitpp
