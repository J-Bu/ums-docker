#!/bin/bash

xpra start --daemon=no --start=/opt/IGEL/RemoteManager/rmclient/RemoteManager.bin --bind-tcp=0.0.0.0:10000
