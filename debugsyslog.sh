#!/bin/bash
echo "Type \"watch\" as soon as it says that ASL is here for you"
socat - UNIX-CONNECT:/var/run/lockdown/syslog.sock
