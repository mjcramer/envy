
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
export EDITOR="/usr/local/bin/mate -w"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
