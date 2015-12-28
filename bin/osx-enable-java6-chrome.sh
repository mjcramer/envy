#!/bin/env bash

if [ $UID -ne 0 ]; then
	echo "You must run this script as root or with sudo."
	exit 1
fi

plugins_dir=/Library/Internet\ Plug-Ins
mkdir -p $plugins_dir/disabled
mv $plugins_dir/JavaAppletPlugin.plugin $plugins_dir/disabled
ln -sf /System/Library/Java/Support/Deploy.bundle/Contents/Resources/JavaPlugin2_NPAPI.plugin $plugins_dir/JavaAppletPlugin.plugin
ln -sf /System/Library/Frameworks/JavaVM.framework/Commands/javaws /usr/bin/javaws
