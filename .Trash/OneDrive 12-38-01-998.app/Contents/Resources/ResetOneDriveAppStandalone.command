#!/bin/bash

# This script cleans OneDrive standalone app states
GroupContainer=~/Library/Group\ Containers/UBF8T346G9.OneDriveStandaloneSuite
SupportFolder=~/Library/Application\ Support/OneDrive
LogFolder=~/Library/Logs/OneDrive
ExtensionBundleId=com.microsoft.OneDrive.FileProvider
TempFilePath=~/.fpdomains.txt
TempFilePathFiltered=~/.fpdomainsfiltered.txt
DocumentsFolder=~/Documents
DesktopFolder=~/Desktop
PicturesFolder=~/Pictures

echo killing OneDrive
killall OneDrive

if [ -d "$GroupContainer" ]; then
    echo removing GroupContainer: $GroupContainer
    rm -rf "$GroupContainer"
fi

if [ -d "$SupportFolder" ]; then
    echo removing $SupportFolder
    rm -rf "$SupportFolder"
fi

if [ -d "$LogFolder" ]; then
    echo removing $LogFolder
    rm -rf "$LogFolder"
fi

for KNOWNFOLDER in $DocumentsFolder $DesktopFolder $PicturesFolder
do
    echo Checking $KNOWNFOLDER
    if [ -h "$KNOWNFOLDER" ]; then
        # Check if the symlink has our expected xattr
        XATTR=`xattr -s $KNOWNFOLDER`
        if [[ "$XATTR" == *"com.microsoft.OneDrive.KnownFolderVolFs"* ]]; then
            echo Deleting Known Folder symlink at $KNOWNFOLDER
            rm -f "$KNOWNFOLDER"
            if [ $? -ne 0 ]; then
                echo Failed to delete Known Folder symlink at $KNOWNFOLDER. Grant Terminal.app with Full Disk Access, and try again.
                exit $?;
            else
                mkdir "$KNOWNFOLDER"
            fi
        fi
    fi
done

echo Getting all File Provider domains belonging to $ExtensionBundleId
fileproviderctl domain list &> $TempFilePath
cat $TempFilePath | grep $ExtensionBundleId > $TempFilePathFiltered

echo Archiving domains
cat $TempFilePathFiltered | while read line
do
    echo Archiving $line
    fileproviderctl domain remove -A $line
done

rm $TempFilePath
rm $TempFilePathFiltered
echo Done archiving domains

echo removing defaults
rm -f ~/Library/Preferences/com.microsoft.OneDrive.plist
rm -f ~/Library/Preferences/com.microsoft.OneDriveUpdater.plist
rm -f ~/Library/Preferences/com.microsoft.OneDriveStandaloneUpdater.plist

echo killing cfprefsd
killall cfprefsd

echo waiting for cfprefsd
defaults read NSGlobalDomain > /dev/null

echo disabling Finder Extension
/usr/bin/pluginkit -e ignore -i com.microsoft.OneDrive.FinderSync
echo stopping Finder Extension
killall FinderSync

PASSWORD_MATCH="Used to identify you when you start up OneDrive Standalone."
security find-generic-password -j "$PASSWORD_MATCH" &> /dev/null
while [ $? -eq 0 ]; do
    security delete-generic-password -j "$PASSWORD_MATCH"
    if [ $? -ne 0 ]; then
       echo Failed to clear cached credentials for business
    fi
    security find-generic-password -j "$PASSWORD_MATCH" &> /dev/null
done

PASSWORD_MATCH="Used to identify you when you start up OneDrive Standalone for business."
security find-generic-password -j "$PASSWORD_MATCH" &> /dev/null
while [ $? -eq 0 ]; do
    security delete-generic-password -j "$PASSWORD_MATCH"
    if [ $? -ne 0 ]; then
       echo Failed to clear cached credentials for business
    fi
    security find-generic-password -j "$PASSWORD_MATCH" &> /dev/null
done

PASSWORD_MATCH="com.microsoft.OneDrive.HockeySDK"
security find-generic-password -l "$PASSWORD_MATCH" &> /dev/null
if [ $? -eq 0 ]; then
    security delete-generic-password -l "$PASSWORD_MATCH"
    if [ $? -ne 0 ]; then
       echo Failed to clear OneDrive main App HockeySDK password credential
    fi
fi

PASSWORD_MATCH="com.microsoft.OneDrive.FinderSync.HockeySDK"
security find-generic-password -l "$PASSWORD_MATCH" &> /dev/null
if [ $? -eq 0 ]; then
    security delete-generic-password -l "$PASSWORD_MATCH"
    if [ $? -ne 0 ]; then
       echo Failed to clear OneDrive FinderSync HockeySDK credential
    fi
fi

PASSWORD_MATCH="com.microsoft.OneDriveUpdater.HockeySDK"
security find-generic-password -l "$PASSWORD_MATCH" &> /dev/null
if [ $? -eq 0 ]; then
    security delete-generic-password -l "$PASSWORD_MATCH"
    if [ $? -ne 0 ]; then
       echo Failed to clear OneDriveUpdater HockeySDK credential
    fi
fi
