 #!/bin/bash

if [ -z "$1" ]; then
	repo=$(basename $(pwd -P))
else
	repo=$1
fi

git init
git add *
git commit -m "initial commit"
git remote add origin git@github.com:mjcramer/$repo.git
git push -u origin master

