#!/bin/bash
echo "[begin] common_entrypoint_extension.sh"
cp /var/www/html/.env.dist /tmp/.env

sed -i -E "/^##/d" /tmp/.env
while IFS='=' read -r -d '' n v; do
    sed -i -E "s~^($n=)(.*)~\1${v//&/\\&}~" /tmp/.env
    sed -i -E "s~^(#$n=)(.*)~\1${v//&/\\&}~" /tmp/.env
    if grep -q "#$n=" /tmp/.env; then
        sed -i -E "s/#$n/${n//&/\\&}/g" /tmp/.env
    fi
done < <(env -0)

cp /tmp/.env /var/www/html/.env

echo "[ end ] common_entrypoint_extension.sh"
