#!/bin/bash
#mvn deploy -DaltDeploymentRepository=tout-repo-release::default::http://tout-repo.local/artifactory/ext-release-local
mvn release:perform -Darguments=-DaltDeploymentRepository=tout-repo-release::default::http://tout-repo.local/artifactory/ext-release-local
