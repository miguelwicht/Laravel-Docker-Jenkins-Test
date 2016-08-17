# Pull base image.
FROM php:5.6-apache

RUN a2enmod rewrite

# Multibyte String support for php
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo pdo_mysql
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Copy virtual host
COPY misc/apache/vhosts/000-default.conf /etc/apache2/sites-available/
COPY misc/apache/vhosts/default-ssl.conf /etc/apache2/sites-available/

RUN a2ensite 000-default
RUN a2ensite default-ssl

# Create directory for apache logs
RUN mkdir /var/www/logs \
    && chown www-data:www-data /var/www/logs
