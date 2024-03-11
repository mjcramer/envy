
# Set up fisher for installing fish packages
#if not functions -q fisher
#    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
#    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
#    fish -c fisher
#end

# Set up tide prompt 
set -g tide_left_prompt_items time pwd git 
set -g tide_right_prompt_items status cmd_duration jobs virtual_env kubectl toolbox terraform aws 

# Set up path
set -Ua fish_user_paths /usr/local/bin /usr/local/sbin ~/envy/bin ~/go/bin 

# Set up jenv for managing JDK paths
if test (which jenv)
  status --is-interactive; and jenv init - | source
end

if test -e /usr/libexec/java_home
  set -x JAVA_HOME (/usr/libexec/java_home)
end

# Set up fnm for node management
if test (which fnm) 
  fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled | source
end

# Set up completions
for command in "cr op" 
  which $command >/dev/null && eval ($command completion fish)
end

# Common aliases
alias less='less -r'
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias h='history'
alias j='jobs -l'
alias ping='ping -c 5'
alias pingfast='ping -c 100 -s.2'
alias ls='lsd'
alias now='date +"%T"'
alias vbm='VBoxManage'

# Read any other files
for file in (status dirname)/config_*.fish;
  source $file;
end

