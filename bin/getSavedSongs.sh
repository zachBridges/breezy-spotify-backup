#!/bin/bash
set -eou pipefail

curl -v \
    --url "https://api.spotify.com/v1/me/tracks" \
    --header "Authorization: Bearer ${SPOTIFY_ACCESS_TOKEN}"
