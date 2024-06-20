
# Set up fisher for installing fish packages
if not functions -q fisher
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
#    fish -c fisher
end

# Set up tide prompt 
set -g tide_left_prompt_items time pwd git 
set -g tide_right_prompt_items status cmd_duration jobs virtual_env kubectl toolbox terraform aws 

# Set up path
set -Ua fish_user_paths /usr/local/bin /usr/local/sbin /opt/homebrew/bin ~/envy/bin ~/go/bin '/Applications/IntelliJ IDEA.app/Contents/MacOS' 

# Set up homebrew
if test -e /opt/homebrew/bin/brew 
  eval (/opt/homebrew/bin/brew shellenv)
end

# Set up jenv for managing JDK paths
if test (which jenv)
  status --is-interactive; and jenv init - | source
end

# Need to figure out how to run commands to install a default java and add it to jenv,
# otherwise it complains and uglies the shell
# sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
# jenv add /opt/homebrew/opt/openjdk@17

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

