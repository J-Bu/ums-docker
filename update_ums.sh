#!/bin/bash

set -e

cp "$1" "ums-server-data/"
chmod +x "ums-server-data/$(basename "$1")" 
cp "ums-docker/unintended_ums_update.sh" "ums-server-data/unintended_ums_update.sh"

docker exec -ti ums-ums-server-1 "/opt/IGEL/unintended_ums_update.sh" "/opt/IGEL/$(basename "$1")"
docker container commit ums-ums-server-1 ums-ums-server:latest

rm "ums-server-data/$(basename "$1")"
rm "ums-server-data/unintended_ums_update.sh"

cp "$1" "ums-client-data/"
chmod +x "ums-client-data/$(basename "$1")" 
cp "ums-docker/unintended_ums_update.sh" "ums-client-data/unintended_ums_update.sh"

docker exec -ti ums-ums-client-1 "/root/.java/unintended_ums_update.sh" "/root/.java/$(basename "$1")"
docker container commit ums-ums-client-1 ums-ums-client:latest

rm "ums-client-data/$(basename "$1")"
rm "ums-client-data/unintended_ums_update.sh"

docker compose down
docker compose up -d
