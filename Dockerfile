# ./Dockerfile

FROM php:7.2-apache

ENV TZ=Asia/Tokyo

# Debian EOL 対応（buster）
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
    && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
    && sed -i '/buster-updates/d' /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# OS & build dependencies
RUN apt-get update \
    && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    vim \
    autoconf \
    gcc \
    g++ \
    make \
    pkg-config \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    intl \
    zip \
    bcmath \
    opcache \
    && pecl install redis-5.3.7 \
    && docker-php-ext-enable redis \
    && apt-get purge -y \
    autoconf \
    gcc \
    g++ \
    make \
    pkg-config \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Apache
RUN a2enmod rewrite

# Apache ServerName
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

WORKDIR /var/www/html
COPY src/ /var/www/html/
RUN sed -i 's|DocumentRoot .*|DocumentRoot /var/www/html/webroot|' /etc/apache2/sites-available/000-default.conf
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
