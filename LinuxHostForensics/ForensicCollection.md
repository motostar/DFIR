# Forensic Data collection Script for Linux Systems

The Forensic Script is a bash script designed to help system administrators and forensic investigators collect critical system and user activity information from Linux systems. The script provides a menu-driven interface that allows users to select from a variety of system logs and configuration files to be collected. It also provides an option to encrypt the final ZIP file and upload it to a remote server.

## Context

The Forensic Script can be used by system administrators and forensic investigators to collect data from Linux systems for various purposes, including incident response, threat hunting, and system analysis. The script provides a simple and standardized way to collect system and user activity information from a Linux system, which can be helpful in detecting and investigating security incidents.

## Usage

The Forensic Script can be executed on a Linux system with bash installed. Once executed, it provides a menu-driven interface that allows users to select the logs and configuration files they want to collect. The collected data is stored in a ZIP file in a timestamped subdirectory in the `/var/log/forensic` directory.

The collected data can be further analyzed using various forensic analysis tools, including log parsers, timeline analysis tools, and memory forensics tools.

To use the script, simply run the following command:

bashCopy code

`sudo ./forensic_script.sh` 

The script will prompt you to select which logs and files you want to collect. Enter the corresponding number for each option you want to choose. Once you've selected all the options you want, enter `0` to finish and create a compressed and encrypted archive with the collected data.

## Options

Here is a list of the options available in the script:

1.  Hostname - Collects the hostname of the system.
2.  Locatime - Collects the current date and time of the system.
3.  Zoneinfo - Collects the timezone information of the system.
4.  DHCP Client - Collects the DHCP client configuration files.
5.  Password File - Collects the password file (/etc/passwd).
6.  Shadow File - Collects the shadow file (/etc/shadow).
7.  Group File - Collects the group file (/etc/group).
8.  Sudoers File - Collects the sudoers file (/etc/sudoers).
9.  Sysctl Configuration - Collects the sysctl configuration file (/etc/sysctl.conf) and a list of all sysctl settings.
10.  Udev Information - Collects the udev device database and configuration files.
11.  Kernel Messages - Collects the kernel messages with `dmesg` and kernel log files (/var/log/kern.log*).
12.  Systemd Units and Jobs - Collects the list of all systemd units and jobs.
13.  Last Login Information - Collects the last login information and faillog (/var/log/lastlog and /var/log/faillog).
14.  WTMP and BTMP Files - Collects the wtmp and btmp log files (/var/log/wtmp* and /var/log/btmp*).
15.  Audit Log - Collects the audit log files (/var/log/audit/audit.log*).
16.  Auth Log - Collects the authentication log files (/var/log/auth.log*).
17.  SSHD Log - Collects the SSH daemon log files (/var/log/sshd.log*).
18.  System Messages - Collects the system messages (/var/log/messages*).
19.  Browser Logs - Collects the browser logs for Firefox and Chrome.
20.  Command History - Collects the command history for the current user.
21.  Process List - Collects a list of all running processes.
22.  Netstat Output - Collects the output of the netstat command.
23.  Active Outbound Connections - Collects a list of active outbound connections.
24.  List of Files in /tmp Folder - Collects a list of all files in the /tmp folder.
25.  Cron Jobs - Collects the cron jobs for the current user and system-wide cron jobs.
26.  SSH Authorized Keys - Collects the SSH authorized keys for the current user.
27.  SSH Allowed and Denied Host List - Collects the SSH allowed and denied host list and TCP wrappers configuration files.
28.  Hosts File - Collects the hosts file (/etc/hosts).
29.  Startup Scripts - Collects the startup scripts (/etc/rc.local, /etc/init.d/_, /etc/systemd/system/_, and /usr/lib/systemd/system/*).
30.  Processes Running with Root Privileges - Collects a list of all processes running with root privileges.

## Examples

Here are some examples of how the forensic script can be used:

1.  Collecting all logs for a specific user:
    
    shellCopy code
    
    `$ sudo ./forensic.sh -u alice` 
    
    This command will collect all logs related to the user `alice`, including their shell history, cron jobs, and SSH keys.
    
2.  Collecting logs for a specific time period:
    
    shellCopy code
    
    `$ sudo ./forensic.sh -s "2022-01-01 00:00:00" -e "2022-01-31 23:59:59"` 
    
    This command will collect all logs generated between January 1st and January 31st of the year 2022.
    
3.  Encrypting and uploading logs to a remote server:
    
    shellCopy code
    
    `$ sudo ./forensic.sh -e -u alice -r user@remote-server:/path/to/logs` 
    
    This command will encrypt all logs related to the user `alice` and upload them to a remote server at the path `/path/to/logs`. The encrypted file will be named `forensic_logs.zip.gpg`.
    
4.  Collecting logs for a specific process:
    
    shellCopy code
    
    `$ sudo ./forensic.sh -p apache` 
    
    This command will collect all logs related to the Apache web server.
    
5.  Collecting logs for a specific file:
    
    shellCopy code
    
    `$ sudo ./forensic.sh -f /var/log/syslog` 
    
    This command will collect the `syslog` file located in the `/var/log` directory.
 

## **Encrypting and Uploading the ZIP File**

To encrypt the final ZIP file and upload it to a remote server, set the `ENCRYPT` and `UPLOAD` variables to `true` and provide the required details, such as the remote server IP address and SSH credentials.

makefileCopy code

`ENCRYPT=true
UPLOAD=true
REMOTE_SERVER_IP=192.168.1.100
REMOTE_SERVER_USERNAME=john
REMOTE_SERVER_PASSWORD=password`

## Further Improvements:

1.  Adding support for additional log files and directories.
2.  Adding support for more operating systems and distributions.
3.  Improving the user interface and menu options.
4.  Implementing additional encryption and security measures.
5.  Integrating with other forensic tools for more comprehensive analysis.
6.  Adding support for automated reporting and analysis.
7.  Implementing a more efficient way of collecting and storing logs to reduce disk space usage.
8.  Adding support for collecting logs from remote hosts.
