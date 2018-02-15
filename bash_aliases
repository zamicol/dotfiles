# bash_aliases.sh

################
# Aliases
################
alias e="exit"
alias q="exit"
alias l=listWithCount
alias ll='ls -CF'
alias la='ls -A'
alias zsd="sudo shutdown -h"
alias zsr="sudo shutdown -r now"
alias zinstall=". ~/.dotfiles/install.sh"
alias zup="sudo apt-get update; sudo apt-get -y upgrade; sudo apt autoremove -y"
alias a="sudo apt-get install -y "
alias zsleep="mate-screensaver-command -l; echo 'sleeping'; sudo pm-suspend"
alias zsleeps="mate-screensaver-command -l; s; echo 'sleeping'; sudo pm-suspend"
alias zhib="mate-screensaver-command -l; echo 'hibernating'; sudo systemctl hibernate"
alias zhibs="mate-screensaver-command -l; s; echo 'hibernating'; sudo systemctl hibernate"
# Death
# shred -vfz ~/
# shred -vfz /
# shred -vfz -n 10 /dev/sda
alias zdiez="echo 'Goodbye beautiful universe!'; sudo echo 'I love you!'"
# Dev
alias zgo="cd ~/dev/go/src/github.com/zamicol"

################
# Crypto
################
# SHA256 example:
#
#    echo -n 'bob' | sha
#
# don't forget the newline in echo.  Use "-n"
alias sha256="sha256sum"
alias sha="sha256sum"
alias sha64=sha64func
alias esha64=esha64func
alias esha=esha64func

################
# Applications
################
alias s=". ~/.dotfiles/sync.sh"
alias zsync=". ~/.dotfiles/sync.sh"
alias dock=". ~/.dotfiles/dock.sh"
alias undock=". ~/.dotfiles/undock.sh"
alias bitcoin="bitcoin-qt"
alias node="nodejs"
alias b="xbacklight -set"
alias extract="x"
# get xclip working
# You can pipe to the clipboard like this
# echo "hello" | clipset
alias clipset='xclip -selection c'
alias clipget='xclip -selection clipboard -o'

################
# Fixes
################
alias pwd="/bin/pwd" # Fixes Mac issue with inaccurate pwd.

################
# Git
################
# mpush for git
# push to all remotes, "multiple-push"
alias gitpp='git pull && git push'
alias gitp=gitpp
alias mpush='git remote | xargs -L1 git push --all'

################
# Functions
################
# -a all, -l long listing, -F append indicator (one of */=>@|) to entries
# -C Columns, -A almost all
# Old ls:
# alias l='ls -alF'
# List with count printed at bottom.
listWithCount() {
 ls -alF --color=always | awk 'BEGIN {i=-2;f=0;d=-2} {if ($0 ~/^[d|\-]/) {i+=1} if ($0 ~/^d/) {d+=1} if ($0 ~/^\-/) {f+=1} print $0} END {print "Files:"f " Dirs:"d " Nodes:"i  }'
}

# sha64func is a one liner for getting the sha256 sum as base64.
# Example:
#
#    echo -n 'bob' | sha64
#
# Outputs:
#
#     gbY32PzSxtpjWeaWMROhFw3nleS3JbhNHgtM/Z7FjOk=
sha64func(){
 sha $1 | awk '{print $1}'| xxd -r -p | base64
}

# esha64func is for "echo" sha 64.
# Eample:
#
#     esha bob
#
# Outputs:
#
#     gbY32PzSxtpjWeaWMROhFw3nleS3JbhNHgtM/Z7FjOk=
esha64func(){
 echo -n "$1" | sha64func
}

# Unzip using `x <filename>`
# http://superuser.com/a/44187
x(){
 if [ -f $1 ] ; then
  case $1 in
   *.tar.bz2)   tar xvjf $1    ;;
   *.tar.gz)    tar xvzf $1    ;;
   *.bz2)       bunzip2 $1     ;;
   *.rar)       unrar x $1     ;;
   *.gz)        gunzip $1      ;;
   *.tar)       tar xvf $1     ;;
   *.tbz2)      tar xvjf $1    ;;
   *.tgz)       tar xvzf $1    ;;
   *.zip)       unzip $1       ;;
   *.Z)         uncompress $1  ;;
   *.7z)        7z x $1        ;;
   *)           echo "Unable to extract '$1'" ;;
  esac
 else
  echo "'$1' is not a valid file"
 fi
}
