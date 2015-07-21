FROM ubuntu:14.04.2
MAINTAINER Patrick Double <pat@patdouble.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -q update &&\
  apt-get -qy --force-yes dist-upgrade &&\
  apt-get install -qy --force-yes squid dansguardian wget cron psmisc &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

# blacklist update
ADD blacklist/blacklist-update.sh /blacklist-update.sh
RUN chmod u+x /blacklist-update.sh && ln -s /blacklist-update.sh /etc/cron.weekly/blacklist-update.sh && /bin/sh -x /blacklist-update.sh

# squid config
COPY squid/* /etc/squid3/
# dansguardian config
RUN sed -i -e 's/filterport.*/filterport = 3128/' -e 's/proxyport.*/proxyport = 8123/' /etc/dansguardian/dansguardian.conf

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

VOLUME /blacklists
VOLUME /cache
VOLUME /log

# 3128 is the content filtered proxy port
# 8123 is the caching only proxy port
# 8124 is the transparent caching only proxy port
EXPOSE 3128 8123 8124

CMD ["/start.sh"]

