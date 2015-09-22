FROM ysaotome/ubuntu:14.04

MAINTAINER Yuichi Saotome <y@sotm.jp>

# Install
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apache2 apache2-utils php5 php5-curl php5-gd php-pear php-compat
RUN rm -rf /var/lib/apt/lists/*

# apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod auth_digest

# pukiwiki
RUN wget -O pukiwiki-1_5_0_utf8.zip 'http://osdn.jp/frs/redir.php?m=jaist&f=%2Fpukiwiki%2F61634%2Fpukiwiki-1_5_0_utf8.zip' 
RUN unzip pukiwiki-1_5_0_utf8.zip && mv pukiwiki-1_5_0_utf8 /var/www/pukiwiki && rm -rf pukiwiki-1_5_0_utf8.zip
RUN sed -i -e "s|$adminpass = '{x-php-md5}!';|$adminpass = '{x-php-md5}'.md5('pukiwiki');|g" /var/www/pukiwiki/pukiwiki.ini.php

# Default workdir
ENV HOME /var/www/
WORKDIR /var/www/

# Export Port
EXPOSE 80
EXPOSE 443

# Default command
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

