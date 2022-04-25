# putting everything important in .bashrc

. ~/.dotfiles/private/profile

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#  go, also in .profile
export GOPATH=$HOME/dev/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
export GOPRIVATE=$GOPATH/src/github.com/zamicol/gitversion:$GOPATH/src/github.com/cyphrme/*

