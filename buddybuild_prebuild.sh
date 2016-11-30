#!/usr/bin/env bash

# Add the values from Environment variables to info.plist 
# When CI is run secure values are replaced i.e token, keys, secret etc...
/usr/libexec/PlistBuddy -c "Set Nexmo:Verify_Phone_Number $Verify_Phone_Number" "NexmoVerifyTests/Info.plist"
/usr/libexec/PlistBuddy -c "Set Nexmo:Verify_Application_Id $Verify_Application_Id" "NexmoVerifyTests/Info.plist"
/usr/libexec/PlistBuddy -c "Set Nexmo:Verify_Application_Secret $Verify_Application_Secret" "NexmoVerifyTests/Info.plist"
