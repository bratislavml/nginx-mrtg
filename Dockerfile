FROM alpine
MAINTAINER haruhiko Uchida <harre.orz@gmail.com>

RUN apk add --update --no-cache tzdata net-snmp-tools mrtg dcron nginx
ADD mrtg.sh /usr/sbin/mrtg.sh
ADD mrtg.cron /etc/crontabs/root
ADD nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/usr/sbin/mrtg.sh"]
CMD ["public", "172.17.0.1"]
