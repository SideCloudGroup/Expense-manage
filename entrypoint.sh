#!/bin/sh

cd /var/www/html || exit 1
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
php think migrate:run
exec "$@"
