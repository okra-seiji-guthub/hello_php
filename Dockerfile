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
    libpq-dev \
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


# 2. PHP拡張のインストール
# RUN docker-php-ext-install pdo_mysql mysqli intl zip


# 1. Composerのインストール
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# 2. ソースコードのコピー
WORKDIR /var/www/html
COPY src/ /var/www/html/

# 3. PHP 7.2 用のライブラリをインストール
# composer.jsonのplatform設定に従ってビルドされます
RUN composer install --no-interaction --optimize-autoloader

# 4. 権限設定
RUN chown -R www-data:www-data /var/www/html




# Apache
RUN a2enmod rewrite

# DocumentRootの変更
RUN sed -i 's|DocumentRoot .*|DocumentRoot /var/www/html/webroot|' /etc/apache2/sites-available/000-default.conf

# /var/www/html/webroot に対して AllowOverride All を設定
# これにより webroot/.htaccess が読み込まれる
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 権限設定
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
