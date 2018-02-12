#!/bin/bash

docker images --quiet --filter=dangling=true | xargs docker rmi -f
