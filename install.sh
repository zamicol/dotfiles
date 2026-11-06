#!/bin/sh



####################
# ssh
####################
# Zamicol's ssh keys can be found at
# https://github.com/zamicol.keys
# And probably more out of date here https://github.com/zamicol.keys
echo "Setting up ssh"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
# ed
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
	# ssh-keygen -t ed25519
  ssh-keygen -t ed25519 -N "" -f $HOME/.ssh/id_ed25519
echo "Created new key.  Add key to git repo and rerun script"
cat ~/.ssh/id_ed25519.pub
return
fi

if [ ! -d "$HOME/.dotfiles/private/.git" ]; then
	git clone git@github.com:zamicol/private.git "$HOME/.dotfiles/private"
fi
cd "$HOME/.dotfiles/private"
/bin/sh ~/.dotfiles/private/install.sh

# Latest Go, into ~/.local/go (no sudo). /usr/local/go stays the old install.
version=$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1)
if ! "$HOME/.local/go/bin/go" version 2>/dev/null | grep -q "$version "; then
	curl -fL -o "/tmp/${version}.linux-amd64.tar.gz" "https://dl.google.com/go/${version}.linux-amd64.tar.gz"
	mkdir -p "$HOME/.local"
	rm -rf "$HOME/.local/go"
	tar -C "$HOME/.local" -xzf "/tmp/${version}.linux-amd64.tar.gz"
	rm -f "/tmp/${version}.linux-amd64.tar.gz"
fi
