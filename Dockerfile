FROM ubuntu:14.04
MAINTAINER Zheng Xie <xie.zheng@seafile.com>

RUN apt-get update
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales
RUN apt-get install -y sudo wget python-pip python-setuptools python-imaging python-mysqldb python-ldap python-urllib3 \
openjdk-7-jre memcached python-memcache pwgen curl openssl poppler-utils libpython2.7 libreoffice \
libreoffice-script-provider-python ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy nginx

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

WORKDIR /root
ADD . /root/

ADD https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_5.1.10_x86-64.tar.gz&dl=1 /opt/seafile-pro-server_5.1.10_x86-64.tar.gz

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://raw.githubusercontent.com/haiwen/seafile-server-installer-cn/master/seafile-server-ubuntu-14-04-amd64-http /opt/seafile-server-ubuntu-14-04-amd64-http

RUN export TERM=xterm && echo 2 | bash /opt/seafile-server-ubuntu-14-04-amd64-http 5.1.10

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
