#!/bin/sh
# When possible, use XDG directory structure.
#
#
# Manual Items:
#
# - To change look and feel, use lxappearance
# - Install Go.  The $GOPATH is set by this script.

printf "############
# Running Zami's .dotfiles install script
############
"

###############
###############
# Setup
###############
###############

# If using bash
# -e Exit if errors
# -u Exit if variable is unset
#set -eu
# Dotfiles directory
DOTFILES="$HOME/.dotfiles"
# Set absolute path.  This is especially helpful for 'ln -s'.
DOTFILES=`cd "$DOTFILES"; pwd`


####################
# ssh
####################
# Zamicol's ssh keys can be found at https://github.com/zamicol.keys
echo "Setting up ssh"
if [ ! -d $HOME/.ssh ]; then
  chmod 700 $HOME/.ssh
fi
# ed
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -N "" -f $HOME/.ssh/id_ed25519
echo "Created new key.  Add key to github and then continue script"
cat ~/.ssh/id_ed25519.pub
exit 1
fi
# RSA
# if [ ! -f $HOME/.ssh/id_rsa ]; then
#   #ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
# fi
if [ ! -f $HOME/.ssh/authorized_keys ]; then
  cp $DOTFILES/authorized_keys $HOME/.ssh/authorized_keys
fi

####################
# private
####################
cd $DOTFILES
git clone git@github.com:zamicol/private.git
cd private
git pull
cd $DOTFILES




####################
# Repo ppa's
####################
# Example:
# REPOS="ppa:webupd8team/atom ppa:bitcoin/bitcoin"
REPOS="ppa:webupd8team/atom ppa:gezakovacs/ppa"

####################
# Package Variables
####################
# Core Packages
# Some of these are needed for this script,
PACKAGES="git vim curl openssh-server lynx htop tmux ncdu secure-delete"

# Bloat packages
# `dconf-tools` is for system config editing.  The package installs `dconf-editor`
# `numlockx` is for foolproof turning on numlock.
# `pavucontrol` is awesome for sound management.
PACKAGES="$PACKAGES chromium gparted xclip numlockx dconf-tools dconf-tools nodejs synaptic gnome-calculator pavucontrol"
#unetbootin


###################
# Debian
##################
# Packages missing in Debian that are commonly in dirivatives
# software-properties-common allows apt-add-repository
# apt-transport-https is for some repos.  
PACKAGES="$PACKAGES software-properties-common apt-transport-https"

# Desktop Applications
PACKAGES="$PACKAGES inkscape vlc gtk-recordmydesktop gimp"

# Audio
PACKAGES="$PACKAGES bluetooth blueman pulseaudio-module-bluetooth gnome-sound-recorder"

# i3wm
# and desktop environment
#
# `feh` is for x desktop background.
# `sysstat` is for i3blocks cpu stats.
# `lxappearance` is for caja's icons and theme
# `compton` is compositing manager
# `xbacklight` controls display's backlight.
# `arandr` is a gui for xrandr
PACKAGES="$PACKAGES i3 dmenu i3status i3blocks i3lock feh sysstat lxappearance xbacklight compton arandr"

# MATE
# caja-share is for smb gui sharing.
PACKAGES="$PACKAGES caja-share"

# Dev packages
PACKAGES="$PACKAGES  make"
# atom

# QuickTile packages
# PACKAGES="$PACKAGES python python-gtk2 python-xlib python-dbus python-wnck"

# Evil packages
REMOVEPACKAGES="thunderbird"

####################
# Files
####################
# Symlink from dotfiles to home.
# Will not overwrite existing
# Files with be prepended with a dot.
SYMLINKS="bashrc bash_aliases xsession profile xinitrc gitconfig fonts"
# Create these dirs if not exist.
DIRS="$HOME/dev/go $HOME/.config/i3 $HOME/.ssh $HOME/.config/i3status \
$HOME/.config/i3blocks $DOTFILES/fonts $HOME/dev/go/src/github.com/zamicol"


####################
####################
# Install
####################
####################

####################
# mkdirs
####################
for dir in $DIRS; do
  mkdir -p $dir
done


################
# Symlinks
################
rm $HOME/.bashrc
rm $HOME/.profile

for link in $SYMLINKS; do
  if [ ! -f $HOME/.$link ] && [ ! -d $HOME/.$link ]; then
    if ln -s $DOTFILES/$link $HOME/.$link ; then
      echo "Created link $HOME/.$link from $DOTFILES"
    fi
  else
      echo ".$link exists.  Not creating symbolic link."
  fi
done


####################
# Make sure .bashrc is being used by the current shell environment
####################
#use "source" in bash
. $HOME/.bashrc
. $HOME/.profile

####################
# Repos
####################
# node
# install packages with:
#
#    npm install --prefix ~/dev/node_bin <package>
#
# Add key
# cat $DOTFILES/nodesource.gpg.key | sudo apt-key add -
# # Replace with the branch of Node.js or io.js you want to install: node_0.10, node_0.12, node_4.x, node_5.x, etc...
# NODEVERSION=node_7.x
# # The below command will set this correctly, but if lsb_release isn't available, you can set it manually:
# # - For Debian distributions: wheezey, jessie, sid, etc...
# # - For Ubuntu distributions: precise, trusty, xenial, etc...
# # - For Debian or Ubuntu derived distributions your best option is to use the codename corresponding to the upstream release your distribution is based off. This is an advanced scenario and unsupported if your distribution is not listed as supported per earlier in this README.
# DISTRO="$(lsb_release -s -c)"
# echo "deb https://deb.nodesource.com/$NODEVERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://deb.nodesource.com/$NODEVERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

# Add ppa's
for r in $REPOS; do
  echo "Adding repo $r"
  sudo add-apt-repository $r -y
done


###########################
#
# Update
# Install
# Upgrade
#
##########################

# only update if update hasn't been done in the last 10 minutes.
# allows the install srcript to be run quickly frequently.
fileDate=$(date +%s -r /var/cache/apt/pkgcache.bin)
tiggerDate=$(date --date='-1 minutes' +%s)
currentDate=$(date +%s)


printf "
############
# Updating, installing, and upgrading
############
Updated at:$fileDate   Next update: $tiggerDate  Now:$currentDate
Time to update: $(($fileDate-$tiggerDate))
"

#if [  $fileDate -le $tiggerDate ];
#then
  printf "Updating\n"
  # Update
  # packages that are now available with additional repos
  # update repo info
  sudo apt-get update

  # Install
  # new packages
  echo "#### Installing packages $PACKAGES"
  case $(uname -s) in
    OpenBSD)
    pkg_add $PACKAGES
    ;;
    Linux)
    if [ -e /etc/redhat-release ]; then
      sudo yum install $PACKAGES
    else
    if sudo apt-get -y --ignore-missing install $PACKAGES ; then
    echo "Installed packages sucessfully."
else
echo "Unable to install.  Fix your packages and rerun."
    exit
fi
      
    fi
    ;;
    *)
    echo 'system unknown.  Not installing packages'
    ;;
  esac

    # Remove
    # unwanted packages
    sudo apt-get -y remove $REMOVEPACKAGES
    sudo apt autoremove -y

    # Upgrade.
    # Do this last, after updating, installing, removing.
    sudo apt-get -y upgrade

#  else
#    printf "Update occured within last 10 minutes.
#**NOT** updating, installing, or upgrading\n\n"
#fi




####################
# git
####################
git config --global core.excludesfile "$DOTFILES/gitignore_global"

####################
# i3
####################
# Remove default config and link to dotfile config
rm $HOME/.config/i3/config
ln -s $DOTFILES/i3/config $HOME/.config/i3/config

# i3status and i3block
# this config should read first before the "default" /etc/i3status.conf
# according to https://i3wm.org/i3status/manpage.html and
# https://vivien.github.io/i3blocks/
ln -s $DOTFILES/i3/i3status.conf $HOME/.config/i3status/config
ln -s $DOTFILES/i3/i3blocks.conf $HOME/.config/i3blocks/config
# i3blocks manual install
## NOTE: curently insalling using package in repo. 
# git clone git://github.com/vivien/i3blocks $HOME/dev/i3blocks
# (cd $HOME/dev/i3blocks && make clean debug && sudo make install)



###############
# Quicktile
###############
if [ ! -f $HOME/.config/quicktile.cfg ]; then
  echo "Installing Quicktile"
  git clone https://github.com/ssokolow/quicktile.git
  cd quicktile
  sudo ./setup.py install
  cd ..
else
  echo "$HOME/.config/quicktile.cfg exists.  Not installing quicktile"
fi

###############
# MATE (GUI)
###############
# caja always use location path in location bar
# open `dconf-editor`
# search for "always-use-location-entry", or just do this:
gsettings set org.mate.caja.preferences always-use-location-entry true


####################
# Fonts
####################
# -N update only on new, -P specify directory, and -q is quiet
wget -Nq -P $HOME/.fonts/ \
https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Bold.ttf  \
https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Regular.ttf \
https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Thin.ttf \
https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Ultralight.ttf \
https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf


####################
# vim
####################
# vim's settings are stored in the home directory
if [ ! -d "$HOME/.vim" ]; then
  echo 'Cloning vim'
  git clone git://github.com/Zamicol/dotvim.git $HOME/.vim
  if (( $? != 0 )); then
    # Port blocked?  Try https
    echo 'attempting clone via https'
    git clone https://github.com/Zamicol/dotvim.git $HOME/.vim
  fi

  if (( $? == 0 )); then
    echo 'cloned vim to $HOME/.vim'
    cd $HOME/.vim
    git submodule init
    git submodule update
    # create symbolic link in home so vim can see the settings
    if [ ! -f $HOME/.vimrc ]; then
      ln -s $HOME/.vim/vimrc $HOME/.vimrc
    else
      echo '.vimrc exists.  Not creating symbolic link'
    fi
  else
    echo 'unable to clone vim'
  fi
fi

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


####################
# emacs
####################
if [ ! -d "$HOME/.emacs.d" ]; then
  # prelude
  # All settings should be stored in the personal directory
  # so it is easy to merge from the main project.
  # git clone https://github.com/Zamicol/prelude.git prelude
  # ln -s  	$HOME/$DOTFILES/prelude $HOME/.emacs.d
  # echo 'installed emacs prelude'i

  # zami's plain jane emacs repo.
  # emacs should initialize everything else on first run.
  git clone https://github.com/Zamicol/emacs.git $HOME/.emacs.d
  echo 'cloned emacs to $HOME/.emacs.d'
else
  echo '.emacs.d exists.  Not cloning emacs'
fi


####################
# xmodmap
####################
# also in xsession and xinitrc, putting it here to make sure that it runs
xmodmap $DOTFILES/xmodmap


####################
# Google Chrome
####################
if ! dpkg -l google-chrome-stable > /dev/null; then
  echo "Installing Google Chrome"
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update
  sudo apt-get install -y google-chrome-stable
fi


####################
# Printer
####################
# Brother
# There doesn't appear to be a good way to do this at the moment.
# an automate brother script can currently be found here:
# http://support.brother.com/g/b/downloadend.aspx?c=us&lang=en&prod=mfcj410w_us&os=128&dlid=dlf006893_000&flang=4&type3=625

####################
# golang
####################
# Install manually via https://golang.org/doc/install
# /usr/local/go/bin
if ! hash go 2>/dev/null; then
	echo "Installing Go"
	wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.10.linux-amd64.tar.gz
else
	echo "Go already installed"
fi

# $GOPATH should be set in .profile
echo "gopath: $GOPATH"
echo "goroot: $GOROOT"
# Install go-plus in Atom section.  "apm" depends on atom.


####################
# Atom
####################
# Workaround until apm fixes reinstall of already installed.
# See https://github.com/atom/apm/issues/170
if [ ! -d "$HOME/.atom/packages/go-plus" ]
then
  # Full list of all plugins to install
    apm install go-plus minimap symbols-tree-view atom-beautify file-icons hard-wrap
  else
    echo "Atom package go-plus installed, not trying to install other atom packages.";
fi

# Fix the gawd darmn config file to use tabs and not spaces.
rm $HOME/.atom/config.cson
ln -s $DOTFILES/atom_config.cson $HOME/.atom/config.cson

####################
# VS Code (Visual Studio Code)
####################
if [ hash code 2>/dev/null ]; then
  echo >&2 "Code installed.";
else
  echo >&2 "Code not installed. Installing code";
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get install code

	#Go extension
	# lukehoban.Go appears to be Microsoft's offical go plugin
	code --install-extension lukehoban.Go
	code --install-extension robertohuertasm.vscode-icons
	code --install-extension msjsdiag.debugger-for-chrome
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension HookyQR.beautify
	code --install-extension ronnidc.nunjucks
fi

# Link all setting files
ln -s $DOTFILES/private/visual_studio_code/User/* $HOME/.config/Code/User/


##############
# dotfiles
############

# Set config to ssh and not https
rm $DOTFILES/.git/config
ln -s $DOTFILES/dotfiles_git_config $DOTFILES/.git/config

# Sync
# s
