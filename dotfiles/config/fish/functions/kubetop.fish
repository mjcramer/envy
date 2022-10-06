kubectl top pods --all-namespaces | sort --key 2 -b | awk 'NR<2{print $0;next}{print $0| "sort --key 3 --numeric -b --reverse"}'

#Sort (descending order) current Memory usage of pods in all Namespaces 
kubectl top pods --all-namespaces | sort --key 2 -b | awk 'NR<2{print $0;next}{print $0| "sort --key 4 --numeric -b --reverse"}'

#Sort (descending order) current CPU usage of containers in pods in all Namespaces 
kubectl top pods --all-namespaces --containers=true | sort --key 4 -b | awk 'NR<1{print $0;next}{print $0| "sort --key 4 --numeric -b --reverse"}'

#Sort (descending order) current Memory usage of containers in pods in all Namespaces 
kubectl top pods --all-namespaces --containers=true | sort --key 5 -b | awk 'NR<1{print $0;next}{print $0| "sort --key 5 --numeric -b --reverse"}'

 



# Defined in - @ line 1
function cmdline --description "Show the command line for given process id"
  for pid in $argv
    ps -p $pid -o command -ww
  end
end
