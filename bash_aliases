#The silly things

#-a all, -l long listing, -F append indicator (one of */=>@|) to entries
#-C Columns, -A almost all
alias l='ls -alF'
alias ll='ls -CF'
alias la='ls -A'
alias node="nodejs"
alias zsd="sudo shutdown -h"
alias zsr="sudo shutdown -r now"
alias a="sudo apt-get install"
alias zup="sudo apt-get update && sudo apt-get upgrade -y"
alias pwd="/bin/pwd"


#get xclip working
#You can pipe to the clipboard like this
#echo "hello" | setclip
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'

#mpush for git
#push to all remotes, "multiple-push"
alias mpush='git remote | xargs -L1 git push --all'
