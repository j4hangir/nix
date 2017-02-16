#!/usr/bin/env bash
lnchctl='<?xml version="1.0" encoding="UTF-8"?> <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"> <plist version="1.0"> <dict> <key>Label</key> <string>localhost.pbcopy</string> <key>ProgramArguments</key> <array> <string>/usr/bin/pbcopy</string> </array> <key>inetdCompatibility</key> <dict> <key>Wait</key> <false/> </dict> <key>Sockets</key> <dict> <key>Listeners</key> <dict> <key>SockServiceName</key> <string>2224</string> <key>SockNodeName</key> <string>127.0.0.1</string> </dict> </dict> </dict> </plist>'
echo $lnchctl > ~/Library/LaunchAgents/pbcopy.plist
launchctl load ~/Library/LaunchAgents/pbcopy.plist
echo RemoteForward 2224 127.0.0.1:2224 >> ~/.ssh/config

