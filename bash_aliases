#The silly things

#-a all, -l long listing, -F append indicator (one of */=>@|) to entries
#-C Columns, -A almost all
alias l='ls -alF'
alias ll='ls -CF'
alias la='ls -A'
alias node="nodejs"
alias zsd="sudo shutdown -h"
alias zsr="sudo shutdown -r now"
alias zsleep="sudo pm-suspend"
alias a="sudo apt-get install"
alias zup="sudo apt-get update && sudo apt-get upgrade -y"
alias pwd="/bin/pwd" #Fixes Mac issue with inaccurate pwd.
alias sha256="sha256sum"
alias sha="sha256sum"
alias zgo="cd ~/dev/go/src/github.com/zamicol"
alias bitcoin="bitcoin-qt"
alias b="xbacklight -set"

#get xclip working
#You can pipe to the clipboard like this
#echo "hello" | setclip
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'

#mpush for git
#push to all remotes, "multiple-push"
alias mpush='git remote | xargs -L1 git push --all'

#http://superuser.com/a/44187
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
