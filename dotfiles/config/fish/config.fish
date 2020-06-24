
if status --is-interactive
	# Set up powerline prompts for much sexy command line!
	set VIRTUAL_ENV_DISABLE_PROMPT true
	set powerline_root (pip3 show powerline-status | sed -E -n 's/^Location: (.+)/\1/p')
	set fish_function_path $fish_function_path "$powerline_root/powerline/bindings/fish"
	powerline-setup
end

# Set up fisher for installing fish packages
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

#set -g fish_user_paths "/usr/local/sbin" "/usr/local/bin" $fish_user_paths
#set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths


# OLD BASH STUFF TO CONVERT
# if [ "$BASH_SOURCE" = "$0" ]; then
#     echo "This script can only be sourced."
#     exit 1
# fi

# # If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# ##
# ## GENERAL OPTIONS 
# ##

# # Prevent file overwrite on stdout redirection
# # Use `>|` to force redirection to an existing file
# set -o noclobber

# # Update window size after every command
# shopt -s checkwinsize

# # Enable history expansion with space
# # E.g. typing !!<space> will replace the !! with your last command
# bind Space:magic-space

# # Turn on recursive globbing (enables ** to recurse all directories)
# shopt -s globstar 2> /dev/null

# ##
# ## HISTORY OPTIONS 
# ##

# # Don't put duplicate lines or lines starting with space in the history.
# HISTCONTROL="erasedups:ignoreboth"

# # Don't record some commands
# export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# # Useful timestamp format
# HISTTIMEFORMAT='%F %T '

# # Huge history. Doesn't appear to slow things down, so why not?
# HISTSIZE=500000
# HISTFILESIZE=100000

# # Append to the history file, don't overwrite it
# shopt -s histappend

# # Save multi-line commands as one command
# shopt -s cmdhist

# # Enable incremental history search with up/down arrows (also Readline goodness)
# # Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'
# bind '"\e[C": forward-char'
# bind '"\e[D": backward-char'

# ##
# ## TAB-COMPLETION (Readline bindings) 
# ##

# # Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on"

# ##
# ## DIRECTORY NAVIGATION 
# ##

# # Prepend cd to directory names automatically
# shopt -s autocd 2> /dev/null

# # Correct spelling errors during tab-completion
# shopt -s dirspell 2> /dev/null

# # Correct spelling errors in arguments supplied to cd
# shopt -s cdspell 2> /dev/null

# # This defines where cd looks for targets
# # Add the directories you want to have fast access to, separated by colon
# # Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
# CDPATH="."

# # Make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# # enable programmable completion features (you don't need to enable
# # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# # sources /etc/bash.bashrc).
# if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#     . /etc/bash_completion
# fi

# # Set up path
# export PATH=/usr/bin:/usr/sbin:/bin:/sbin:$PATH	
# case $(uname -s) in
# 	Linux)
# 		# Set additional path elements
# 		;;

# 	Darwin)
# 		CLICOLOR=1
# 		export LSCOLORS=Exfxcxdxbxegedabagacad

# 		# Enable bash completion for homebrew
# 		if [ -n "$(which brew)" ]; then
# 		    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
#             if [ -f $(brew --prefix)/etc/bash_completion ]; then
# 			    . $(brew --prefix)/etc/bash_completion
#             fi
# 		fi
# 		;;
# esac

# # Load functions
# if [ -e ~/.bash_functions ]; then
# 	. ~/.bash_functions
# fi

# # Load aliases
# if [ -e ~/.bash_alias ]; then
# 	. ~/.bash_alias
# fi

# # Add scripts directory to path
# if [ -d ~/envy/bin ]; then
#     export PATH=$PATH:~/envy/bin
# fi

# # Add current directory to path
# export PATH=$PATH:.

# # Set JDK 
# if [ -e ~/.jdk ]; then
# 	export JAVA_HOME=$(head -n 1 ~/.jdk | sed 's/.*\:[ \t]*//')
# fi

# # Set go
# export PATH=$PATH:/usr/local/opt/go/libexec/bin

# if [ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
# 	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
# 	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
# fi

# # Set powerline
# if [ -d ~/Library/Python/2.7/bin ]; then
#   export PATH=$PATH:~/Library/Python/2.7/bin
# fi
# #powerline_path=$(python -c 'import pkgutil; print pkgutil.get_loader("powerline").filename' 2>/dev/null)
# powerline_path=$(pip3 show powerline-status | sed -E -n 's/^Location: (.+)/\1/p')
# if [ -n "$powerline_path" ]; then
#   powerline-daemon -q
#   POWERLINE_BASH_CONTINUATION=1
#   POWERLINE_BASH_SELECT=1
#   source ${powerline_path}/powerline/bindings/bash/powerline.sh
# fi

# # Set window title 
# export TITLE_COMMAND='echo -ne "\033]0;$(echo $(basename `git rev-parse --show-toplevel 2> /dev/null || pwd`))\007"'
# export PROMPT_COMMAND="$PROMPT_COMMAND; eval '$TITLE_COMMAND'"

# # Enable travis stuff 
# [ -f /Users/cramer/.travis/travis.sh ] && source /Users/cramer/.travis/travis.sh

# # Local env 
# [ -f ~/.bash_local ] && source ~/.bash_local

# #!/bin/bash
# if [ "$BASH_SOURCE" = "$0" ]; then
#     echo "This script can only be sourced."
#     exit 1
# fi

# function title {
#     echo -ne "\033]0;"$*"\007"
# }

# # Source .env files upon entering a directory
# function source_env {
#   if [ -f "$PWD/.env" ]; then
#     source "$PWD/.env"
#   fi
# }

# #function cd { 
# #  builtin cd "$@" && source_env
# #  [ -d "$PWD/.git" ] && title $(basename $PWD) || true
# #}

# function pushd { 
#   builtin pushd "$@" && source_env
# }

# function popd { 
#   builtin popd "$@" && source_env
# }

# function cdf {
#   cd $(dirname $(find . -name $1))
# }

# function killjob {
# 	kill -9 $(jobs -p $1)
# }

# function sbt-test {
# 	sbt test | \
# 		tail -1 | \
# 		sed 's/^.*Total time: \(.*\), completed \(.*\)/Total time:: \1, completed \2/' | \
# 		say --progress --interactive 
# }
# #!/bin/bash
# if [ "$BASH_SOURCE" = "$0" ]; then
#     echo "This script can only be sourced."
#     exit 1
# fi

# alias ..='cd ..'
# alias .1='cd ..'
# alias .2='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'
# alias .6='cd ../../../../../..'
# alias .7='cd ../../../../../../..'
# alias .8='cd ../../../../../../../..'
# alias .9='cd ../../../../../../../../..'
# alias less='less -r'
# alias mkdir='mkdir -pv'
# alias grep='grep --color=auto'
# alias egrep='egrep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias search='grep -IRHn --color=auto --exclude-dir=target --exclude-dir=logs'
# alias h='history'
# alias j='jobs -l'
# alias path='echo -e ${PATH//:/\\n}'
# alias svi='sudo vi'
# alias ping='ping -c 5'
# alias pingfast='ping -c 100 -s.2'
# which exa >/dev/null && alias ls='exa -G --group-directories-first'
# which exa >/dev/null && alias ll='exa -l --git --group-directories-first'
# which exa >/dev/null && alias l='exa -1 --group-directories-first'
# which exa >/dev/null && alias lsa='exa -aG --group-directories-first'
# which exa >/dev/null && alias lla='exa -al --git --group-directories-first'
# which exa >/dev/null && alias l.='exa -dG .* --group-directories-first'
# alias now='date +"%T"'
# alias nowtime=now
# alias nowdate='date +"%d-%m-%Y"'
# alias listening='lsof -Pn -i4TCP -sTCP:LISTEN'
# alias vi=/usr/local/bin/vim
# alias killvideo='sudo killall VDCAssistant'
# #	alias ipt='sudo /sbin/iptables'
# #	alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
# #	alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
# #	alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
# #	alias iptlistfw='sudo /sbin/iptables -L FORWORD -n -v --line-numbers'
# #	alias header='curl -I'
# #	alias headerc='curl -I --compress'
# #	alias root='sudo -i'
# #	alias meminfo='free -m -l -t'
# #	alias psmem='ps auxf | sort -nr -k 4'
# #	alias psmem10='ps auxf | sort -nr -k 4 | head -10'
# #	alias pscpu='ps auxf | sort -nr -k 3'
# #	alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
# #	alias cpuinfo='lscpu'
# #	alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# alias vbm='VBoxManage'
# alias pyjson='python -m json.tool'


