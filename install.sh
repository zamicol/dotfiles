#!/usr/bin/env bash


############
##Variables
############
#Directory in $HOME for the dotfiles project.
DOTFILES=".dotfiles"

##Repos
REPOS="ppa:ubuntu-lxc/lxd-stable ppa:webupd8team/atom"

#Packages to be installed on the system.
#Some of these are needed for this script,
PACKAGES="git vim curl openssh-server lynx htop"

##Bloat packages
PACKAGES="$PACKAGES chromium-browser gparted emacs24 xclip"

##linux mint
PACKAGES="$PACKAGES caja-share"

##Dev packages
PACKAGES="$PACKAGES golang atom"

##QuickTile packages
PACKAGES="$PACKAGES python python-gtk2 python-xlib python-dbus python-wnck"

#Files to symlink from dotfiles to home directory.
#Files with be prepended with a dot.
SYMLINKS="bashrc xsession profile xinitrc gitconfig"


############
##Dirs
############
#Make sure dev exists with go dir.
mkdir -p ~/dev/go


############
##Repos
###########
for r in $REPOS; do
  echo "Adding repo $r"
  sudo add-apt-repository $r -y
done
##Update packages that are now available
sudo apt-get update


############
##Install Packages
############
echo "Installing packages $PACKAGES"
case $(uname -s) in
    OpenBSD)
	pkg_add $PACKAGES
	;;
    Linux)
	if [ -e /etc/redhat-release ]; then
	    sudo yum install $PACKAGES
	else
	    sudo apt-get -y --ignore-missing install $PACKAGES
	fi
	;;
    *)
	echo 'system unknown.  Not installing packages'
	;;
esac


############
##symlinks
############
for link in $SYMLINKS; do
    if [ ! -f ~/.$link ]; then
	ln -s ~/$DOTFILES/$link ~/.$link
	echo "added ~/.$link."
    else
	echo ".$link exists.  Not creating symbolic link."
    fi
done


################
#Make sure .bashrc is being used by the current shell environment
################
source ~/.bashrc
source ~/.profile

###########
##ssh
###########
echo "Setting up ssh"
if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi
if [ ! -f ~/.ssh/authorized_keys ]; then
  cp ~/$DOTFILES/authorized_keys ~/.ssh/authorized_keys
fi

#############
##Quicktile
############
if [ ! -f ~/.config/quicktile.cfg ]; then
	echo "Installing Quicktile"
	git clone https://github.com/ssokolow/quicktile.git
	cd quicktile
	sudo ./setup.py install
	cd ..
else
	echo "~/.config/quicktile.cfg exists.  Not installing quicktile"
fi


############
##vim
############
#vim's settings are stored in the home directory
if [ ! -d "$HOME/.vim" ]; then
    echo 'Cloning vim'
    git clone git://github.com/Zamicol/dotvim.git ~/.vim
    if (( $? != 0 )); then
	#Port blocked?  Try https
	echo 'attempting clone via https'
	git clone https://github.com/Zamicol/dotvim.git ~/.vim
    fi

    if (( $? == 0 )); then
	echo 'cloned vim to ~/.vim'
	cd ~/.vim
	git submodule init
	git submodule update
	#create symbolic link in home so vim can see the settings
	if [ ! -f ~/.vimrc ]; then
	    ln -s ~/.vim/vimrc ~/.vimrc
	else
	    echo '.vimrc exists.  Not creating symbolic link'
	fi
    else
	echo 'unable to clone vim'
    fi
fi


############
##emacs
############
if [ ! -d "$HOME/.emacs.d" ]; then
    #prelude
    #All settings should be stored in the personal directory
    #so it is easy to merge from the main project.
    #git clone https://github.com/Zamicol/prelude.git prelude
    #ln -s  	~/$DOTFILES/prelude ~/.emacs.d
    #echo 'installed emacs prelude'i

    #zami's plain jane emacs repo.
    #emacs should initialize everything else on first run.
    git clone https://github.com/Zamicol/emacs.git ~/.emacs.d
    echo 'cloned emacs to ~/.emacs.d'
else
    echo '.emacs.d exists.  Not cloning emacs'
fi


############
##xmodmap
############
#also in xsession and xinitrc, putting it here to make sure that it runs
xmodmap ~/.dotfiles/xmodmap


################
##Google Chrome
###############
if ! dpkg -l google-chrome-stable > /dev/null; then
	echo "Installing Google Chrome"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	sudo apt-get update
	sudo apt-get install google-chrome-stable
fi


#################
##golang
################
echo "Golang"
#$GOPATH should be set in .profile
echo "gopath: $GOPATH"
echo "goroot: $GOROOT"
#Install go-plus in atom.  "apm" depends on atom.


################
##Atom
################
apm install go-plus
apm install minimap
