#!/bin/sh
echo "<html><body><h1>Hello from $(hostname)</h1></body></html>" > /usr/local/apache2/htdocs/index.html
httpd -DFOREGROUND
