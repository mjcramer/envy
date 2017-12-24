#!/usr/bin/env python

import boto
import sys
import os

aws_account_id = "661479505642"
mfa_serial_number = "arn:aws:iam::%s:mfa/%s" % (aws_account_id, os.environ['USER'])

if len(sys.argv) < 2:
    mfa_token = raw_input("Please enter MFA token: ")
else:
    mfa_token = sys.argv[1]

#sts = boto.connect_sts()
sts = boto.connect_sts("AKIAJQHEMFUTNAMDVXWA", "GO77R8apIAOXCCa1srOwh16nxrJYgyFFOpfEInGF")
token = sts.get_session_token(duration = 3600, force_new = True, mfa_serial_number = mfa_serial_number, mfa_token = mfa_token)

print 'export AWS_ACCESS_KEY_ID='     + token.access_key
print 'export AWS_SECRET_ACCESS_KEY=' + token.secret_key
print 'export AWS_SECURITY_TOKEN='     + token.session_token
