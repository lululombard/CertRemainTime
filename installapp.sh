#!/bin/bash
make
killall -9 CertRemainTime
rm -rf /Applications/CertRemainTime.app/
cp -r .theos/obj/debug/CertRemainTime.app/ /Applications/
open fr.lululombard.certremaintime
#socat - UNIX-CONNECT:/var/run/lockdown/syslog.sock | grep CertRemainTime
