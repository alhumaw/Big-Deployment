#!/bin/bash

log_file="/var/log/honeypot/block_ip.log"

# Clear the log file before appending new entries
> "$log_file"

# Define the path for the cumulative IP list
cumulative_ip_list="/var/log/honeypot/ip_list_all.txt"

# Check if the cumulative IP list exists
if [[ -f "$cumulative_ip_list" ]]; then
    # Read each IP address from the list and add DROP rule to iptables
    while IFS= read -r ip_address; do
        sudo iptables -I INPUT -s "$ip_address" -j DROP
        if [ $? -eq 0 ]; then
            echo "$(date +"%Y-%m-%d %T") Blocked IP: $ip_address" >> "$log_file"
        else
            echo "$(date +"%Y-%m-%d %T") Failed to block IP: $ip_address" >> "$log_file"
        fi
    done < "$cumulative_ip_list"
else
    echo "Cumulative IP list not found!" | tee -a "$log_file"
    exit 1
fi

