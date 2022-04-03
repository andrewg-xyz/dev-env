#!/bin/bash

brew install clamav
# Create usable config file based on sample
sed 's/^Example$/# Example/' /usr/local/etc/clamav/freshclam.conf.sample > /usr/local/etc/clamav/freshclam.conf
# Fetch virus definitions
freshclam -v

#To run a scan on your system include the command, arguments, and the scan path:

#$ clamscan -r --bell -i /User/shortname
#args:
#-r = look recurisvly through directories
#--bell = play bell sound if a virus is detected
#-i = only print viruses detected