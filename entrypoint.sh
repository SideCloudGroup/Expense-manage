#!/bin/bash

cd /var/www/html || exit
composer upgrade --no-interaction --optimize-autoloader
chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html
php think migrate:run
exec "$@"
