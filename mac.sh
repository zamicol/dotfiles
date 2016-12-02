# Mac shell file
# Put mac specific things in here.


ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
ln -s ~/.dotfiles/bashrc $HOME/.bashrc
ln -s ~/.dotfiles/profile $HOME/.profile



//Atom
apm install project-manager

//PROBLEMS WITH MAC
//Use /bine/pwd instead of pwd as pwd is innacurate.
