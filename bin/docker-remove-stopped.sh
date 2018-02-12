#!/bin/bash

docker ps -aq -f status=exited --no-trunc | xargs docker rm
