#!/bin/bash

kubectl run -i --tty --rm busybox --image=busybox --restart=Never -- sh
