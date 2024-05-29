# For IP Gathering:

**Save the following script as:** 
` sudo nano /usr/local/bin/capture_ips_quick.sh `
`sudo chmod +x /usr/local/bin/capture_ips_quick.sh`



Contents:
```bash
#!/bin/bash

# Get the honeypot's IP address
my_ip=$(hostname -I | awk '{print $1}')

# Define the path for the cumulative IP list
cumulative_ip_list="/var/log/honeypot/ip_list_all.txt"
temp_file="/tmp/quick_capture.log"

# Delete the temporary file if it exists
sudo rm -f "$temp_file"

# Start caturing packets in the background, excluding our own IP address
sudo tcpdump -i any "ip and not host $my_ip and not port 22 and not port 80" -n -tttt > "$temp_file" &
TCPDUMP_PID=$!

# Sleep
sleep 105

# Kill process
sudo kill $TCPDUMP_PID

# Check if the cature file is created and has content
if [[ -s "$temp_file" ]]; then
    # Extract and sort unique IP addresses, then append to the list
    grep -oP '(\d{1,3}\.){3}\d{1,3}' "$temp_file" | grep -v "$my_ip" | sort | uniq >> "$cumulative_ip_list"

    # Ensure the IP list remains unique
    sort -u "$cumulative_ip_list" -o "$cumulative_ip_list"
fi

# Remove the temporary file after procesing
sudo rm -f "$temp_file"
```
**Add to crontab**

`sudo crontab -e`

`*/2 * * * * sudo /usr/local/bin/capture_ips_quick.sh`


Read the file: 

`cat /var/log/honeypot/ip_list_all.txt`
