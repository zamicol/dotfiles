#!/usr/bin/env bash
pwd=$(pwd)

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


# Cypher Wallet
cd $CYPHERWALLET
git add .
git commit -a -m 'sync script'
gitpp

# Cypherpass
# Wiki first
cd $CYPHERPASS/wiki
git add .
git commit -a -m 'sync script'
gitpp

# Main Cypherpass repo
cd $CYPHERPASS
git add .
git commit -a -m 'sync script'
gitpp

# Change back to original directory
cd $pwd
