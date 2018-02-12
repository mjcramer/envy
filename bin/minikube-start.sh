#!/bin/bash

minikube start --vm-driver virtualbox \
	--cpus 8 \
	--disk-size 20g \
	--dns-domain "vitalfish.co" \
	--memory 8092 \
	--log_dir /tmp/minikube \
	--loglevel 0

