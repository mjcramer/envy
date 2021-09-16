# Defined in - @ line 1
function cmdline --description "Show the command line for given process id"
  for pid in $argv
    ps -p $pid -o command -ww
  end
end
