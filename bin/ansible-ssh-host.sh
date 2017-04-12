#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please specify the host."
    exit 1
fi

host=$(ansible --module-name=debug --args="msg={{ansible_host}}" --one-line $1 | sed -n 's/.* => \(.*\)/\1/p' | jq --raw-output .msg)
user=$(ansible --module-name=debug --args="msg={{ansible_user}}" --one-line $1 | sed -n 's/.* => \(.*\)/\1/p' | jq --raw-output .msg)
key=$(ansible --module-name=debug --args="msg={{ansible_ssh_private_key}}" --one-line $1 | sed -n 's/.* => \(.*\)/\1/p' | jq --raw-output .msg)

if [ -n "$key" ]; then
    ssh_opts="-i $key"
fi

exec ssh $ssh_opts $user@$host
