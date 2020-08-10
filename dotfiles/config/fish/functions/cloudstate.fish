function kube-dm1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-management-1' --description 'alias kube-dm1=kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-management-1'
  kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-management-1 $argv;
end

function kube-de1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-execution-1' --description 'alias kube-de1=kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-execution-1'
  kubectl --context=gke_cloudstateengine_us-east1_dev-us-east-execution-1 $argv;
end

function kube-sm1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-management-1' --description 'alias kube-sm1=kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-management-1'
  kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-management-1 $argv;
end

function kube-se1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-execution-1' --description 'alias kube-se1=kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-execution-1'
  kubectl --context=gke_cloudstateengine_us-east1_stage-us-east-execution-1 $argv;
end

function kube-pm1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-management-1' --description 'alias kube-pm1=kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-management-1'
  kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-management-1 $argv;
end

function kube-pe1 --wraps='kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-execution-1' --description 'alias kube-pe1=kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-execution-1'
  kubectl --context=gke_cloudstateengine_us-east1_prod-us-east-execution-1 $argv;
end

function csd --wraps='csctl --context=dev' --description 'alias csd=csctl --context=dev'
  csctl --context=dev $argv;
end

function css --wraps='csctl --context=stage' --description 'alias csd=csctl --context=stage'
  csctl --context=stage $argv;
end

function csp --wraps='csctl --context=prod' --description 'alias csp=csctl --context=prod'
  csctl --context=prod $argv;
end

function csad --wraps='csadmin --context=dev' --description 'alias csad=csadmin --context=dev'
  csadmin --context=dev $argv;
end

function csas --wraps='csadmin --context=stage' --description 'alias csas=csadmin --context=stage'
  csadmin --context=stage $argv;
end

function csap --wraps='csadmin --context=prod' --description 'alias csap=csadmin --context=prod'
  csadmin --context=prod $argv;
end



#function cse-config --description "Manages tool configuration for cloudstate environments"
#    if count $argv > /dev/null
#        open $argv
#
#        kubectl config get-contexts -o name
#
#    else
#        echo "Current gcloud configuration:"
#        gcloud config list
#        echo "Current kubectl configuration:"
##        kubectl config get-contexts
#        echo "Current csctl configuration:"
#        csctl config list-contexts
#        csctl config current-context
#    end
#	    set -q namespace[1] or set namespace[1] "default"
#	    kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-execution-1 \
#		    --namespace=$namespace \
#		    $argv
#end

# PS3='Please enter your choice: '
# options=("Option 1" "Option 2" "Option 3" "Quit")
# select opt in "${options[@]}"
# do
#     case $opt in
#         "Option 1")
#             echo "you chose choice 1"
#             ;;
#         "Option 2")
#             echo "you chose choice 2"
#             ;;
#         "Option 3")
#             echo "you chose choice $REPLY which is $opt"
#             ;;
#         "Quit")
#             break
#             ;;
#         *) echo "invalid option $REPLY";;
#     esac
# done
