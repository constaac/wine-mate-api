#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists"
curl "${API}${URL_PATH}" \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "wish_list": {
      "name": "'${NAME}'",
      "winery": "'${WINERY}'"
    }
  }'

echo
