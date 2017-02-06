#!/bin/bash
mkdir certremaintime
mkdir certremaintime/DEBIAN
mkdir certremaintime/Applications
cp control certremaintime/DEBIAN
cp -r .theos/obj/debug/CertRemainTime.app/ certremaintime/Applications
dpkg-deb -b certremaintime
rm -rf certremaintime
