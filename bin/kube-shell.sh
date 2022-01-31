#!/bin/bash

kubectl run -i --tty --rm cramer-toolbox --image=mjcramer/toolbox --restart=Never
