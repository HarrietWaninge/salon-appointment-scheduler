#!/bin/bash
#pg_dump -cC --inserts -U freecodecamp salon > salon.sql

yes | sudo apt-get install rsync
rsync -a --exclude={'.*','salongit'} ./ ./salongit

cd salongit
git add .
git commit -m "$(date)"
git push -u origin main