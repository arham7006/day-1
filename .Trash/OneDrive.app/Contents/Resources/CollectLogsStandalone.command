#!/bin/bash

# Collect any diagnostic report in a case of crash
echo
echo "Collect a diagnostic report..."
latest_diagreport=`ls -t ~/Library/Logs/DiagnosticReports/OneDrive* 2>/dev/null | head -1`
if [ "$latest_diagreport" != "" ]; then
    if [[ "`grep 'OneDrive \[' $latest_diagreport`" =~ [0-9]+ ]]; then
        latest_core=/cores/core."${BASH_REMATCH[0]}"
    fi
fi

# Collect defaults setting information
echo "Getting current setting information of OneDrive..."
log_path=~/Library/Logs/OneDrive
settings_path=~/Library/Application\ Support/OneDrive
settings_output=${log_path}/OneDrive_Settings.log

echo "com.microsoft.OneDrive settings:" > $settings_output
defaults read com.microsoft.OneDrive >> $settings_output

echo -e "\nUBF8T346G9.OneDriveStandaloneSuite settings:" >> $settings_output
/usr/libexec/PlistBuddy -c "Print" ~/Library/Group\ Containers/UBF8T346G9.OneDriveStandaloneSuite/Library/Preferences/UBF8T346G9.OneDriveStandaloneSuite.plist >> $settings_output

if [ -a ~/Library/Group\ Containers/sync.com.microsoft.OneDrive-mac/Library/Preferences/sync.com.microsoft.OneDrive-mac.plist ]; then
    echo -e "\nsync.com.microsoft.OneDrive-mac settings:" >> $settings_output
    /usr/libexec/PlistBuddy -c "Print" ~/Library/Group\ Containers/sync.com.microsoft.OneDrive-mac/Library/Preferences/sync.com.microsoft.OneDrive-mac.plist >> $settings_output
fi

if [ -a ~/Library/Group\ Containers/UBF8T346G9.OfficeOneDriveSyncIntegration/Library/Preferences/UBF8T346G9.OfficeOneDriveSyncIntegration.plist ]; then
    echo -e "\nUBF8T346G9.OfficeOneDriveSyncIntegration settings:" >> $settings_output
    /usr/libexec/PlistBuddy -c "Print" ~/Library/Group\ Containers/UBF8T346G9.OfficeOneDriveSyncIntegration/Library/Preferences/UBF8T346G9.OfficeOneDriveSyncIntegration.plist >> $settings_output
fi

echo -e "\nLaunch service list:" >> $settings_output
launchctl list >> $settings_output

echo "Creating logs package..."
package_name=~/Desktop/OneDriveLogs_`date "+%Y%m%d_%H%M"`.zip
zip -Dqr $package_name $log_path "$settings_path" $latest_core $latest_diagreport

if [ 0 != $? ]; then
    echo "ERROR while collecting the OneDrive logs"
exit 1
fi

# Remove temporarily created settings file
rm -f $settings_output

echo $package_name created on your Desktop!
echo
