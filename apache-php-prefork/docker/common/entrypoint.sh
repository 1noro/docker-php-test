#!/bin/bash
echo "[begin] entrypoint.sh"
test -f /1noro/entrypoint_extension.sh && \
    source /1noro/entrypoint_extension.sh
echo "[ end ] entrypoint.sh"
echo "[start] runnning original entrypoint: /usr/local/bin/docker-php-entrypoint" "$@"
exec /usr/local/bin/docker-php-entrypoint "$@"
