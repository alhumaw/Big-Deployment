#!/bin/sh
echo "<html><body><h1>Hello from $(hostname)</h1></body></html>" > /var/www/localhost/htdocs/index.html
lighttpd -D -f /etc/lighttpd/lighttpd.conf
