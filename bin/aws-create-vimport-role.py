#!/usr/bin/env python3

import argparse
import boto3
import json
import os

parser = argparse.ArgumentParser(__file__, __doc__, description='This script creates a role in AWS that allows for the importing of custom machine images.', formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
parser.add_argument('--version', action='version', version='{} 1.0'.format(os.path.basename(__file__)))
parser.add_argument('-b', '--bucket', type=str, dest='bucket', help="The name of the S3 bucket to create.")
parser.add_argument('-r', '--role', type=str, dest='role', default='vmimport', help="The name of the IAM role to create.")
args = parser.parse_args()


def validate(arg, message):
  if not arg:
    return input(message)
  else:
    return arg

bucket_name = validate(args.bucket, "Please enter the name of the S3 bucket to create: ")

trust_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": { "Service": "vmie.amazonaws.com" },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals":{
                    "sts:Externalid": "vmimport"
                }
            }
        }
    ]
}

role_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::{}".format(bucket_name)
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::{}/*".format(bucket_name)
            ]
        },
        {
            "Effect": "Allow",
            "Action":[
                "ec2:ModifySnapshotAttribute",
                "ec2:CopySnapshot",
                "ec2:RegisterImage",
                "ec2:Describe*"
            ],
            "Resource": "*"
        }
    ]
}

s3 = boto3.resource('s3')

if s3.Bucket(bucket_name) in s3.buckets.all():
    print("Bucket {} already exists, no need to create...".format(bucket_name))
else:
    response = s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration={'LocationConstraint': 'us-west-1'})

iam = boto3.resource('iam')

if iam.Role('vmimport') in iam.roles.all():
    print("Role 'vmimport' already exists. Please check to see that it has the following trust policy: \n{}\n{}\n".format(
        json.dumps(trust_policy),
        iam.Role('vmimport').assume_role_policy_document
    ))
else:
    response = iam.create_role(RoleName='vmimport', AssumeRolePolicyDocument=json.dumps(trust_policy))
    print(response)


# # TODO: Fix this stupid ARN hardcoding...
# arn = 'arn:aws:iam::240259995564:policy/vmimport'

if iam.RolePolicy('vmimport', 'vmimport') in iam.Role('vmimport').policies.all():
    print("Policy 'vmimport' already exists. Please check to see that it has the following role policy: \n{}\n{}\n".format(
        json.dumps(role_policy),
        iam.RolePolicy('vmimport', 'vmimport').policy_document
    ))
else:
    response = iam.Role('vmimport').Policy('vmimport').put(PolicyDocument=json.dumps(role_policy))
    print(response)

#
# for user_name in args.users:
#   user = iam.User(user_name)
#   user.attach_policy(PolicyArn=arn)
