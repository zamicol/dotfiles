# Mac shell file
# Put mac specific things in here.

if [ ! -d "$HOME/.ssh" ]; then
	mkdir -p "$HOME/.ssh"
	chmod 700 "$HOME/.ssh"
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
	ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
fi

ln -sfn "$HOME/.dotfiles/bashrc" "$HOME/.bashrc"
ln -sfn "$HOME/.dotfiles/profile" "$HOME/.profile"

# Atom
# apm install project-manager

# macOS bash pwd can resolve symlinks. bash_aliases sets:
# alias pwd="/bin/pwd"
