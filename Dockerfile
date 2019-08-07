FROM php:7.3-fpm-alpine

RUN apk update && apk upgrade && apk add --update \
    zip \
    unzip \
    bash \
    curl \
    procps \
    git \
    vim \
    nginx \
    nodejs \
    npm

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install yarn
RUN npm install -g yarn

# Set the working directory to /var/www
RUN mkdir -p /var/www
RUN mkdir -p /run/nginx
WORKDIR /var/www

# Clear any existing config
RUN rm /etc/nginx/conf.d/*
RUN rm /usr/local/etc/php-fpm.d/*.conf

# Copy over the config
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php/php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/server.conf /etc/nginx/conf.d/server.conf

# Copy over the entrypoint
COPY bin/start.sh /usr/bin/start
RUN chmod +x /usr/bin/start

VOLUME /var/www

STOPSIGNAL SIGTERM
EXPOSE 80
CMD ["start"]