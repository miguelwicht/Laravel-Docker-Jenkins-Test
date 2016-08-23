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

# Copy virtual host
COPY [
    "misc/apache/vhosts/000-default.conf",
    "misc/apache/vhosts/default-ssl.conf",
    "/etc/apache2/sites-available/"
]

RUN a2ensite 000-default \
    && a2ensite default-ssl \
    && a2enmod rewrite

# Create directory for apache logs
RUN mkdir /var/www/logs \
    && chown www-data:www-data /var/www/logs
