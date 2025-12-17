#!/bin/bash
set -eou pipefail
export SPOTIFY_API_TOKEN="$(curl -s -X POST "https://accounts.spotify.com/api/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "grant_type=client_credentials&client_id=${SPOTIFY_CLIENT_ID}&client_secret=${SPOTIFY_CLIENT_SECRET}" \
     | jq -r '.access_token')"
