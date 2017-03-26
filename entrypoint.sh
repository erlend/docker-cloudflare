#!/bin/sh
log=/var/log/cloudflare.log

rm -f /etc/env
for varname in `env | grep -o "^[A-Z_0-9]*"`; do
  echo "$varname=\"`printenv $varname`\"" >> /etc/env
done

crontab -u cloudflare - <<-EOF
$CRON_PATTERN /update_cf.sh >> $log 2>&1
EOF

if [ -z "$1" ]; then
  touch $log
  chown cloudflare $log
  tail -f $log &
  crond -f
else
  exec $@
fi
