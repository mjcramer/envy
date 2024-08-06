# Set up fnm for node management
if type -q fnm
  status is-interactive && fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled | source
  fnm completions --shell fish | source
end

