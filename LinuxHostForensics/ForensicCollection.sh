#############################################################################################################################
# ForensicCollection.sh
#
#  .SYNOPSIS
#     Collect forensic artifacts from linux host machine
#
#  .DESCRIPTION
#      This shell script allows investigators to collect, process, archive, encrypt and upload the forensic artifacts from linux hsot to remote server  
#
#  .PREREQUISITES
#       1. Access to victim host
#       2. Appropriate privileges to execute and access data from host
#   .LINK
#
#     	Author: Balasubramanya Chandrashekar
#       Date: 2023-03-23
#       Version: 1.0
############################################################################################################################

#!/bin/bash

# Set output directory and create if it doesn't exist
output_dir="/var/log/forensic"
if [[ ! -d "$output_dir" ]]; then
  mkdir -p "$output_dir"
fi

# Generate output subdirectory name based on current timestamp and sequence number
seq=0
while true; do
  timestamp=$(date +%Y%m%d-%H%M%S)
  output_subdir="$output_dir/$timestamp-$seq"
  if [[ ! -d "$output_subdir" ]]; then
    mkdir "$output_subdir"
    break
  fi
  seq=$((seq+1))
done

# Define a function to show the menu
show_menu() {
  echo "Which logs do you want to collect? (Enter the corresponding number)"
  echo "1. Hostname"
  echo "2. Locatime"
  echo "3. Zoneinfo"
  echo "4. DHCP Client"
  echo "5. Password File"
  echo "6. Shadow File"
  echo "7. Group File"
  echo "8. Sudoers File"
  echo "9. Sysctl Configuration"
  echo "10. Udev Information"
  echo "11. Kernel Messages"
  echo "12. Systemd Units and Jobs"
  echo "13. Last Login Information"
  echo "14. WTMP and BTMP Files"
  echo "15. Audit Log"
  echo "16. Auth Log"
  echo "17. SSHD Log"
  echo "18. System Messages"
  echo "19. Browser Logs"
  echo "20. Command History"
  echo "21. Process List"
  echo "22. Netstat Output"
  echo "23. Active Outbound Connections"
  echo "24. List of Files in /tmp Folder"
  echo "25. Cron Jobs"
  echo "26. SSH Authorized Keys"
  echo "27. SSH Allowed and Denied Host List"
  echo "28. Hosts File"
  echo "29. Startup Scripts"
  echo "30. Processes Running with Root Privileges"
  echo "0. Done"
}

# Define functions to collect logs
collect_hostname() {
  hostname > "$output_subdir/hostname.txt"
}

collect_locatime() {
  date > "$output_subdir/date.txt"
}

collect_zoneinfo() {
  cp /etc/localtime "$output_subdir/localtime"
  cp /etc/timezone "$output_subdir/timezone"
}

collect_dhclient() {
  cp /var/lib/dhcp/dhclient.* "$output_subdir/" || echo "Error: Failed to copy dhclient files"
}

collect_passwd() {
  cp /etc/passwd "$output_subdir/passwd" || echo "Error: Failed to copy password file"
}

collect_shadow() {
  cp /etc/shadow "$output_subdir/shadow" || echo "Error: Failed to copy shadow file"
}

collect_group() {
  cp /etc/group "$output_subdir/group" || echo "Error: Failed to copy group file"
}

collect_sudoers() {
  cp /etc/sudoers "$output_subdir/sudoers" || echo "Error: Failed to copy sudoers file"
}

collect_sysctl() {
  cp /etc/sysctl.conf "$output_subdir/sysctl.conf"
  sysctl -a > "$output_subdir/sysctl.txt" || echo "Error: Failed to collect sysctl information"
}

collect_udev() {
  udevadm info --export-db > "$output_subdir/udev.txt" || echo "Error: Failed to collect udev information"
}

collect_kernel() {
  dmesg > "$output_subdir/dmesg.txt" || echo "Error: Failed to collect kernel messages with dmesg"
  cp /var/log/kern.log* "$output_subdir/" || echo "Error: Failed to copy kernel log files"
}

collect_systemd() {
  systemctl list-units --all > "$output_subdir/systemctl_units.txt" || echo "Error: Failed to list systemd units"
  systemctl list-jobs > "$output_subdir/systemctl_jobs.txt" || echo "Error: Failed to list systemd jobs"
}

collect_login() {
  last > "$output_subdir/last.txt" || echo "Error: Failed to collect last login information"
  cp /var/log/faillog "$output_subdir/" || echo "Error: Failed to copy faillog file"
}

collect_wtmp() {
  cp /var/log/wtmp* "$output_subdir/" || echo "Error: Failed to copy wtmp files"
}

collect_btmp() {
  cp /var/log/btmp* "$output_subdir/" || echo "Error: Failed to copy btmp files"
}

collect_audit() {
  cp /var/log/audit/audit.log* "$output_subdir/" || echo "Error: Failed to copy audit log files"
}

collect_auth() {
  cp /var/log/auth.log* "$output_subdir/" || echo "Error: Failed to copy auth log files"
}

collect_sshd() {
  cp /var/log/sshd.log* "$output_subdir/" || echo "Error: Failed to copy sshd log files"
}

collect_messages() {
  cp /var/log/messages* "$output_subdir/" || echo "Error: Failed to copy system messages"
}

collect_browser_logs() {
  for browser in firefox chrome; do
    browser_dir="$HOME/.config/$browser"
    if [[ -d "$browser_dir" ]]; then
      cp -R "$browser_dir" "$output_subdir/" || echo "Error: Failed to copy browser logs for $browser"
    fi
  done
}

collect_history() {
  history > "$output_subdir/history.txt" || echo "Error: Failed to collect command history"
}

collect_process_list() {
  ps -auxf > "$output_subdir/process_list.txt" || echo "Error: Failed to list all processes"
}

collect_netstat() {
  netstat -an > "$output_subdir/netstat.txt" || echo "Error: Failed to collect netstat output"
}

collect_outbound_connections() {
  netstat -an | awk '{print $5}' | grep -v '127.0.0.1' | grep -v '0.0.0.0' | grep -v '::1' | grep -v 'localhost' > "$output_subdir/outbound_connections.txt" || echo "Error: Failed to collect outbound connections"
}

collect_tmp_files() {
  ls -alR /tmp/ > "$output_subdir/tmp_files.txt" || echo "Error: Failed to list files in /tmp folder"
}

collect_cron_jobs() {
  crontab -l > "$output_subdir/crontab.txt" || echo "Error: Failed to list cron jobs for current user"
  cp /etc/crontab "$output_subdir/" || echo "Error: Failed to copy system-wide crontab file"
  for user in $(cut -f1 -d: /etc/passwd); do
    crontab -u "$user" -l > "$output_subdir/crontab_$user.txt" || echo "Error: Failed to list cron jobs for user $user"
  done

  # Prompt user to encrypt and upload zip file to remote server
  read -p "Do you want to encrypt and upload the log files to a remote server? (y/n) " upload_choice

  if [[ $upload_choice == "y" || $upload_choice == "Y" ]]; then
    # Prompt user for remote server details
    read -p "Enter the remote server IP address or hostname: " remote_server
    read -p "Enter the remote server username: " remote_username

    # Compress logs to a zip file
    zip_filename="forensic_logs_$(date +%Y%m%d_%H%M%S).zip"
    zip -r "$zip_filename" "$output_subdir"

    # Prompt user for encryption password
    read -s -p "Enter an encryption password for the zip file: " zip_password
    echo

    # Encrypt zip file with password
    openssl enc -aes-256-cbc -pass "pass:$zip_password" -in "$zip_filename" -out "$zip_filename.enc"

    # Upload encrypted zip file to remote server using SCP
    scp "$zip_filename.enc" "$remote_username@$remote_server:/home/$remote_username/"

    # Remove temporary zip files
    rm "$zip_filename" "$zip_filename.enc"
  fi
}
