#!/bin/bash
# Big Sur removed ability to run profiles from command line
# sudo /usr/bin/profiles -I -F U_Apple_OS_X_10-14_V1R1_STIG_Custom_PolicyNOBLUE.mobileconfig
# echo " Excuting U_Apple_OS_X_10-14_V1R1_STIG_Custom_PolicyNOBLUE.mobileconfig"
# sudo /usr/bin/profiles -I -F U_Apple_OS_X_10-14_V1R1_STIG_Login_Window_Policy.mobileconfig
# echo " Excuting U_Apple_OS_X_10-14_V1R1_STIG_Login_Window_Policy.mobileconfig"
# sudo /usr/bin/profiles -I -F U_Apple_OS_X_10-14_V1R1_STIG_Passcode_Policy.mobileconfig
# echo " Excuting U_Apple_OS_X_10-14_V1R1_STIG_Passcode_Policy.mobileconfig"
# sudo /usr/bin/profiles -I -F U_Apple_OS_X_10-14_V1R1_STIG_Restrictions_Policy.mobileconfig
# echo " Excuting U_Apple_OS_X_10-14_V1R1_STIG_Restrictions_Policy.mobileconfig"
sudo /bin/bash maccnaphardening.sh
echo "STIG Script CNAP executed"
