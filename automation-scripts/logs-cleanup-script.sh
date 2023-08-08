#!/bin/bash

cd /mnt/logs/application

#zip up all log files older than one day
for f in $(find . -daystart -mtime 1 | grep -v .gz)
do
  gzip  $f
done

#move all logs older than 14 days off of the server
machinename=$(uname -n)
dir=/mnt/logs/application
for f in $(find $dir -name '*.gz' -mtime +14)
do
 sudo aws s3 mv $f s3://application/server-logs/$machinename/$f --quiet
done
