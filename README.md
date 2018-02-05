# CertRemainTime by lululombard

![Logo](https://raw.githubusercontent.com/lululombard/CertRemainTime/master/Resources/Icon%402x.png)

This tool tells you when your yalu102/pangu/mach portal/Home Depot/phoenix/g0blin/H3lix/Electra/LiberiOS will expire.

It only works if you installed it with Cydia Impactor.

# Installation

This package is available from the default source BigBoss.

# What's next

Badge on the app with the number of days remaining

Notifications 24h, 12h, 6h and 1h before expiration

# Screenshots

![App running on 3 devices](http://up.kingdomhills.fr/24933353979379759)
![App running on Electra jailbreak](https://i.imgur.com/Xk4NbDn.png)

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

*Zygimantass for a -practically- full rewrite of the code*

heilgutz for his extra receipe certificate

DaniWinter for the mach portal compatibility and the uicache (thanks to razer86 too for the mach portal string)

Fields for the Home Depot cert that allowed me to add the compatibility with this tool.

HunterStanton (he added the licence that forgot at 2 AM)

windexi and Animus120 for their certs (buggy if one of them didn't have the ExpirationDate key)

Slouther for his crash report that helped me to find the AM/PM bug

FaZeIlLuMiNaTi for adding support for Saigon, g0blin, H3lix, Electra and LiberiOS

# More info

This package is also licensed under WTFPL.

Compiled with theos on macOS against the iOS 9.2 SDK.

The icon is not really mine but it was licenced under WTFPL so no big deal.

I appologize if my english is so bad that what I write does not makes sense.
