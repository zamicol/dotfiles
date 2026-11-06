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
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
	ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/id_ed25519"
	echo "Created new key.  Add key to git repo and rerun script"
	cat "$HOME/.ssh/id_ed25519.pub"
	# `return` when sourced, `exit` when this file is executed.
	if [ "${0##*/}" = "install.sh" ]; then
		exit 0
	fi
	return 0
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

# Grok. https://x.ai/cli/install.sh
if [ ! -x "$HOME/.grok/bin/grok" ]; then
	echo "Installing Grok"
	curl -fsSL https://x.ai/cli/install.sh | bash
else
	echo "Grok already installed"
fi
