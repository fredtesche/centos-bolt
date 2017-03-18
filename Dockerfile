FROM centos

MAINTAINER Gonéri Le Bouder <goneri@lebouder.net>

USER root
WORKDIR /srv
RUN yum -y update && yum clean all
RUN yum install -y epel-release yum-utils
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php71
RUN yum -y update
RUN yum install -y git nginx php-fpm php composer crudini
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/bolt.cm.conf /etc/nginx/conf.d/bolt.cm.conf
RUN git clone git://github.com/bolt/bolt.git --depth=1 --branch v3.2.9
WORKDIR /srv/bolt
RUN composer update --no-dev
RUN crudini --set /etc/php-fpm.conf global error_log syslog
RUN crudini --set /etc/php-fpm.d/www.conf www chdir "/srv/bolt"
RUN crudini --del /etc/php-fpm.d/www.conf www listen.allowed_client
RUN yum remove -y crudini
RUN yum clean all
RUN systemctl enable nginx
RUN systemctl enable php-fpm
RUN chown -R apache:apache /srv/bolt/app/config /srv/bolt/app/cache /srv/bolt/app/database /srv/bolt/files /srv/bolt/extensions /srv/bolt/theme
VOLUME ["/srv/bolt/app/config", "/srv/bolt/app/database", "/srv/bolt/files", "/srv/bolt/extensions"]
