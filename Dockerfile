FROM busybox:latest

ADD index.html /www/index.html
RUN service httpd stop && \
    service httpd start
EXPOSE 80

#EXPOSE 8000
#HEALTHCHECK CMD nc -z localhost 8000

# Create a basic webserver and run it until the container is stopped
#CMD trap "exit 0;" TERM INT; httpd -p 8000 -h /www -f & wait
