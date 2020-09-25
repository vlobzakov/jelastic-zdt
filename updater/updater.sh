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
sed -i "s|^.*app_context.*|\"app_context\":\"$app_context\",|g" updater/settings.json

#show full reponse
printf "\nParameters: \n\n"
cat updater/settings.json


curl -F "jps=<updater/zdt.yaml" \
     -F "envName=$jelastic_envName" \
     -F "settings=<updater/settings.json" \
     -F "token=$jelastic_token" \
        "$jelastic_url/JElastic/marketplace/jps/rest/install" \
        > updater/result.json

printf "\nResponse: \n\n"
cat updater/result.json
#get result from JSON
res=$(cat updater/result.json | jq -r '.response.response.result')
if [[ -z "$res" ]]; then
    res=$(cat result.json | jq -r '.response.result')
fi
#return bad result in case of error from API
if [[ "$res" -ne "0" ]]; then
    exit 255;
fi

exit 0;