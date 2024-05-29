# For IP Blocking:

**Save the following script as:** 
` sudo nano /usr/local/bin/drop_ip.sh `
`sudo chmod +x /usr/local/bin/drop_ip.sh`

**Add to crontab**

`sudo crontab -e`

`*/2 * * * * sudo /usr/local/bin/drop_ip.sh`

**Log File**
The log file that shows the IP addresses blocked will be in the directory '/usr/log/honeypot'
