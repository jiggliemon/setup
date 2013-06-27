######
# .extra.bashrc - Isaac's Bash Extras
# This file is designed to be a drop-in for any machine that I log into.
# Currently, that means it has to work under Darwin, Ubuntu, and yRHEL
#
# Per-platform includes at the bottom, but most functionality is included
# in this file, and forked based on resource availability.
#
# Functions are preferred over shell scripts, because then there's just
# a few files to rsync over to a new host for me to use it comfortably.
#
# .extra_Darwin.bashrc has significantly more stuff, since my mac is also
# a GUI environment, and my primary platform.
######
main () {
# Note for Leopard Users #
# If you use this, it will probably make your $PATH variable pretty long,
# which will cause terrible performance in a stock Leopard install.
# To fix this, comment out the following lines in your /etc/profile file:

# if [ -x /usr/libexec/path_helper ]; then
#   eval `/usr/libexec/path_helper -s`
# fi

# Thanks to "allan" in irc://irc.freenode.net/#textmate for knowing this!
echo "loading bash extras..."


# try to avoid polluting the global namespace with lots of garbage.
# the *right* way to do this is to have everything inside functions,
# and use the "local" keyword.  But that would take some work to
# reorganize all my old messes.  So this is what I've got for now.
__garbage_list=""
__garbage () {
  local i
  if [ $# -eq 0 ]; then
    for i in ${__garbage_list}; do
      unset $i
    done
    unset __garbage_list
  else
    for i in "$@"; do
      __garbage_list="${__garbage_list} $i"
    done
  fi
}
__garbage __garbage
__garbage __set_path

__set_path () {
  local var="$1"
  local orig=$(eval 'echo $'$var)
  orig="${orig//:/ } "
  local p="$2"

  local path_elements="${p//:/ }"
  p=""
  local i
  for i in $path_elements; do
    if [ -d $i ]; then
      p="$p$i "
      # strip out from the original set.
      orig=${orig/$i /}
    fi
  done
  for i in $orig; do
    if ! [ -d $i ]; then
      orig=${orig/$i /}
    fi
  done
  # put the original at the front, but only the ones that aren't already present
  # This preserves the intended ordering, and allows env hijacking tricks like
  # nave and other subshell programs use.
  p="$orig $p"
  export $var=$(p=$(echo $p); echo ${p// /:})
}

__garbage __form_paths
local path_roots=(/opt/local/bin /opt/local/sbin)
__form_paths () {
  local r p paths
  paths=""
  for r in "${path_roots[@]}"; do
    for p in "$@"; do
      paths="$paths:$r$p"
    done
  done
  echo ${paths/:/} # remove the first :
}
#Add directories to the PATH if they exist
__set_path PATH "$(__form_paths):/opt/local/bin:/opt/local/sbin"
__set_path LD_LIBRARY_PATH "$(__form_paths lib)"

# set rvm path if it exists
[ -d $HOME/bin ] && __set_path PATH "$HOME/bin"
#[ -d /usr/local/lib/node ] && __set_path "/usr/local/lib/node"
[ -d $HOME/local/bin ] && __set_path PATH "$HOME/local/bin"
[ -d $HOME/local/node/bin ] && __set_path PATH "$HOME/local/node/bin"
[ -d $HOME/lib/node_modules/.bin ] && __set_path PATH "$HOME/lib/node_modules/.bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Use UTF-8, and throw errors in PHP and Perl if it's not available.
# Note: this is VERY obnoxious if UTF8 is not available!
# That's the point!
# export LC_CTYPE=en_US.UTF-8
# export LC_ALL=""
# export LANG=$LC_CTYPE
# export LANGUAGE=$LANG
# export TZ=America/Los_Angeles
export HISTSIZE=10000
export HISTFILESIZE=1000000000
# # I prefer to use : instead of ^ for history replacements
# # much faster to type.  It'd be neat to use /, but then it gets
# # confused with absolute paths, like "/bin/env"
# export histchars="!:#"
# 
# if ! [ -z "$BASH" ]; then
#   __garbage __shopt
#   __shopt () {
#     local i
#     for i in "$@"; do
#       shopt -s $i
#     done
#   }
#   # see http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#The-Shopt-Builtin
#   __shopt \
#     histappend histverify histreedit \
#     cdspell expand_aliases cmdhist \
#     hostcomplete no_empty_cmd_completion nocaseglob
# fi


# grep=grep
# if [ "$(grep --help | grep color)" != "" ]; then
#   grep="grep --color"
# elif [ "$(grep --help | grep colour)" != "" ]; then
#   grep="grep --colour"
# fi
# alias grep="$grep"

export SVN_RSH=ssh
export RSYNC_RSH=ssh
export INPUTRC=$HOME/.inputrc
export CLICOLOR=1
export LSCOLORS=GxfxcxDxhxegedabagacad

 #my list of editors, by preference.
__edit_cmd=vim
alias edit="${__edit_cmd}"
alias e="${__edit_cmd} ."
ew () {
  edit $(which $1)
}
alias sued="sudo ${__edit_cmd}"
export EDITOR=vim
export VISUAL="$EDITOR"
__garbage __get_edit_cmd __edit_cmd

# a friendlier delete on the command line
alias emptytrash="find $HOME/.Trash -not -path $HOME/.Trash -exec rm -rf {} \; 2>/dev/null"

lscolor=""
__garbage lscolor
if [ "$TERM" != "dumb" ] && [ -f "$(which dircolors 2>/dev/null)" ]; then
  eval "$(dircolors -b)"
  lscolor=" --color=auto"
  #alias dir='ls --color=auto --format=vertical'
  #alias vdir='ls --color=auto --format=long'
fi
ls_cmd="ls$lscolor"
__garbage ls_cmd
alias ls="$ls_cmd"
alias la="$ls_cmd -Flas"
alias lal="$ls_cmd -FLlash"
alias ll="$ls_cmd -Flsh"
alias ag="alias | grep"
alias lg="$ls_cmd -Flash | grep --color"

# wget curl replacement
alias wget="curl -O"

alias mysql=/usr/local/mysql-5.5.24-osx10.6-x86_64/bin/mysql

# fail if the file is not an executable in the path.
inpath () {
  ! [ $# -eq 1 ] && echo "usage: inpath <file>" && return 1
  f="$(which "$1" 2>/dev/null)"
  [ -f "$f" ] && return 0
  return 1
}

#make tree a little cooler looking.
alias tree="tree -CFa -I 'rhel.*.*.package|.git' --dirsfirst"

prof () {
  . $HOME/.extra.bashrc
}
editprof () {
  s=""
  if [ "$1" != "" ]; then
    s="_$1"
  fi
  $EDITOR $HOME/.extras.bashrc
  prof
}

pushprof () {
  [ "$1" == "" ] && echo "no hostname provided" && return 1
  local failures=0
  local rsync="rsync --copy-links -v -a -z"
  for each in "$@"; do
    if [ "$each" != "" ]; then
      if $rsync $HOME/.ssh/*{.pub,authorized_keys,config} $each:~/.ssh/ && \
         $rsync $HOME/.{inputrc,profile,extra,git,vim,gvim}* $each:~
      then
        echo "Pushed bash extras and public keys to $each"
      else
        echo "Failed to push to $each"
        let 'failures += 1'
      fi
    fi
  done
  return $failures
}

# set the bash prompt and the title function
PROMPT_COMMAND='
echo -ne "\033[0;0m";history -a
echo "         "
DIR=${PWD/$HOME/\~}
echo -ne "\033]0;$(__git_ps1 "%s - " 2>/dev/null)$HOSTNAME:$DIR\007"
# Git Branch Notification
echo -ne "\033[0;37m$USER@$(uname -n):$(__git_ps1 "\e[0;33m %s \e[0;0m" 2>/dev/null)"'
#this part gets repeated when you tab to see options
PS1='\n\w \[\033[36m\]\t\[\e[m\] \\$ '

# shorthand for checking on ssh agents.
sshagents () {
  pg -i ssh
  set | grep SSH | grep -v grep
  find /tmp/ -type s | grep -i ssh
}
# shorthand for creating a new ssh agent.
agent () {
  eval $( ssh-agent )
  ssh-add
}


# floating-point calculations
calc () {
  local expression="$@"
  [ "${expression:0:6}" != "scale=" ] && expression="scale=16;$expression"
  echo "$expression" | bc
}

# more handy wget for fetching files to a specific filename.
fetch_to () {
  local from=$1
  local to=$2
  [ "$to" == "" ] && to=$( basname "$from" )
  [ "$to" == "" ] && echo "usage: fetch_to <url> [<filename>]" && return 1
  wget -U "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.5) Gecko/2008120121 Firefox/3.0.5" -O "$to" "$from" || return 1
}

# convert dmgs to isos
dmg2iso () {
  dmg="$1"
  iso="${dmg%.dmg}.iso"
  hdiutil convert "$dmg" -format UDTO -o "$iso" \
    && mv "$iso"{.cdr,} \
    && return 0
  return 1
}

#load any per-platform .extra.bashrc files.

#__garbage arch machinearch
arch=$(uname -s)
machinearch=$(uname -m)
[ -f $HOME/.extra_$arch.bashrc ] && . $HOME/.extra_$arch.bashrc
[ -f $HOME/.extra_${arch}_${machinearch}.bashrc ] && . $HOME/.extra_${arch}_${machinearch}.bashrc
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f /opt/local/etc/bash_completion ] && . /opt/local/etc/bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f $HOME/etc/bash_completion ] && . $HOME/etc/bash_completion
inpath "git" && [ -f $HOME/.git-completion ] && . $HOME/.git-completion

# call in the cleaner.
__garbage
return 0
export BASH_EXTRAS_LOADED=1
}
main
unset main
