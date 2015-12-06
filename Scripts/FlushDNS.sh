#!/bin/sh
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
exit
fi
alias flushdns="curl -Ls 'https://raw.githubusercontent.com/OwlReporter/OwlMac/master/Scripts/FlushDNS.sh' | sudo sh"
Version=$(defaults read /System/Library/CoreServices/SystemVersion ProductVersion | sed 's/\.//g')
if [ $Version -gt 10104 ]; then
sudo killall -HUP mDNSResponder
echo "Flushed DNS Cache Successfully" 
elif [ $Version -lt 10104 && $Version -ge 10100 ]; then
sudo discoveryutil mdnsflushcache
echo "Flushed DNS Cache Successfully" 
elif [ $Version -lt 10100 && $Version -ge 10700 ]; then
sudo killall -HUP mDNSResponder
echo "Flushed DNS Cache Successfully" 
elif [ $Version -ge 10600 && $Version -lt 10700 ]; then
sudo dscacheutil -flushcache
echo "Flushed DNS Cache Successfully" 
fi

# Gives Suggestion to switch to Google Public DNS
if [ $(whereis scutil) = /usr/sbin/scutil ]; then
scutil --dns | grep -m 2 'nameserver\[[0-9]*\]'  | awk '{ print  $3 }' |  while read -r line ; do DNS=$(( $DNS + 1 )); if [ $DNS == 1 ]; then  echo "Primary DNS: " $line; elif [ $DNS == 2 ]; then echo "Secondary DNS: " $line; fi; done
if  [ $(scutil --dns | grep -m 1 'nameserver\[[0-9]*\]'  | awk '{ print  $3 }') = 192.168.1.1 ]; then echo "Swiching to Google Public DNS will speed up your internet"; echo "for more information visit: j.mp/changemydns"; fi
fi