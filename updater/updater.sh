#!/bin/bash

export jelastic_url=$1
export jelastic_token=$2
export jelastic_envName=$3
export tc_access_token=$4
export tc_artifact_url=$5
export check_state_uri=$6
export app_context=$7

#set env name
echo "Set Access token as [$tc_access_token]"
sed -i "s|^.*tc_access_token.*|\"tc_access_token\":\"$tc_access_token\",|g" updater/settings.json

#set env name
echo "Set Artifact URL as [$tc_artifact_url]"
sed -i "s|^.*tc_artifact_url.*|\"tc_artifact_url\":\"$tc_artifact_url\",|g" updater/settings.json

#set env name
echo "Set Check State URI as [$check_state_uri]"
sed -i "s|^.*check_state_uri.*|\"check_state_uri\":\"$check_state_uri\",|g" updater/settings.json

echo "Set Application context as [$app_context]"
sed -i "s|^.*app_context.*|\"app_context\":\"$app_context\"|g" updater/settings.json

#show full reponse
printf "\nParameters: \n\n"
cat updater/settings.json

#add slash if not exists
case "$jelastic_url" in
*/)
    echo "Already has slash"
    ;;
*)
    echo "Adding slash"
    jelastic_url="$jelastic_url/"
    ;;
esac

curl --data-urlencode jps@updater/zdt.yaml \
     -d "envName=$jelastic_envName" \
     --data-urlencode settings@updater/settings.json \
     -d "session=$jelastic_token" \
        "${jelastic_url}JElastic/marketplace/jps/rest/install" \
         > updater/result.json

printf "\nResponse: \n\n"
cat updater/result.json
#get result from JSON
cat updater/result.json | grep '"result":0'
