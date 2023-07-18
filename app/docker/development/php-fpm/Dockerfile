FROM php:7.4-fpm-alpine

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN addgroup -g 1000 app && adduser -u 1000 -G app -s /bin/sh -D app

WORKDIR /app

#COPY ./ ./

COPY ./entrypoint.sh /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/docker-php-entrypoint
