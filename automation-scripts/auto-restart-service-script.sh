send_email(){
  machinename=$(uname -n)
  ip=$(ip -4 -o addr show dev eth0| awk '{split($4,a,"/");print a[1]}')

          -F from='Enter sender email address' \
          -F to='Enter receiver email address' \
          -F subject="Application restart on $machinename ($ip)" \
          -F text="$1" \
          -F h:X-Priority=1 > /dev/null
}

if test `find /tmp -name "cpulock" -mmin -10`
then
    exit 0
elif test `find /tmp -name "cpulock" -mmin +10`
then
    rm /tmp/cpulock
fi

application_pid=$(cat /var/run/application/application.pid)

if [ -n "$application_pid" ]; then
        http_response=$(curl -m 20 -o /dev/null --silent --write-out '%{http_code}'  http://localhost:9090/health)
        if [ $http_response != "200" ]; then
                kill -9 $application_pid
                sleep 2
                echo $(/etc/init.d/application start) > /tmp/applicationstart.txt
                echo $(/etc/init.d/application status) >> /tmp/applicationstatus.txt
                date > /tmp/cpulock
                send_email "Application Restarted"
                exit
        fi

fi
