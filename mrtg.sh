#!/bin/sh -e

COMM=$1
HOST=$2
MRTGDIR=/etc/mrtg
WORKDIR=/usr/share/nginx/html
CONFIG=$MRTGDIR/mrtg.cfg
NAME=$(snmpwalk -Oqv -v2c -c $COMM $HOST .1.3.6.1.2.1.1.5)

rm -rf $CONFIG
(cd $MRTGDIR/conf.d; for conf in `ls ??-* |sort`; do . ./$conf >> $CONFIG; done)

mkdir -p $WORKDIR
env LANG=C /usr/bin/mrtg $CONFIG
env LANG=C /usr/bin/mrtg $CONFIG
env LANG=C /usr/bin/mrtg $CONFIG
/usr/bin/indexmaker --columns=1 $CONFIG > $WORKDIR/index.html
chown -R nginx:nginx $WORKDIR

/usr/sbin/nginx &
NGINX=$!

/usr/sbin/crond -f &
CROND=$!

trap "kill $NGINX $CROND" SIGINT SIGHUP SIGTERM SIGQUIT EXIT
wait
