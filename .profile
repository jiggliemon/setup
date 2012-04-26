DOT_PROFILE_LOADED=1
if [ -n "$BASH_VERSION" ]; then
	[ -f ~/.bashrc ] && ! [ "$DOT_BASHRC_LOADED" == "1" ] && . ~/.bashrc
	[ -f ~/.extra.bashrc ] && . ~/.extra.bashrc
fi
export INVOLVER_TUNNEL='script/tunnel tunnel 10143 3000 48143'


##
# Your previous /Users/chase/.profile file was backed up as /Users/chase/.profile.macports-saved_2012-04-12_at_22:01:49
##

# MacPorts Installer addition on 2012-04-12_at_22:01:49: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

