# For logging:

`sudo nano /usr/local/bin/hourly_capture.sh`
`sudo chmod +x /usr/local/bin/hourly_capture.sh`
```bash
#!/bin/bash

# Define the paths for the log files with timestamps
timestamp=$(date +\%Y-\%m-\%d-\%H)
capture_log="/var/log/honeypot/honeypot-$timestamp.log"

# Run tcpdump in the background and capture packets 
sudo tcpdump -i any 'ip and not port 22 and not port 80' -n -tttt > "$capture_log" &
TCPDUMP_PID=$!

# Sleep for 58 minutes
sleep 3480

# Kill 
sudo kill $TCPDUMP_PID

```
`cat /var/log/honeypot/honeypot-$(date +\%Y-\%m-\%d-\%H).log`

**Add to crontab**
`0 * * * * sudo /usr/local/bin/hourly_capture.sh`