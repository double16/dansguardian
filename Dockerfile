FROM ubuntu:14.04.3
MAINTAINER Patrick Double <pat@patdouble.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -q update &&\
  apt-get -qy --force-yes dist-upgrade &&\
  apt-get install -qy --force-yes squid dansguardian apache2 sarg wget cron psmisc &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

# blacklist update
ADD blacklist/blacklist-update.sh /blacklist-update.sh
RUN chmod u+x /blacklist-update.sh && ln -s /blacklist-update.sh /etc/cron.weekly/blacklist-update.sh && /bin/sh -x /blacklist-update.sh && cp /blacklists/banned*list /etc/dansguardian/lists/

# squid config
COPY squid/* /etc/squid3/
# sarg (squid access reports) config
RUN sed -i -e 's/output_dir .*/output_dir \/log\/sarg/' -e 's/access_log .*/access_log \/log\/dansguardian\/access.log/' -e 's/resolve_ip/#resolve_ip/' /etc/sarg/sarg.conf && sed -i -e 's/HTMLOUT=.*/HTMLOUT=\/log\/sarg/' /etc/sarg/sarg-reports.conf && ln -sf /log/sarg /var/www/html/reports
# dansguardian config
RUN sed -i -e 's/filterport.*/filterport = 3128/' -e 's/proxyport.*/proxyport = 8123/' -e 's/logfileformat.*/logfileformat = 3/' -e 's/#loglocation.*/loglocation = \/log\/dansguardian\/access.log/' -e 's/UNCONFIGURED/#UNCONFIGURED/' /etc/dansguardian/dansguardian.conf
# apache conf
RUN sed -i "s/Listen 80/Listen 8125/" /etc/apache2/ports.conf && sed -i "s/:80>/:8125>/" /etc/apache2/sites-enabled/000-default.conf
RUN ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

VOLUME /blacklists
VOLUME /cache
VOLUME /log

# 3128 is the content filtered proxy port
# 8123 is the caching only proxy port
# 8124 is the transparent caching only proxy port
# 8125 is the apache2 port serving the access denied page
EXPOSE 3128 8123 8124 8125

CMD ["/start.sh"]

