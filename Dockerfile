FROM centos

#MAINTAINER Gonéri Le Bouder <goneri@lebouder.net>
MAINTAINER Fred Tesche <fred@fakecomputermusic.com>

USER root
WORKDIR /opt
RUN yum -y update && yum clean all
RUN yum install -y epel-release yum-utils
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php71
RUN yum -y update
RUN yum install -y git nginx php-fpm php composer crudini
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/bolt.cm.conf /etc/nginx/conf.d/bolt.cm.conf
RUN git clone git://github.com/bolt/bolt.git --depth=1 --branch v3.6.9
WORKDIR /opt/bolt
RUN composer update --no-dev
RUN crudini --set /etc/php-fpm.conf global error_log syslog
RUN crudini --set /etc/php-fpm.d/www.conf www chdir "/opt/bolt"
RUN crudini --del /etc/php-fpm.d/www.conf www listen.allowed_client
RUN crudini --set --existing /etc/php-fpm.d/www.conf www user nginx
RUN crudini --set --existing /etc/php-fpm.d/www.conf www group nginx
RUN crudini --set --existing /etc/php.ini PHP upload_max_filesize 1G
RUN yum remove -y crudini
RUN yum clean all
RUN systemctl enable nginx
RUN systemctl enable php-fpm
RUN chown -R nginx:nginx /opt/bolt/app/config /opt/bolt/app/cache /opt/bolt/app/database /opt/bolt/files /opt/bolt/extensions /opt/bolt/theme
VOLUME ["/opt/bolt/app/config", "/opt/bolt/app/database", "/opt/bolt/files", "/opt/bolt/extensions"]
