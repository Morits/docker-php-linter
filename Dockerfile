FROM php:7.3.4-cli
RUN apt update && DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" -y install sudo git unzip
RUN mkdir -p /app; chown www-data:www-data /app; chown www-data:www-data /var/www; mkdir -p /usr/local/composer
RUN curl -sS https://getcomposer.org/download/1.8.5/composer.phar -o /usr/local/composer/composer.phar
RUN sha=`shasum -a 256 /usr/local/composer/composer.phar | awk '{print $1}'`; \
	if [ "$sha" = "4e4c1cd74b54a26618699f3190e6f5fc63bb308b13fa660f71f2a2df047c0e17" ]; then \
	printf '#!/bin/sh\n/usr/bin/sudo -u www-data /usr/local/bin/php /usr/local/composer/composer.phar $@' > /usr/local/bin/composer; \
	chmod +x /usr/local/bin/composer; \
	fi;
WORKDIR /app
COPY . .
RUN composer require --dev jakub-onderka/php-parallel-lint; \
composer require --dev jakub-onderka/php-console-highlighter; \
composer require --dev "squizlabs/php_codesniffer=*"; \
composer require --dev phpstan/phpstan