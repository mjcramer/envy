#!/bin/bash

private_key=$1

#openssl req -new -x509 -nodes -sha256 -days 365 -key $private_key -outform PEM -subj "/C=US/ST=CA/L=San Francisco/O=Imgur/OU=Discovery/CN=imgur.com/emailAddress=info@imgur.com" > $private_key.pem
openssl req -new -x509 -nodes -sha256 -days 365 -key $private_key -outform PEM > $private_key.pem

