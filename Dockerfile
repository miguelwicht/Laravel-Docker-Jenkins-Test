# Pull base image.
FROM php:5.6-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) mbstring mysqli pdo pdo_mysql iconv mcrypt gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directory for apache logs and vhosts and disable default vhosts
# and active mod_rewrite
RUN mkdir /var/www/logs \
    && chown www-data:www-data /var/www/logs \
    && mkdir -p /etc/apache2/vhosts \
    && a2dissite 000-default \
    && a2dissite default-ssl \
    && a2enmod rewrite
