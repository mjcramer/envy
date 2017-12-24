#!/bin/bash

country="US"
state="CA"
locality="San Francisco"
organization="Aris Vlasakakis"
unit="de"
host="aris.vlasakakis.com"
email="aris@vlasakakis.com"

csr="${host}.csr"
key="${host}.key"
cert="${host}.cert"

openssl genrsa -des3 -out aris.vlasakakis.com.key -passout "pass:password" 1024

openssl req -new -key aris.vlasakakis.com.key -passin "pass:password" -out aris.vlasakakis.com.csr -subj "/C=US/ST=CA/L=San Francisco/O=brainframe/CN=aris.vlasakakis.com"

mv aris.vlasakakis.com.key aris.vlasakakis.com.key.orig
openssl rsa -in aris.vlasakakis.com.key.orig -passin "pass:password" -out aris.vlasakakis.com.key

openssl x509 -req -days 365 -in aris.vlasakakis.com.csr -signkey aris.vlasakakis.com.key -out aris.vlasakakis.com.crt