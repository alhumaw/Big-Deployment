#!/bin/sh
echo "<html><body><h1>Hello from $(hostname)</h1></body></html>" > /usr/share/nginx/html/index.html
nginx -g 'daemon off;'
