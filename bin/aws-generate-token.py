#!/usr/bin/env python

import boto
import sys
import ConfigParser
import os.path
aws_credentials = "~/.aws/credentials"
aws_account_id = "661479505642"

if not os.path.isfile(aws_credentials): 
    print "Your AWS credentials cannot be found: %s does not exist" % (aws_credentials) 
    sys.exit(1)

config = ConfigParser.ConfigParser()
config.read(aws_credentials)

[default]
access_key = config.get('default', 'aws_access_key_id')
secret_key = config.get('default', 'aws_secret_access_key')
mfa_serial_number = 'arn:aws:iam::%s:mfa/' + config.get('credentials', 'USERNAME')
mfa_token = sys.argv[1]

sts = boto.connect_sts(access_key, secret_key)
token = sts.get_session_token(
            duration = 3600,
                force_new = True,
                    mfa_serial_number = mfa_serial_number,
                        mfa_token = mfa_token
                        )

#print 'Run this in your console:'
print 'export AWS_ACCESS_KEY_ID='     + token.access_key
print 'export AWS_SECRET_ACCESS_KEY=' + token.secret_key
print 'export AWS_SESSION_TOKEN='     + token.session_token
