FROM php:7.2-apache

# Note: This Dockerfile uses PHP 7.2 which is based on Debian Buster (EOL).
# For production use, consider upgrading to a newer PHP version (7.4+ or 8.x)
# with updated Debian repositories.

# Use archive.debian.org for Buster packages (since Buster reached EOL)
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
    intl \
    pdo_mysql \
    mbstring \
    zip \
    gd

# Install Redis extension
RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

# Enable Apache modules
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:1.10 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy application files
COPY src/ /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
