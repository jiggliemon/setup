if ! [ "$PS1" == "" ]; then
	DOT_BASHRC_LOADED=1
	! [ "$DOT_PROFILE_LOADED" == "1" ] && . ~/.profile
fi

export STOCO_DEV_USER="idDom099fhd.autotester099-ADMIN"
export CONSOLE_USER=autotester002-ADMIN

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
