# Defined in - @ line 1
function fish_title --description "Set the window title dir or name of git repo"
    basename (git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
end
