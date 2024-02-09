#!/bin/bash

sed -i "s/host: 'localhost',/host: '0.0.0.0',/g" packages/compositor-shell/vite.config.mts
cat << EOF > packages/compositor-proxy-cli/package/applications.json
{
  "/console": {
    "name": "UMS console",
    "executable": "/opt/IGEL/RemoteManager/rmclient/RemoteManager.bin",
    "args": [],
    "env": {}
  }
}
EOF

mkdir -p /tmp/.X11-unix/
export XDG_RUNTIME_DIR=/var/run/compositor-proxy
export XAUTHORITY=${HOME}/.Xauthority
rm -f "${HOME}/.Xauthority"
touch "${HOME}/.Xauthority"
xauth add "${HOST}":1 . "$(xxd -l 16 -p /dev/urandom)"

export LOG_LEVEL=debug

yarn workspace @gfld/compositor-shell run start &
./packages/compositor-proxy-cli/package/compositor-proxy-cli --applications="./packages/compositor-proxy-cli/package/applications.json"
