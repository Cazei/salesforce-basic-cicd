
#!/usr/bin/env bash

export LANG=C.UTF-8

cd metadata-backup
sfdx force:mdapi:convert --rootdir src -d ../force-app

cd ..
find . -name "*.dup" -delete

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME

cd metadata-backup

git clone https://$GIT_ACCESSTOKEN@$GIT_REPO_URL repository
rm -rf repository/force-app
cp -r ../force-app repository/


cd repository
# Removing cleanDataServices since its XML is updated on each run, resulting in branch being updated on each run.
rm -rf force-app/main/default/cleanDataServices
git add force-app/* --all 
export TIMESTAMP=`date +"%Y-%m-%dT%H:%M:%SZ"`
echo `git commit -m "$TIMESTAMP"`
git commit -m "$TIMESTAMP"
git push -u origin main || true

rm -rf force-app
rm -rf src
rm -rf tmp
echo "We're all done here!"