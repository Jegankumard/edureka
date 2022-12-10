FROM devopsedu/webapp
MAINTAINER Jegan <kumarjegansvg@gmail.com>
RUN apt-get update -y
RUN apt install -y apache && apt install -y php
COPY website /var/www/html/
EXPOSE 8080
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
