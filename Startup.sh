#!/bin/bash

npm install font-awesome-filetypes marked
sleep 1
npm audit fix --force
sleep 1
npm install font-awesome-filetypes marked

rm startup.sh

read -p "Do you want to auto-publish? [Y/n] " pub
if [[ $pub != 'n' && $pub != 'N' ]]
then
  wrangler publish
fi
