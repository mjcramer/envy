#!/bin/bash

aws ec2 describe-images --owners 099720109477 \
	--filters \
	    Name=architecture,Values=x86_64 \
	    Name=virtualization-type,Values=hvm \
	    Name=root-device-type,Values=ebs |\
	jq -r '.Images[] | .Name + " \t" + .ImageId' |\
	sort

