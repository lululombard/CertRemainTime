# CertRemainTime by lululombard

![Logo](https://raw.githubusercontent.com/lululombard/CertRemainTime/master/Resources/Icon%402x.png)

This tool tells you when your yalu102/mach portal/Home Depot will expire.

It only works if you installed it with Cydia Impactor.

# Installation

This package is available from the default source BigBoss.

Early updates are available from my repo at [http://apt.lululombard.fr](http://apt.lululombard.fr/) but you can also download the .deb from this 
GitHub repo.

# What's next

Badge on the app with the number of days remaining

Notifications 24h, 12h, 6h and 1h before expiration

# Screenshots

![App running on 3 devices](http://up.kingdomhills.fr/24933353979379759)

# Debuging

As I do not use XCode (I only have a PC), the debuging procedure is a bit tricky.

Install "socat" (SOcket CAT) from Cydia.

Connect via SSH to your device

Type `socat - UNIX-CONNECT:/var/run/lockdown/syslog.sock` then type "watch" when you see "ASL is here to serve you"

Wait for the syslog to update to the right time

Launch CertRemainTime, and see what happens.

If it crashes, make a screenshot and send it to me, I'll fix it ASAP.

A successful launch will look like this :

![Debug](http://up.kingdomhills.fr/24933353979379760)

You can remove socat from your device after this operation.

# Contributors

DaniWinter for the mach portal compatibility and the uicache (thanks to razer86 too for the mach portal string)

Fields for the Home Depot cert that allowed me to add the compatibility with this tool.

HunterStanton (he added the licence that forgot at 2 AM)

windexi and Animus120 for their certs (buggy if one of them didn't have the ExpirationDate key)

# More info

This package is also licensed under WTFPL.

Compiled with LLVM+Clang on an iPhone 5s running iOS 10.2.

The icon is not really mine but it was licenced under WTFPL so no big deal.

I appologize if my english is so bad that what I write does not makes sense.
