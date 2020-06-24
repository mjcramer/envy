# Defined in - @ line 1
function kubeworkmgmt --description "kubectl alias for workbench management cluster"
	set -q namespace[1] or set namespace[1] "default"
	echo kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-management-1 \
		--namespace=$namespace \
		$argv
end

# Defined in - @ line 1
function kubeworkexec --description "kubectl alias for workbench execution cluster"
	set -q namespace[1] or set namespace[1] "default"
	echo kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-execution-1 \
		--namespace=$namespace \
		$argv
end


# Defined in - @ line 1
function kubedevexec --description "kubectl alias for workbench management cluster"
	set -q namespace[1] or set namespace[1] "default"
	echo kubectl --context=gke_streamfitters-guild_us-east1_cramer-us-east-execution-1 \
		--namespace=$namespace \
		$argv
end

