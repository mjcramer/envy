
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

# Set up aliases
alias kubectl-devman1='kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-management-1'
alias kubectl-devexec1='kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-execution-1'
alias kubectl-stageman1='kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-management-1'
alias kubectl-stageexec1='kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-execution-1'
alias kubectl-prodman1='kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-management-1'
alias kubectl-prodexec1='kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-execution-1'
alias kubectl-cramerman1='kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-management-1'
alias kubectl-cramerexec1='kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-execution-1'
alias akkasls-dev='akkasls --context=dev'
alias akkaslsadmin-dev='akkaslsadmin --context=dev'
alias akkasls-state='akkasls --context=stage'
alias akkaslsadmin-stage='akkaslsadmin --context=stage'
alias akkasls-prod='akkasls --context=prod'
alias akkaslsadmin-prod='akkaslsadmin --context=prod'
alias akkasls-cramer='akkasls --context=cramer'
alias akkaslsadmin-cramer='akkaslsadmin --context=cramer'

# Set up path
contains $fish_user_paths /path; or set -Ua fish_user_paths /usr/local/bin /usr/local/sbin ~/envy/bin ~/go/bin ~/.gem/ruby/2.6.0/bin

# Set JDK
if test -e /usr/libexec/java_home
  set -x JAVA_HOME (/usr/libexec/java_home)
end

# if [ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
# 	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
# 	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
# fi

# # Enable travis stuff
# [ -f /Users/cramer/.travis/travis.sh ] && source /Users/cramer/.travis/travis.sh

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


