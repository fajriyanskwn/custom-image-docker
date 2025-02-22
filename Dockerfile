# # Gunakan image resmi PHP 8.3 dengan FPM
# FROM php:8.3-fpm

# # Install dependencies
# RUN apt-get update && apt-get install -y apt-utils \
#     nginx \
#     curl \
#     unzip \
#     git \
#     supervisor \
#     nano \
#     openssh-server \
#     && rm -rf /var/lib/apt/lists/*

# # Install Node.js 20
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
#     && apt-get install -y nodejs

# # Konfigurasi Nginx
# COPY nginx/default.conf /etc/nginx/sites-available/default
# RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# RUN apt-get update && apt-get install -y \
#     libonig-dev \
#     libzip-dev \
#     && docker-php-ext-install pdo pdo_mysql

# # Konfigurasi PHP
# RUN docker-php-ext-install pdo pdo_mysql \
#     && docker-php-ext-enable pdo pdo_mysql

# # Konfigurasi SSH
# RUN mkdir /var/run/sshd && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# # Definisikan environment variable
# ENV SSH_USER=developer
# ENV SSH_PASSWORD=@Dev5kwn24

# # Buat user dengan password
# RUN useradd -m -s /bin/bash ${SSH_USER} && echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd && usermod -aG sudo ${SSH_USER}


# # Konfigurasi Supervisor
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# # Copy project ke dalam container
# COPY www /var/www/html

# # Expose ports
# EXPOSE 80 443 22

# # Jalankan entrypoint
# CMD ["/entrypoint.sh"]

# phase 2

# # Gunakan image resmi PHP 8.3 dengan FPM
# FROM php:8.3-fpm

# # Set DEBIAN_FRONTEND agar tidak ada prompt interaktif
# ENV DEBIAN_FRONTEND=noninteractive

# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     apt-utils \
#     nginx \
#     curl \
#     unzip \
#     git \
#     supervisor \
#     nano \
#     openssh-server \
#     ca-certificates \
#     gnupg \
#     libonig-dev \
#     libzip-dev \
#     && rm -rf /var/lib/apt/lists/*

# # Install Node.js 20
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
#     && apt-get install -y nodejs

# # Konfigurasi Nginx
# COPY nginx/default.conf /etc/nginx/sites-available/default
# RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# # Instal dan konfigurasi ekstensi PHP
# RUN docker-php-ext-install pdo pdo_mysql

# # Konfigurasi SSH
# RUN mkdir -p /var/run/sshd && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# # Definisikan ARG untuk User SSH (agar bisa diubah saat build)
# ARG SSH_USER=developer
# ARG SSH_PASSWORD=@Dev5kwn24

# # Buat user SSH hanya jika belum ada
# RUN if ! id "$SSH_USER" >/dev/null 2>&1; then \
#     useradd -m -s /bin/bash "$SSH_USER" && \
#     echo "$SSH_USER:$SSH_PASSWORD" | chpasswd && \
#     usermod -aG sudo "$SSH_USER"; \
#     fi

# # Konfigurasi Supervisor
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# # Copy project ke dalam container
# COPY www /var/www/html

# # Expose ports
# EXPOSE 80 443 22

# # Jalankan entrypoint
# CMD ["/entrypoint.sh"]

#  phase 3

# Gunakan image resmi PHP 8.3 dengan FPM
FROM php:8.3-fpm

# Set DEBIAN_FRONTEND agar tidak ada prompt interaktif
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-utils \
    nginx \
    curl \
    unzip \
    git \
    supervisor \
    nano \
    openssh-server \
    ca-certificates \
    gnupg \
    libonig-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Konfigurasi Nginx
COPY nginx/default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Instal dan konfigurasi ekstensi PHP
RUN docker-php-ext-install pdo pdo_mysql zip mbstring

# Konfigurasi SSH
RUN mkdir -p /var/run/sshd && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Definisikan ARG untuk User SSH (agar bisa diubah saat build)
ARG SSH_USER=developer
ARG SSH_PASSWORD=@Dev5kwn24

# Buat user SSH hanya jika belum ada
RUN if ! id "$SSH_USER" >/dev/null 2>&1; then \
    useradd -m -s /bin/bash "$SSH_USER" && \
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd && \
    usermod -aG sudo "$SSH_USER"; \
    fi

# Konfigurasi Supervisor
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy project ke dalam container
COPY www /var/www/html

# Set permission agar PHP-FPM dapat mengakses file
RUN chown -R www-data:www-data /var/www/html

# Expose ports
EXPOSE 80 443 22

# Jalankan entrypoint
CMD ["/entrypoint.sh"]
