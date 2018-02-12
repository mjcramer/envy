#!/bin/bash

base=$(cd $(dirname $0)/..; pwd -P)
ansible-playbook \
	--inventory "localhost, " \
	--connection local \
	--extra-vars "download_dir=$HOME/Downloads scala_version=2.11.8 spark_version=1.6.1 hadoop_version=2.6.4" \
	--tags download \
	$base/playbooks/download.yml
