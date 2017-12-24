#!/usr/bin/env python

import ConfigParser

aws_credentials_file = "~/.aws/credentials"

config = ConfigParser.ConfigParser()
config.read(aws_credentials_file)

print config.defaults()
print config.sections()
print config.get('default', 'aws_access_key_id')
print config.get('default', 'aws_secret_access_key')


#print 'export AWS_ACCESS_KEY_ID='     + token.access_key
#print 'export AWS_SECRET_ACCESS_KEY=' + token.secret_key
#print 'export AWS_SECURITY_TOKEN='     + token.session_token
