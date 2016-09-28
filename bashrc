#The silly things
alias l='ls -al'
alias node="nodejs"
alias zsd="sudo shutdown -h"
alias zsr="sudo shutdown -r now"
alias a="sudo apt-get install"
alias pwd="/bin/pwd"
export EDITOR=/usr/bin/vim

#get xclip working
#You can pipe to the clipboard like this
#echo "hello" | setclip
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'

#mpush for git
#push to all remotes, "multiple-push"
alias mpush='git remote | xargs -L1 git push --all'

#set default editor.
export VISUAL=vim
export EDITOR="$VISUAL"

#Explicitly set prompt
export PS1='\u@\H:\w$'
