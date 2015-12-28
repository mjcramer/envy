#!/bin/bash

if [ -z "$1" ]; then
    dest=.
else
    dest=$1
fi

mvn -U org.apache.maven.plugins:maven-dependency-plugin:2.7:get \
    -DgroupId=com.tout \
    -DartifactId=tout-orgservice \
    -Dversion=0.9.1 \
    -DremoteRepositories=tout-repo-release::default::http://tout-repo.local/artifactory/libs-release-local \
    -Ddest=$dest
