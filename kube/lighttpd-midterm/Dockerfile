FROM alpine:latest
RUN apk add --no-cache lighttpd
COPY start.sh /var/www/localhost/htdocs/
RUN chmod +x /var/www/localhost/htdocs/start.sh
CMD ["/var/www/localhost/htdocs/start.sh"]
EXPOSE 80
