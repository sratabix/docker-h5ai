#!/bin/bash
set -e

if [ -z "$HT_PASSWORD" ]; then
    echo "Error: HT_PASSWORD environment variable is not set."
    exit 1
fi

htpasswd -c -b /etc/nginx/.htpasswd admin ${HT_PASSWORD}

nginx -p /etc/nginx -c nginx.conf &
nginx_pid=$!

php-fpm8.5 -F -O &
php_fpm_pid=$!

wait -n

exit_code=$?

kill $nginx_pid $php_fpm_pid 2>/dev/null || true

exit $exit_code
