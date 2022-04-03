#!/bin/bash

usage() {
  # this function prints a usage summary, optionally printing an error message
  local ec=0

  if [ $# -ge 2 ] ; then
    # if printing an error message, the first arg is the exit code, and
    # all remaining args are the message.
    ec="$1" ; shift
    printf "%s\n\n" "$*" >&2
  fi

  cat <<EOF
Usage:
       $(basename $0) [-t threshold | -d disabled checks ]

Runs a series of STIG checks and will report a pass or fail depending on the threshold set. Threshold defaults to 80

Options:

  -t threshold             Pass percentage represented as a whole number. Defaults to 80
  -d disabled checks       Comma separated list of STIG checks to disable. Example "v95377,v95393"

  -h                       This help message.
EOF

  exit $ec
}

# Init variables
threshold='80'
disabled_checks=''

while getopts ':t:d:h' opt; do
  case "$opt" in 
    t) threshold="$OPTARG" ;;
    d) disabled_checks="$OPTARG" ;;
    h) usage 1 ;;
    :) usage 1 "-$OPTARG requires an argument" ;;
    ?) usage 1 "Unknown option '$opt'" ;;
  esac
done

shift $((OPTIND -1))

declare names=(
    v95377
    v95393
    v95407
    v95541
    v95543
    #v95597
    v95789
    v95797
    v95815
    v95817
    v95819
    v95827
    #v95833
    v95837
    #v95839
    #v95853
    #v95859
    #v95861
    v95863
    v95865
    v95927
    v95965
    v95967
    v95969
    v95971
    v95995
    v95997
)

v95377() {  
        # (AC-17) (2) Remote Access | Protection of Confidentiality / Integrity Using Encryption
        # (AC-17) (2) -Enabling the SSH service answers CCI-000068 stating the macOS system
        # must implement DoD-approved encryption to protect the confidentiality and integrity of
        # remote access sessions including transmitted data and data during preparation for
        # transmission


        scanout="$(launchctl print-disabled system | grep sshd)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"\"com.openssh.sshd\" => false" ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi	
    }

v95393() {
        #(AC-7a) Unsuccessful Logon Attempts (AC-7a) - Enforce using the “Passcode Policy"
        #configuration profile will answer CCI-00004 stating macOS system must enforce the limit
        #of three consecutive invalid logon attempts by a user.

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep 'maxFailedAttempts\|minutesUntilFailedLoginReset')"

        if [ -z "$scanout" ] || [[ "$scanout" != *"maxFailedAttempts = 3"* ]] || [[ "$scanout" != *"minutesUntilFailedLoginReset = 15"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }

v95407() {
        # (AC-10) Concurrent Session Control (AC-10) - Configures SSHD to limit the number of
        # sessions to answer CCI-000054 stating the macOS system must limit the number of
        # concurrent SSH sessions to 10 for all accounts and/or account types. 

        scanout="$(/bin/cat /etc/ssh/sshd_config | grep MaxSessions)"
        scanN="${scanout//[^0-9]/}"
        if [ -z "$scanout" ] || (($scanN>=11));  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }

v95541() {

        # (IA-3) Device Identification and Authentication (IA-3) – Ensuring authentication is
        # required to access all system level preference panes answering CCI-000778 stating the
        # macOS system must uniquely identify peripherals before establishing a connection.

        scanout="$(/usr/bin/security authorizationdb read system.preferences | grep -A1 shared | tr -d '[:space:]')"

        if [ -z "$scanout" ] || [[ "$scanout" != *"<key>shared</key><false/>"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }   

v95543() {
        # macOS system must use an approved antivirus program.

        scanout="$(/bin/ls /usr/local/Cellar/ | /usr/bin/grep clamav; /bin/ls /Applications | /usr/bin/grep McAfee*)"
        datdate="$(/usr/bin/find /usr/local/McAfee/AntiMalware/dats/ -mtime -7 -type f; /usr/bin/find /usr/local/Cellar/clamav/*/share/clamav/ -mtime -7 -type f)"
        if [ -z "$scanout" ] | [[ "$scanout" != [["McAfee" || "clamav"]] ]] | [ -z "$datdate"];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout + $datdate\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }   

#v95597() {
        # (AC-2) (i) (1) Account Management | Authorizes access to the information system based
        # on: A valid access authorization (AC-2) (i) (1) - Creating a new user account that will be
        # used to unlock the disk on startup will answer CCI-000014 stating the macOS system must
        # be configured with a dedicated user account to decrypt the hard disk upon startup


        #scanout="$(sudo fdesetup list | wc -l)"

        #if [ -z "$scanout" ] || (( $scanout > 1 ));  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else                                                
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi	
#}

v95789() {
        # (AC-11b) Session Lock (AC-11b) - Using the "Login Window Policy" configuration
        # profile enforces/answers CCI-000056 stating the macOS system must retain the session
        # lock until the user reestablishes access using established identification and authentication
        # procedures

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep askForPassword)"

        if [ -z "$scanout" ] | [[ "$scanout" != *"askForPassword = 1"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }

v95797() {

        # (AC-11) (1) Session Lock | Pattern-Hiding Displays (AC-11) (1) - Enforcing the "Login Window Policy" 
        # configuration profile will answer CCI-000060 stating the macOS system must conceal, via the session lock, 
        # information previously visible on the display with a publicly viewable image. 

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep modulePath)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"modulePath"* ]]; then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }
v95807() {
        # DISABLED - WE WOULD NEED TO KNOW NAME OF EMERGENCY ACCOUNT TO CHECK. NO SOP FOR EMERGENCY ACCOUNTS.
        # (AC-2) (2) (2)(1) (2)(2) Account Management | Removal of Temporary | Emergency
        # Accounts (AC-2) (2) (2)(1) (2)(2) - Changing the passcode policy for an emergency
        # account and only remove some policy sections, run the following command to save a copy
        # of the current policy file for the specified username will answer CCI-000016 stating the
        # macOS system must automatically remove or disable emergency accounts after the crisis
        # is resolved or within 72 hours


        scanout="$(/usr/bin/pwpolicy -u username getaccountpolicies 2>&1| tail -n +2)"

        if [ -z "$scanout" ] | [[ "$scanout" != *"not found"* ]];  then
        echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
        echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
    }

v95815() {
        # (AC-11a) Session Lock (AC-11a) - Enforcing the "Login Window Policy" configuration
        # profile will answer CCI-000057 stating the macOS system must initiate a session lock after
        # a 15-minute period of inactivity.

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep minutesUntilFailedLoginReset)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"minutesUntilFailedLoginReset = 15"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'                                                        
        fi
}

v95817() {
        # (AC-8a) System Use Notification (AC-8a) - Create a text file containing the required DoD
        # text will answer CCI-000048 stating the macOS system must display the Standard
        # Mandatory DoD Notice and Consent Banner before granting remote access to the operating
        # system.

        dodstring1="You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only."
        #NOTE: due to issues with different formatting of this file, disabling additional line checks.
        #dodstring2="By using this IS (which includes any device attached to this IS), you consent to the following conditions:"
        #dodstring3="-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations."
        #dodstring4="-At any time, the USG may inspect and seize data stored on this IS."
        #dodstring5="-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose."
        #dodstring6="-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy."
        #dodstring7="-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details."

        scanout="$(cat /etc/banner)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"$dodstring1"* ]]; then
        
        #|| [[ "$scanout" != *"$dodstring2"* ]] || \
        #[[ "$scanout" != *"$dodstring3"* ]] || [[ "$scanout" != *"$dodstring4"* ]] || [[ "$scanout" != *"$dodstring5"* ]] || \
        #[[ "$scanout" != *"$dodstring6"* ]] || [[ "$scanout" != *"$dodstring7"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}

v95819() {
        # (AC-8b) System Use Notification (AC-8b) – The systems that allow remote access through
        # SSH are modified to answer CCI-000050 stating macOS system must display the Standard
        # Mandatory DoD Notice and Consent Banner before granting access to the system via SSH.

        scanout="$(/usr/bin/grep Banner /etc/ssh/sshd_config)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"/etc/banner"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi	
}

#v95823()
        # NOTE: DISABLED - Manual check currently, needs improvement for automated check
        # (AU-9) (V-95823) Protection of Audit Information (AU-9) – Log folders that contain ACLs, the
        # macOS system are configured so that log files must not contain access control lists (ACLs).
        # This answers CCI-000162.

        #scanout="$(/usr/bin/sudo ls -le $(/usr/bin/sudo /usr/bin/grep '^dir' /etc/security/audit_control | awk -F: '{print $2}') | /usr/bin/grep -v current)"
        #
        #if [ -z "$scanout" ];  then
        #    echo "false"
        #else                                                                        #Revisit
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi	
        
#v95851() {

        # (AU-9) (V-95851) Protection of Audit Information (AU-9) - If log folder that returns an incorrect
        # permission value per CCI-000162, 000163, 000164 the macOS system is configured with
        # audit log folders set to mode 700 or less permissive.

        #scanout="$(/usr/bin/sudo ls -lde $(/usr/bin/sudo /usr/bin/grep '^dir' /etc/security/audit_control | awk -F: '{print $2}'))"

        #if [ -z "$scanout" ] | [[ "$scanout" != *"drwx"* ]];  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi	
#}

v95827()  {
        # (SC-10) (V-95827) Network Disconnect– Ensuring "ClientAliveInterval" is set correctly answers
        # CCI-001133 stating the macOS system must be configured with the SSH daemon
        # ClientAliveInterval option set to 900 or less.


        scanout=$(/usr/bin/grep ^ClientAliveInterval /etc/ssh/sshd_config)
        scanN="${scanout//[^0-9]/}"
        if [ -z "$scanout" ] || (($scanN>=901));  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}	

#v95833() {
        # (AC-2) (4) (V-95833) Account Management | Automated Audit Actions (AC-2) (4) 
        # – Ensuring the appropriate flags are enabled for auditing will answer CCI-000018 
        # stating the macOS system must generate audit records for all account creations, 
        # modifications, disabling, and termination events; privileged activities or other 
        # system-level access; all kernel module load, unload, and restart actions; all program 
        # initiations; and organizationally defined events for all non-local maintenance and 
        # diagnostic sessions. 

        #scanout="$(/usr/bin/sudo /usr/bin/grep ^flags /etc/security/audit_control)"

        #if [ -z "$scanout" ] || [[ "$scanout" != *"ad"* ]];  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi
#}

v95837() {
    # (AU-3) Content Of Audit Records | (AU-8)3) | Time Stamps | (AU-14)8) | Session Audit | 
    # (AU-12)14) | Audit Generation (AU-12) | Account Management | (AC-2) (4) Automated Audit Actions (AC-2) (4) 
    # - Enable the audit service answers CCI-000130, 000131, 000132, 000133, 000134, 000135, 000159, 0001464, 
    # 0001487, 0001889, 0001890, 0001914, 0002130 stating the macOS system must initiate session audits at system 
    # startup, using internal clocks with time stamps for audit records that meet a minimum granularity of one 
    # second and can be mapped to Coordinated Universal Time (UTC) or Greenwich Mean Time (GMT), in order to generate 
    # audit records containing information to establish what type of events occurred, the identity of any individual 
    # or process associated with the event, including individual identities of group account users, establish where 
    # the events occurred, source of the event, and outcome of the events including all account enabling actions, 
    # fulltext recording of privileged commands, and information about the use of encryption for access wireless 
    # access to and from the system. 

    scanout="$(launchctl print-disabled system | grep auditd)"

    if [ -z "$scanout" ] || [[ "$scanout" != *"\"com.apple.auditd\" => false"* ]];  then
        echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
    else
        echo '{\"result\": \"pass\", \"error_message\": \"\"}'
    fi

}

v95853() {
        # (AU-3) Content Of Audit Records | (AU-8)3) | Time Stamps | (AU-14)8) | Session Audit | 
        # (AU-12)14) | Audit Generation (AU-12) | Account Management | (AC-2) (4) Automated Audit Actions (AC-2) (4) 
        # - Enable the audit service answers CCI-000130, 000131, 000132, 000133, 000134, 000135, 000159, 0001464, 
        # 0001487, 0001889, 0001890, 0001914, 0002130 stating the macOS system must initiate session audits at system 
        # startup, using internal clocks with time stamps for audit records that meet a minimum granularity of one 
        # second and can be mapped to Coordinated Universal Time (UTC) or Greenwich Mean Time (GMT), in order to generate 
        # audit records containing information to establish what type of events occurred, the identity of any individual 
        # or process associated with the event, including individual identities of group account users, establish where 
        # the events occurred, source of the event, and outcome of the events including all account enabling actions, 
        # fulltext recording of privileged commands, and information about the use of encryption for access wireless 
        # access to and from the system. 

        scanout="$(launchctl print-disabled system | grep auditd)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"\"com.apple.auditd\" => false"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi	
}

#v95839() {
        # (AU-5b) (V-95839) Response to Audit Processing Failures (AU-5b) – Change setting for the 
        # audit control system answers CCI-000140 stating the macOS system must shut down by default 
        # upon audit failure. 

        #scanout="$(sudo /usr/bin/grep ^policy /etc/security/audit_control | /usr/bin/grep ahlt)"

        #if [ -z "$scanout" ];  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi
#}

#v95853() {
        # (AU-12) (V-95853) Audit Generation – Setting the audit flags to all recommended settings
        # answers CCI-000172 by stating the macOS system must audit the enforcement actions used
        # to restrict access associated with changes to the system. 

        #scanout="$(/usr/bin/sudo /usr/bin/grep ^flags /etc/security/audit_control)"

        #if [ -z "$scanout" ] || [[ ("$scanout" != *"fm"*) && ("$scanout" != *"-fr"*) && ("$scanout" != *"-fw"*) ]];  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi
#}


#v95859() {
        # (AC-17) (1) Remote Access | Automated Monitoring / Control (AC-17) (1) - Ensuring the
        # appropriate flags are enabled for auditing answers CCI-000067 stating the macOS system
        # must monitor remote access methods and generate audit records when
        # successful/unsuccessful attempts to access/modify privileges occur.

        #scanout="$(/usr/bin/sudo /usr/bin/grep ^flags /etc/security/audit_control)"

        #if [ -z "$scanout" ] | [[ "$scanout" != *"aa"* ]];  then
        #    echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        #else
        #    echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        #fi	
#}


#v95861() {
#        # NOTE: Not everyone is using CACs, so this is going to fail on some machines.
#        # (IA-2) (1) (2) (3) (4) Identification and Authentication | Network Access To Privileged
#        # Accounts - Enforcing the "Smart Card Policy" configuration profile for non-directory
#        # bound systems answers CCI-000765, 000766, 000767, 000768 stating the macOS system 
#        # FOR OFFICIAL USE ONLY 6
#        # must use multifactor authentication for local and network access to privileged and nonprivileged accounts.
#
#        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep checkCertificateTrust)"
#
#        if [ -z "$scanout" ] || [[ "$scanout" != "checkCertificateTrust = 0" ]];  then
#            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
#        else
#            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
#        fi
#}


v95863() {
        # (IA-2) (5) (V-95863) Identification and Authentication | Group Authentication (IA-2) (5) - Ensuring
        # that "PermitRootLogin" is disabled by sshd answers CCI-000770 stating the macOS system
        # must require individuals to be authenticated with an individual authenticator prior to using
        # a group authenticator

        scanout="$(/usr/bin/grep ^PermitRootLogin /etc/ssh/sshd_config)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"no"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}


v95865() {
        # (CM-7) Least Functionality – Disabling the SMB File Sharing service will answer 
        # CCI000381 stating the macOS system must be configured to disable SMB File Sharing unless
        # it is required. Enforcing the "Restrictions Policy" configuration profile will answer 
        # CCI000382 stating the macOS system must be configured to disable sending diagnostic and
        # usage data to Apple. 

        scanout="$(/bin/launchctl print-disabled system | /usr/bin/grep com.apple.smbd)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"\"com.apple.smbd\" => true"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}
v95927() {
        # (IA-5)(1)(c) (V-95927) – Disabling the tftpd service answers CCI-000197 stating
        # the macOS system must be configured to disable the tftpd service. 

        scanout="$(launchctl print-disabled system | grep tftpd)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"\"com.apple.tftpd\" => true"* ]]; then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}

v95965() {
        # (IA-5)(1)(d) (V-95965) -enforcing the "Passcode Policy" configuration profile answers CCI-000199 
        # stating the macOS system must enforce a 60-day maximum password lifetime restriction. 

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep maxPINAgeInDays)"
        scanN="${scanout//[^0-9]/}"
        if [ -z "$scanout" ] || (($scanN>=61));  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"                                                                            
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}
v95967() {
        # (IA-5)(1)(e) (V-95967) - enforcing the "Passcode Policy" configuration profile answers CCI-000200 stating the
        # macOS system must prohibit password reuse for a minimum of five generations.

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep pinHistory)"
        scanN="${scanout//[^0-9]/}"
        if [ -z "$scanout" ] || (($scanN<5));  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}


v95969() {
        #(IA-5)(1)(a) (V-95969) – enforcing the "Passcode Policy" configuration profile answers CCI-000205 stating
        #the macOS system must enforce a minimum 15-character password length.

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep minLength)"
        if [ -z "$scanout" ] || [[ "$scanout" != *"minLength = 15"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}

v95971() {
        #(IA-5)(1)(a)  (V-95971) Authenticator Management | Password-Based Authentication (IA-5) (1) (a)
        #- Enforcing the "Passcode Policy" configuration profile answers CCI-000194 stating the
        #macOS system must enforce password complexity by requiring that at least one numeric
        #character be used.

        scanout="$(/usr/sbin/system_profiler SPConfigurationProfileDataType | /usr/bin/grep minComplexChars)"
        if [ -z "$scanout" ] || [[ "$scanout" != *"minComplexChars = 1"* ]];  then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi

        minComplexChars = 1;
}


v95995() {
        # (AU-6) (4) Audit Review, Analysis, And Reporting | Central Review and Analysis | 
        # (AU7) (1)6) (4) | Audit Reduction and Report Generation | Automatic Processing |
        # ((AU-12) 7) (1) | Audit Generation | (AU-9)12) | Protection of Audit Information 
        # (AU-9) | Audit Reduction and Report Generation (AU-7) | Access Restrictions For Change |  
        # (CM-5) (6) Limit Library Privileges (CM-5) (6) - Reenable "System Integrity Protection" 
        # will answer CCI-000154, 000158, 000169, 001493, 001494, 001495, 001499, 001875, 001876, 
        # 001877, 001878, 001879, 001880, 001881, 001882 stating the macOS system must enable 
        # System Integrity Protection. 

        scanout="$(/usr/bin/csrutil status)"

        if [ -z "$scanout" ] || [[ "$scanout" != *"System Integrity Protection status: enabled"* ]]; then
            echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
        else
            echo '{\"result\": \"pass\", \"error_message\": \"\"}'
        fi
}

v95997() {
    # (SC-28) (V-95997) Protection of Information at Rest– Setting up and configuring full-disk encryption
    # answers CCI-001199 stating the macOS system must implement cryptographic
    # mechanisms to protect the confidentiality and integrity of all information at rest.
    scanout=$(/usr/bin/fdesetup status)
    if [ -n "$scanout" ] && [[ $scanout == *"FileVault is On"* ]]; then
        echo '{\"result\": \"pass\", \"error_message\": \"\"}'
    else
        echo "{\\\"result\\\": \\\"fail\\\", \\\"error_message\\\": \\\"$scanout\\\"}"
    fi
}

get_percentage()  {
    passed=0
    skipped=0
    total=0
    results=()
    for element in "${names[@]}"; do
        if [[ ${2} != *"$element"* ]]; then
          ((total++))
          result=`${element}`
          results+=("$element - $result,")
          if [[ "$result" == *"\\\"result\\\": \\\"pass\\\""* ]];then
            ((passed++))
          fi
        else
          ((skipped++))
        fi
    done

    calculated_threshold=$(( 100*passed/total ))

    if [[ $calculated_threshold -ge ${1} ]];then
        echo "{\"result\": \"pass\", \"skipped\": \"$skipped\", \"passed\": \"$passed\", \"failed\": \"$(( total-passed ))\", \"Percentage Passed\": \"$calculated_threshold%\", \"results\": \"${results[@]}\"}"
    else
        echo "{\"result\": \"fail\", \"skipped\": \"$skipped\", \"passed\": \"$passed\", \"failed\": \"$(( total-passed ))\", \"Percentage Passed\": \"$calculated_threshold%\", \"results\": \"${results[@]}\"}"
    fi

}

get_percentage $threshold $disabled_checks 2> /dev/null
