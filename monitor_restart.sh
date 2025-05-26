#!/bin/bash

# Use crontab to run this script every 10 minutes
# */10 * * * * /opt/mailcow-dockerized/monitor_restart.sh

# aoa As rspamd ofter uses 100% CPU and hangs the whole system,
# this script will restart mailcow if it is over 90% for > 1 minute

rspam_dload=`docker stats --no-stream --format "table {{.CPUPerc}}\t{{.Name}}" | grep rspamd | sed 's/^\([0-9]\+\(\.[0-9]\+\)\?\).*$/\1/'`
# printf -v int %.0f "$rspam_dload"
rspam_dload=${rspam_dload%.*}
if [ $rspam_dload -gt 90 ]; then
  # Wait for 60 seconds and check again
  sleep 60
  rspam_dload=`docker stats --no-stream --format "table {{.CPUPerc}}\t{{.Name}}" | grep rspamd | sed 's/^\([0-9]\+\(\.[0-9]\+\)\?\).*$/\1/'`
  # printf -v int %.0f "$rspam_dload"
  rspam_dload=${rspam_dload%.*}
  if [ $rspam_dload -gt 90 ]; then
    cd /opt/mailcow-dockerized
    /usr/local/bin/docker-compose -f /opt/mailcow-dockerized/docker-compose.yml restart
    # sleep 60
    # docker-compose up -d
    sleep 60
    echo `date` "mailcow restarted $rspam_dload" >> /root/restart.log
  fi
fi

echo "load was $rspam_dload"
