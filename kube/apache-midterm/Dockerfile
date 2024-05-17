FROM httpd:alpine
COPY start.sh /usr/local/apache2/htdocs/
RUN chmod +x /usr/local/apache2/htdocs/start.sh
CMD ["/usr/local/apache2/htdocs/start.sh"]
EXPOSE 80

