#!/bin/bash

#v95377
/usr/bin/sudo /bin/launchctl enable system/com.openssh.sshd

#v95393
#/usr/bin/sudo /usr/bin/pwpolicy setaccountpolicies pwpolicy.plist

#v95407
/usr/bin/sudo /usr/bin/sed -i.bak 's/^[\#]*MaxSessions.*/MaxSessions 10/' /etc/ssh/sshd_config

#v95541
#echo '/usr/bin/sudo /usr/bin/security authorizationdb read system.preferences > ~/Desktop/authdb.txt'
#echo 'edit the file to change:'
#echo '<key>shared</key>'
#echo '<true/>'
#echo 'To read:'
#echo '<key>shared</key>'
#echo '<false/>'
#echo ''
#echo 'Reload the authorization database with the following command:'
#echo '/usr/bin/sudo /usr/bin/security authorizationdb write system.preferences < ~/Desktop/authdb.txt'#

#v95597

#v95789
#echo Enable screensaver system lock using the "Login Window Policy" configuration profile.

#v95797
#echo A screensaver can be enabled using the "Login Window Policy" configuration profile.

#v95807

#v95815
#/usr/bin/sudo /usr/bin/pwpolicy setaccountpolicies pwpolicy.plist

#v95817
#banner
sudo echo "You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.
By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, the USG may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and # their assistants. Such communications and work product are private and confidential. See User Agreement for details.
" | tee /etc/banner

#v95819
sudo sed -i '' 's/Banner none/Banner \/etc\/banner/' /etc/ssh/sshd_config

#v95823
#/usr/bin/sudo chmod -N [audit log file]"

#v95827
/usr/bin/sudo /usr/bin/sed -i.bak 's/.*ClientAliveInterval.*/ClientAliveInterval 900/' /etc/ssh/sshd_config

#v95851
#/usr/bin/sudo chmod 700 [audit log folder]"

#v95833
/usr/bin/sudo /usr/bin/sed -i.bak '/^flags/ s/$/,ad/' /etc/security/audit_control; /usr/bin/sudo /usr/sbin/audit -s

#v95837
/usr/bin/sudo /bin/launchctl enable system/com.apple.auditd

#v95853
/usr/bin/sudo /usr/bin/sed -i.bak '/^flags/ s/$/,fm,-fr,-fw/' /etc/security/audit_control; /usr/bin/sudo /usr/sbin/audit -s

#v95839
sudo /usr/bin/sed -i.bak '/^policy/ s/$/,ahlt/' /etc/security/audit_control; sudo /usr/sbin/audit -s

#v95859
/usr/bin/sudo /usr/bin/sed -i.bak '/^flags/ s/$/,aa/' /etc/security/audit_control; /usr/bin/sudo /usr/sbin/audit -s

#v95861
#echo "This setting is enforced using the "Smart Card Policy" configuration profile.

#v95863
/usr/bin/sudo /usr/bin/sed -i.bak 's/^[\#]*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

#v95865
/usr/bin/sudo /bin/launchctl disable system/com.apple.smbd

#v95927
/usr/bin/sudo /bin/launchctl disable system/com.apple.tftpd

#v95965
#echo "Change your password lifetime restriction to 60 days or less using the 'Passcode Policy' configuration profile."
#/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep maxPINAgeInDays

#v95967
#echo "Configure password re-use to be prohibited for at least five generations using the 'Passcode Policy' configuration profile."
#/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep pinHistory

#v95969
#echo "Configure password length to be 15 chars minimum using the 'Passcode Policy' configuration profile."
#/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep minLength

#v95971
#echo "Configure password to require at least one special char using the 'Passcode Policy' configuration profile."
#/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep minComplexChars

#v95995
#echo "To reenable "System Integrity Protection", boot the affected system into "Recovery" mode, launch "Terminal" from the "Utilities" menu, and run the following command:
#/usr/bin/csrutil enable"

#v95997
#/usr/bin/sudo /usr/bin/fdesetup enable

