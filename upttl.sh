#!/bin/bash
[ "$UID" -eq 0 ] || exec gksu bash "$0" "$@"
sysctl -w net.ipv4.ip_default_ttl=128
