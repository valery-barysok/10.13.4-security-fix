#!/bin/bash
# 
# Small & hard fix for Mac OS X 10.13.x System ...
#

sudo clear;
pwd;

echo "NINJA: this script performs some system fixes for security";
echo "next steps allow you choose the way";

echo "";
# Advanced System fixes
echo "Display the file extensions in Finder.";
echo "Enable the expand save panel by default.";
echo "Make Crash Reporter appear as a notification.";

echo "All options: YES or NO"

echo "";
read Finder;
if [ "$Finder" == "YES" ]; then
 sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true;
 sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true;
 sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true;
 sudo defaults write com.apple.CrashReporter UseUNC 1;
fi

echo "";
echo "Show Library folder in Finder? YES \ NO";
read LIBFOLD;
if [ "$LIBFOLD" == "YES" ]; then
	chflags nohidden ~/Library;
fi

echo "";
# Packet filter
echo "Install hard full block policy with stealth? YES \ NO";
read PACKETFILTER;
if [ "$PACKETFILTER" == "YES" ]; then
 sudo mv /etc/pf.conf /etc/pf.conf.backup;
 sudo mv /etc/pf.os /etc/pf.os.backup;
 sudo cp -R pf.os /etc/pf.os;
 sudo cp -R pf.conf /etc/pf.conf;
 sudo chmod 644 /etc/pf.*;
 sudo chown 0:0 /etc/pf.*;
 sudo pfctl -d -f /etc/pf.conf -e;
 sudo pfctl -sa;
fi

echo "";
# Kernel config installer 10.12
echo "Setup sysctl config with more secure settings? YES \ NO";
read SYSCTL;
if [ "$SYSCTL" == "YES" ]; then
 sudo cp -R sysctl.conf /etc/sysctl.conf;
fi

echo "";
# Safari 
echo "Enable safari debug menu? YES \ NO";
read SAFARI;
if [ "$SAFARI" == "YES" ]; then
 killAll Safari;
 sudo defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25;
 sudo defaults write com.apple.Safari IncludeInternalDebugMenu 1;

 echo "Optionally you can disable AV Foundation in Debug Menu Safari and QT Kit";
 echo "it improves security";
fi

echo "";
# Switch off ARDa and Screen Sharing
echo "Disable remote event controls and screen sharing? YES \ NO";
read ARDASharing;
if [ "$ARDASharing" == "YES" ]; then
 sudo mkdir /System/Library/CoreServices/RemoteManagement/DisabledControls
 sudo mv /System/Library/CoreServices/RemoteManagement/*.bundle /System/Library/CoreServices/RemoteManagement/DisabledControls/; 
 sudo mv /System/Library/CoreServices/RemoteManagement/*.app /System/Library/CoreServices/RemoteManagement/DisabledControls/; 
fi

echo "";
# Remove trash files and spying software; reboot system.
echo "Remove trash files and spying software; reboot system? YES \ NO";
read CACHE;
if [ "$CACHE" == "YES" ]; then
 sudo rm -Rf /etc/mach_init_per_user.d/com.adobe*
 sudo rm -Rf /Library/LaunchDaemons/com.adobe*
 sudo rm -Rf /Library/LaunchAgents/com.adobe*
 sudo mv /System/Library/Extensions/AudioAUUC.kext ~/Desktop/;
 sudo rm -Rf /etc/com.apple.screen*;
 sudo rm -Rf /.DS_Store;
 sudo rm -Rf /.DocumentRevisions-V100;
 sudo rm -Rf /.IAProductInfo;
 sudo rm -Rf /.OSInstallMessages;
 sudo rm -Rf /.TALRestoreApps;
 sudo rm -Rf /.hotfiles.btree;
 sudo rm -Rf /.fseventsd;
 sudo rm -Rf /.com.apple.backupd.mvlist.plist;
 sudo rm -Rf /.PKInstallSandboxManager; 
 sudo rm -Rf /.Spotlight-V100; 
 sudo rm -Rf /.Trashes; 
 sudo rm -Rf /.file;
 sudo rm -Rf /.fseventsd; 
 sudo rm -Rf /.vol;
 sudo rm -Rf /.TemporaryItems;
 echo "Now run the maintenance scripts...";
 sudo periodic daily;
 sudo periodic weekly;
 sudo periodic monthly;
 echo "10 seconds to reboot;";
 sleep 10;
 sudo reboot;
fi
