
set VIRTUAL_ENV_DISABLE_PROMPT true
set powerline_root (pip3 show powerline-status | sed -E -n 's/^Location: (.+)/\1/p')
set fish_function_path $fish_function_path "$powerline_root/powerline/bindings/fish"
powerline-setup
