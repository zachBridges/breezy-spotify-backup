#!/bin/bash
set -eou pipefail

# Verifier is saved, never sent over the wire
CODE_VERIFIER=$(openssl rand -base64 96 | tr -d '\n' | tr '+/' '-_' | tr -d '=')
echo "CODE_VERIFIER IS ${CODE_VERIFIER}" 
# Challenge is sent over the wire
CODE_CHALLENGE=$(printf '%s' "$CODE_VERIFIER" \
  | openssl dgst -sha256 -binary \
  | openssl base64 -A \
  | tr '+/' '-_' \
  | tr -d '=')
echo "$CODE_VERIFIER" > code_verifier.txt

open "https://accounts.spotify.com/authorize?client_id=${SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=${SPOTIFY_REDIRECT_URI}&code_challenge=${CODE_CHALLENGE}&code_challenge_method=S256&scope=playlist-read-private playlist-read-collaborative user-library-read"

echo "Paste the authorization code and press Enter:"
read -r AUTH_CODE
echo "AUTH_CODE is ${AUTH_CODE}"
printf '\n\n'

export SPOTIFY_ACCESS_TOKEN="$(curl -s -X POST https://accounts.spotify.com/api/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${SPOTIFY_CLIENT_ID}" \
  -d "grant_type=authorization_code" \
  -d "code=$AUTH_CODE" \
  -d "redirect_uri=${SPOTIFY_REDIRECT_URI}" \
  -d "code_verifier=$CODE_VERIFIER" | jq '.accessToken' )"
# TODO refresh token