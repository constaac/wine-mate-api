#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
KEY="35639fb3681d618d948db560367e4cad"
URL_PATH="/examples"
curl "http://services.wine.com/api/beta2/service.svc/JSON/catalog?search=prisoner+cab&size=20&apikey=${KEY}" \
  --include \
  --request GET \

echo
