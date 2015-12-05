#!/bin/sh

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