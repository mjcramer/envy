#!/bin/bash
if [ "$BASH_SOURCE" = "$0" ]; then
    echo "This script can only be sourced."
    exit 1
fi

# This function returns a string intended to be used in the prompt label. It reflects the status of the current directory if it's a git managed directory. 
function prompt_text {
    local git=$(which git)
    if [ -n "$git" ]; then
        status=$(git status --porcelain -b 2> /dev/null | awk '{ if ($1 == "##") { if (gsub(/\.\.\..*/,"",$2)) up = "^"; branch = $2 }; if ($1 ~ "[MDA]") mod = "*"  } END { printf "%s%s%s", branch, mod, up }')
        if [ -n "$status" ]; then
            echo "($status) "
            return
        fi
    fi
}

# Returns a string intended for the shell title. Either the value of the TITLE variable or the current directory.
function title_text {
    if [ -n "$TITLE" ]; then
        echo $TITLE
    else 
        echo $(basename $PWD)
    fi
}

# Set the title and command prompts
case $TERM in
    screen)
        export PROMPT_COMMAND='echo -ne "\033k$(title_text)\033\\"'
        ;;
    *)
		hostname=`hostname -s`
        export PROMPT_COMMAND='echo -ne "\033]0;[${hostname:0:7}] $(title_text)\007"'
        ;;
esac

#export PS1='\[\033[01;35m\][\w]\[\033[00m\] \[\033[01;32m\]$(prompt_text)\[\033[00m\]'
export PS1='\[\033[01;35m\][\u@\h \w]\[\033[00m\] \[\033[01;32m\]$(prompt_text)\[\033[00m\]'

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Setting history length
HISTSIZE=4096
HISTFILESIZE=2048

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar DOESN'T WORK ON MAC

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set up path
export PATH=/usr/bin:/usr/sbin:/bin:/sbin:$PATH	
case $(uname -s) in
	Linux)
		# Set additional path elements
		;;

	Darwin)
		CLICOLOR=1
		export LSCOLORS=Exfxcxdxbxegedabagacad

		# Enable bash completion for homebrew
		if [ -n "$(which brew)" ]; then
		    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
            if [ -f $(brew --prefix)/etc/bash_completion ]; then
			    . $(brew --prefix)/etc/bash_completion
            fi
		fi
		;;
esac

# Load aliases
if [ -e ~/.bash_alias ]; then
	. ~/.bash_alias
fi

# Add scripts directory to path
if [ -d ~/envy/bin ]; then
    export PATH=$PATH:~/envy/bin
fi

# Add current directory to paht
export PATH=$PATH:.

# Set JDK 
if [ -e ~/.jdk ]; then
	export JAVA_HOME=$(head -n 1 ~/.jdk | sed 's/.*\:[ \t]*//')
fi

# Local env 
if [ -e ~/.bash_local ]; then
	. ~/.bash_local
fi

# bash ignore case for completion

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

[[ $- = *i* ]] && bind TAB:menu-complete
