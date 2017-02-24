#!/bin/bash

country="US"
state="CA"
locality="San Francisco"
organization="Michael Cramer"
unit="de"
host="michael.cramer.name"
email="michael@cramer.name"

csr="${host}.csr"
key="${host}.key"
cert="${host}.cert"

openssl genrsa -des3 -out michael.cramer.name.key -passout "pass:password" 1024

openssl req -new -key michael.cramer.name.key -passin "pass:password" -out michael.cramer.name.csr -subj "/C=US/ST=CA/L=San Francisco/O=brainframe/CN=michael.cramer.name"

mv michael.cramer.name.key michael.cramer.name.key.orig
openssl rsa -in michael.cramer.name.key.orig -passin "pass:password" -out michael.cramer.name.key

openssl x509 -req -days 365 -in michael.cramer.name.csr -signkey michael.cramer.name.key -out michael.cramer.name.crt