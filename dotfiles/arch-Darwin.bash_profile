echo bash profle
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
export EDITOR=vim
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
complete -C /usr/local/bin/kustomize kustomize

