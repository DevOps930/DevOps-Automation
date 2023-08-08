#!/bin/bash
machinename=$(uname -n)
df -h | grep -vE '' | tail -n +1 | sed s/%//g | awk '{ print $0 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $5}' | cut -d'%' -f1  )
  Size=$(echo $output | awk '{print $2}' )
  free=$(echo $output | awk '{ print$4 }' )
  partition=$(echo $output | awk  '{ print$1 }' )
  Mnt=$(echo $output | awk '{print $6}' )

#send an email
  if [ $usep -ge 90 ]; then
            -F from='Enter sender email address' \
            -F to='Enter receiver email address' \
            -F subject="High disk usage on $machinename" \
            -F text="Filesystem $partition mounted on $Mnt is using $usep% and has free space $free while total size of disk is $Size." \
            -F h:X-Priority=1 > /dev/null
  fi
done
