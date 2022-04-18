FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qqy dist-upgrade && \
    apt-get -qqy install software-properties-common apt-transport-https ruby-bundler sudo git subversion unzip zip bzip2 default-mysql-client postgresql-client apache2 && \
    rm -fr /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN add-apt-repository -y -u ppa:ondrej/php

RUN apt-get -qq update ; \
    for x in bcmath cli common curl dev gd igbinary imap json ldap mailparse mbstring mysql opcache pgsql readline redis snmp soap sqlite3 ssh2 xml xmlrpc zip; do \
#         apt-get -qqy install php7.1-${x} php7.2-${x} php7.3-${x} php7.4-${x}; \
         apt-get -qqy install php5.6-${x}; \
    done; \
    apt-get install -qqy libapache2-mod-php5.6 && \
    rm -fr /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN curl -Lso /usr/local/bin/composer https://getcomposer.org/composer-1.phar && chmod +x /usr/local/bin/composer

RUN a2enmod deflate expires filter headers mime php5.6 proxy proxy_http rewrite 

RUN rm -f /var/log/apache2/access.log /var/log/apache2/error.log && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log


COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/apache2", "-k", "start", "-D", "FOREGROUND"]
