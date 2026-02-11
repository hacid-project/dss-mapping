#!/usr/bin/env bash

DOWNLOAD_DIR=data/download

curl -X 'GET' \
    'https://hacid-backend.istc.cnr.it/hacid-dss-api/api/v1/users/' \
    -H 'accept: application/json' | jq 'map(.type = "User")' >$DOWNLOAD_DIR/users.json

curl -X 'GET' \
    'https://hacid-backend.istc.cnr.it/hacid-dss-api/api/v1/cases/?page=1&page_size=100&temp=false' \
    -H 'accept: application/json' | jq '.items | map(.type = "Case")' >$DOWNLOAD_DIR/cases.json

curl -X 'GET' \
    'https://hacid-backend.istc.cnr.it/hacid-dss-api/api/v1/contributions/?page=1&page_size=100' \
    -H 'accept: application/json' | jq '.items | map(.type = "Contribution")' >$DOWNLOAD_DIR/contributions.json

for CONTRIBUTION_ID in `jq '.[].id' <$DOWNLOAD_DIR/contributions.json`; do
#    echo $CONTRIBUTION_ID
    curl -X 'GET' \
        "https://hacid-backend.istc.cnr.it/hacid-dss-api/api/v1/contributions/$CONTRIBUTION_ID/ratings" \
        -H 'accept: application/json' | jq '.[]' --compact-output
done | jq --slurp 'map(.type = "Rating")' >$DOWNLOAD_DIR/ratings.json