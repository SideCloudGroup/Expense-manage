FROM php:8.3-fpm-alpine

RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      libpng-dev \
      libjpeg-turbo-dev \
      freetype-dev \
      libzip-dev \
      oniguruma-dev \
      libxml2-dev \
      unzip \
      curl; \
    apk add --no-cache \
      libpng \
      libjpeg-turbo \
      freetype \
      libzip \
      oniguruma; \
    \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" \
      pdo_mysql \
      mbstring \
      exif \
      pcntl \
      zip \
      gd \
      bcmath; \
    \
    curl -sS https://getcomposer.org/installer \
      | php -- --install-dir=/usr/local/bin --filename=composer; \
    \
    mkdir -p /var/run/php; \
    chown -R www-data:www-data /var/run/php; \
    sed -i 's#;pid = run/php-fpm.pid#pid = /var/run/php/php-fpm.pid#' \
      /usr/local/etc/php-fpm.conf; \
    \
    apk del .build-deps

WORKDIR /var/www/html

COPY . /var/www/html

RUN composer install --no-dev --no-interaction --no-progress --no-suggest --optimize-autoloader

EXPOSE 9000

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]