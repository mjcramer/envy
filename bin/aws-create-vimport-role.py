#!/usr/bin/env python3

import argparse
import boto3
import json

parser = argparse.ArgumentParser()
parser.add_argument("bucket", nargs='?', help="The name of the S3 bucket to create.")
args = parser.parse_args()

if args.bucket:
    bucket = args.bucket
else:
    bucket = input("Please enter the name of the S3 bucket to create: ")

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
                "arn:aws:s3:::{}".format(bucket)
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::{}/*".format(bucket)
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

if s3.Bucket(bucket) in s3.buckets.all():
    print("Bucket {} already exists, no need to create...".format(bucket))
else:
    response = s3.create_bucket(Bucket=bucket, CreateBucketConfiguration={'LocationConstraint': 'us-west-1'})

iam = boto3.resource('iam')

if iam.Role('vmimport') in iam.roles.all():
    print("Role 'vmimport' already exists. Please check to see that it has the following trust policy: \n{}".format(
        json.dumps(trust_policy)
    ))
else:
    response = iam.create_role(RoleName='vmimport', AssumeRolePolicyDocument=json.dumps(trust_policy))
    print(response)

# TODO: Fix this stupid ARN hardcoding...
arn = 'arn:aws:iam::240259995564:policy/vmimport'
if iam.Policy(arn) in iam.policies.all():
    print("Policy 'vmimport' already exists. Please check to see that it has the following role policy: \n{}".format(
        json.dumps(role_policy)
    ))
else:
    response = iam.create_policy(PolicyName='vmimport', PolicyDocument=json.dumps(role_policy))
    print(response)

response = iam.Role('vmimport').attach_policy(PolicyArn=arn)
