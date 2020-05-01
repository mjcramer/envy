# Defined in - @ line 1
function listening --description "List the processes listening on each port" 
    #jps -m
    lsof -Pn -i4TCP -sTCP:LISTEN #| awk '{ print $1, $2, $3, $8, $9 }' 
end
