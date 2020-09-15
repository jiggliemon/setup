if ! [ "$PS1" == "" ]; then
	DOT_BASHRC_LOADED=1
	! [ "$DOT_PROFILE_LOADED" == "1" ] && . ~/.profile
fi
PATH=~/.npm-global/bin:$PATH
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
