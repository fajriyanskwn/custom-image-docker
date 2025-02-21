#!/bin/bash
set -e

# Set timezone
echo "Setting timezone to $TIMEZONE"
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Update PHP ini settings
echo "Updating PHP settings..."
echo "post_max_size=$POST_MAX_SIZE" >> /usr/local/etc/php/conf.d/uploads.ini
echo "memory_limit=$MEMORY_LIMIT" >> /usr/local/etc/php/conf.d/memory.ini
echo "max_input_vars=$MAX_INPUT_VARS" >> /usr/local/etc/php/conf.d/input_vars.ini
echo "upload_max_filesize=$UPLOAD_MAX_FILESIZE" >> /usr/local/etc/php/conf.d/upload.ini
echo "max_execution_time=$MAX_EXECUTION_TIME" >> /usr/local/etc/php/conf.d/execution.ini
echo "max_input_time=$MAX_INPUT_TIME" >> /usr/local/etc/php/conf.d/input_time.ini

# Jalankan SSH jika diperlukan
if [ "$SSH_SERVICE" = "start" ]; then
    echo "Starting SSH service..."
    service ssh start
fi

# Start services
echo "Starting services..."
# service php8.3-fpm start
php-fpm -D
service nginx start

# Jaga container tetap berjalan
exec "$@"
