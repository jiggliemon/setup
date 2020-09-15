DOT_PROFILE_LOADED=1
if [ -n "$BASH_VERSION" ]; then
	[ -f ~/.bashrc ] && ! [ "$DOT_BASHRC_LOADED" == "1" ] && . ~/.bashrc
	[ -f ~/.extra.bashrc ] && . ~/.extra.bashrc
fi
PATH=~/.npm-global/bin:$PATH

# Seattle
#alias ocna_on='screen -S ocna -m sudo openconnect  --user=chase.wilson  --authgroup=1  --csd-user=chasewilson  --csd-wrapper=/Users/chasewilson/.cisco/csd-wrapper.sh  --os=mac-intel  --script=/usr/local/etc/vpnc-script  https://se3-p-sec-vpn-01.oracle-ocna.com'

# Chicago
#alias ocna_on='screen -S ocna -m sudo openconnect  --user=chase.wilson  --authgroup=1  --csd-user=chasewilson  --csd-wrapper=/Users/chasewilson/.cisco/csd-wrapper.sh  --os=mac-intel  --script=/usr/local/etc/vpnc-script  https://ld5-c-sec-vpn-01.oracle-ocna.com'

# Wildcard
alias ocna_on='screen -S ocna -m sudo openconnect  --user=chase.wilson  --authgroup=1  --csd-user=chasewilson  --csd-wrapper=/Users/chasewilson/.cisco/csd-wrapper.sh  --os=mac-intel  --script=/usr/local/etc/vpnc-script  https://myaccess.oracle-ocna.com'

alias vpn_on='screen -S vpn -m sudo openconnect myaccess.oraclevpn.com --user chaswils_us`'


