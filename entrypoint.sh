#!/bin/bash

cd /var/www/html || exit
chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html
php think migrate:run
exec "$@"
