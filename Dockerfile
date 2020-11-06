FROM php:7-cli

RUN apt-get update \
    && apt-get install -y git libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

WORKDIR /app

ADD . .

RUN groupadd -r escpos && useradd escpos -m -r -g escpos \
    && chown -R escpos:escpos /home/escpos \
    && chown -R escpos:escpos /app

USER escpos

RUN composer install

CMD php esc2text.php ./receipt-with-logo.bin