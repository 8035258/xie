#!/bin/bash

cd /usr/local/shadowsocks

# Start ShadowSocks
env | grep '^SHADOWSOCKS_CFGS_' | awk -F '=' '{print $1;}' | while read T_NAME; do
	SS_NAME="${T_NAME:17}"
	echo "${!T_NAME}" > /etc/shadowsocks/${SS_NAME}.json
	python3 server.py -c /etc/shadowsocks/${SS_NAME}.json -d start
done
