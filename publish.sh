#!/bin/bash

# Custom sculpin publishing file
# Mark Railton - marksrailton@gmail.com

if (( $# != 1 ))
then
  echo "You must enter a commit message as an argument"
  exit 1
fi

sculpin generate --env=prod
if [ $? -ne 0 ]; then echo "Could not generate the site"; exit 1; fi

# Publish live site to GitHub Pages
cd output_prod
git add .
git commit -am "$1"
git push github-pages master

# Push entire project to main GitHub repo
cd ../
git add .
git commit -am "$1"
git push origin master

if [ $? -ne 0 ]; then echo "Could not publish the site"; exit 1; fi

echo "";
echo "Site successfully generated, published to GitHub pages and project pushed to GitHub"; 
echo "";
exit 0;