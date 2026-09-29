FROM ubuntu:latest
RUN apt update
RUN apt install apache2 -y
COPY ./index.html /var/www/html/index.html
EXPOSE 80
CMD apachectl -D FOREGROUND