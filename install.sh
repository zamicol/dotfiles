#!/bin/sh



####################
# ssh
####################
# Zamicol's ssh keys can be found at
# https://github.com/zamicol.keys
# And probably more out of date here https://github.com/zamicol.keys
echo "Setting up ssh"
if [ ! -d $HOME/.ssh ]; then
  chmod 700 $HOME/.ssh
fi
# ed
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
	# ssh-keygen -t ed25519
  ssh-keygen -t ed25519 -N "" -f $HOME/.ssh/id_ed25519
echo "Created new key.  Add key to git repo and rerun script"
cat ~/.ssh/id_ed25519.pub
return
fi

git clone git@github.com:zamicol/private.git
cd ~/.dotfiles/private
/bin/sh ~/.dotfiles/private/install.sh


