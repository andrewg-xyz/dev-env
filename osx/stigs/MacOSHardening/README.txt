#### This script will allow you to pass CNAP requirement.  This does not Harden the OS.################
#### USE AT YOUR OWN RISK #################

Execute macoshardening.sh script

Execute brew_clamav_install.sh script to install antivirus.  Brew was installed on SpaceCamp Mac Mini.  If Brew is not install on your Mac install it first by executing below command.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 

Execute CNAP device script to see result.  

/User/$username/.appgate/scripts/combined_macOS_Scripts.sh

Some STIG check, like v95541, may require manual configuration steps to pass.
To ensure that authentication is required to access all system level preference panes use the following procedure:
Copy the authorization database to a file using the following command:
/usr/bin/sudo /usr/bin/security authorizationdb read system.preferences > ~/Desktop/authdb.txt
edit the file to change:
<key>shared</key>
<true/>
To read:
<key>shared</key>
<false/>

Reload the authorization database with the following command:
/usr/bin/sudo /usr/bin/security authorizationdb write system.preferences < ~/Desktop/authdb.txt

Another manual step is enabling FileVault v95997. 
Open System Preferences >> Security and Privacy and navigate to the "FileVault" tab. Use this panel to configure full-disk encryption.

Please note that Restriciton_Policy.mobileconfig will enable your camera.  To disalble camera set to allowCamera key in the file to flase 
<key>allowCamera</key>
<false/>