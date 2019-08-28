#!/usr/bin/env python3

import sys
import os
from jinja2 import Environment

env = Environment()
with open(sys.argv[1]) as template:
    env.parse(template.read())

