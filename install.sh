#!/bin/sh
# When possible, use XDG directory structure.
#
#
# Manual Items:
#
# - To change look and feel, use lxappearance
# - Install Go.  The $GOPATH is set by this script.

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
# Repos
####################
REPOS="ppa:webupd8team/atom ppa:bitcoin/bitcoin"

####################
# Packages
####################
# Packages to be installed on the system.
# Some of these are needed for this script,
PACKAGES="git vim curl openssh-server lynx htop tmux ncdu"

# Bloat packages
# `dconf-tools` is for system config editing.  The package installs `dconf-editor`
PACKAGES="$PACKAGES chromium-browser gparted emacs24 xclip dconf-tools dconf-tools bitcoin-qt"

# i3wm
# and desktop environment
#
# `feh` is for x desktop background.
# `sysstat` is for i3blocks cpu stats.
# `lxappearance` is for caja's icons and theme
# `compton` is compositing manager
# `xbacklight` controls display's backlight.
PACKAGES="$PACKAGES i3 dmenu i3status i3lock feh sysstat lxappearance xbacklight compton"

# MATE
# caja-share is for smb gui sharing.
PACKAGES="$PACKAGES caja-share"

# Dev packages
PACKAGES="$PACKAGES atom"

# QuickTile packages
PACKAGES="$PACKAGES python python-gtk2 python-xlib python-dbus python-wnck"

####################
# Files
####################
# Symlink from dotfiles to home.
# Will not overwrite existing
# Files with be prepended with a dot.
SYMLINKS="bashrc bash_aliases bash_aliases_private xsession profile profile_private xinitrc gitconfig fonts"
# Create these dirs if not exist.
DIRS="$HOME/dev/go $HOME/.config/i3 $HOME/.ssh $HOME/.config/i3status \
$HOME/.config/i3blocks $DOTFILES/fonts"


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
for r in $REPOS; do
  echo "Adding repo $r"
  sudo add-apt-repository $r -y
done
# Update packages that are now available
sudo apt-get update


####################
# Install Packages
####################
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

####################
# git
####################
git config --global core.excludesfile "$DOTFILES/gitignore_global"


####################
# i3
####################
# Remove default config and link to dotfile config
rm $HOME/.i3/config
ln -s $DOTFILES/i3/config $HOME/.config/i3/config

# i3status and i3block
# this config should read first before the "default" /etc/i3status.conf
# according to https://i3wm.org/i3status/manpage.html and
# https://vivien.github.io/i3blocks/
ln -s $DOTFILES/i3/i3status.conf $HOME/.config/i3status/config
ln -s $DOTFILES/i3/i3blocks.conf $HOME/.config/i3blocks/config
# i3blocks
git clone git://github.com/vivien/i3blocks $HOME/dev/i3blocks
(cd $HOME/dev/i3blocks/ && make clean debug && sudo make install)


####################
# ssh
####################
echo "Setting up ssh"
if [ ! -d $HOME/.ssh ]; then
  chmod 700 $HOME/.ssh
fi
if [ ! -f $HOME/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
fi
if [ ! -f $HOME/.ssh/authorized_keys ]; then
  cp $DOTFILES/authorized_keys $HOME/.ssh/authorized_keys
fi


####################
# private
####################
cd $DOTFILES
git clone git@bitbucket.org:zamicol/private.git

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
echo "Golang setup"
# $GOPATH should be set in .profile
echo "gopath: $GOPATH"
echo "goroot: $GOROOT"
# Install go-plus in Atom section.  "apm" depends on atom.


####################
# Atom
####################
# Workaround until apm fixes reinstall of already installed.
# See https://github.com/atom/apm/issues/170
if [[ ! -d "$HOME/.atom/packages/go-plus" ]]
then
    apm install go-plus minimap symbols-tree-view atom-beautify
fi

####################
# VS Code
####################

if [ hash code 2>/dev/null ]; then
  echo >&2 "Code not installed.";
else
  echo >&2 "Code installed.";
fi

#Go extension
code --install-extension lukehoban.Go
code --install-extension robertohuertasm.vscode-icons
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension dbaeumer.vscode-eslint
code --install-extension HookyQR.beautify
code --install-extension ronnidc.nunjucks
