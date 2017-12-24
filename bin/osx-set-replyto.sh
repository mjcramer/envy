#!/bin/bash

# First, read in the user headers, in case there's something already there...

user_headers=$(defaults read com.apple.mail UserHeaders)

echo $user_headers

# defaults write com.apple.mail UserHeaders '{"Reply-To" = "michael@cramer.name";}'


