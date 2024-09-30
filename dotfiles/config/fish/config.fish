
# Set up fisher for installing fish packages
if not functions -q fisher
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

# Set up tide prompt 
set -g tide_left_prompt_items time pwd git 
set -g tide_right_prompt_items status cmd_duration jobs virtual_env kubectl toolbox terraform aws 

# Adds path element to path if not already contained
function add_paths_to_fish_user_paths
    # Loop through each path in the list
    for path in $argv
        # Check if the path is already in user paths 
        if not contains $path $fish_user_paths
          set -Ua fish_user_paths $path 
          echo "Added $path to fish_user_paths..."
        end
    end
end

# Set up path
add_paths_to_fish_user_paths /opt/homebrew/bin ~/envy/bin ~/go/bin /usr/local/bin 

# Set up homebrew
if test -e /opt/homebrew/bin/brew 
  eval (/opt/homebrew/bin/brew shellenv)
end

# Set up jenv for managing JDK paths
if test (which jenv)
  status --is-interactive; and jenv init - | source
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

# Read any other files
for file in (status dirname)/config_*.fish;
  source $file;
end

