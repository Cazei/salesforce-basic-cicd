#!/usr/bin/env bash
export LANG=C.UTF-8
echo "I solemnly swear that I will not echo passwords to the console"
echo "sf.serverurl = ${SF_SERVER_URL}" > build.properties
echo "sf.username = ${SF_USERNAME}" >> build.properties
echo "sf.password = ${SF_PASSWORD}${SF_SEC_TOKEN}" >> build.properties
echo "sf.proxyhost = ${PROXY_HOST}" >> build.properties
echo "sf.proxyport = ${PROXY_PORT}" >> build.properties

cd metadata-backup

# Retrieve metadata
ant retrieveUnpackaged

if [ ! -d "src" ]
then
  echo "Failed to download src from Salesforce, exiting..."
  exit 1
fi


echo "Metadata retrieved!"