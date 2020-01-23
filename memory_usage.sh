#!/bin/sh
ram_current=$(free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}')
ram_usage=$(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
disk_usage=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')
cpu_usage=$(top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}')

if [ "${ram_current%.*}" -lt 50 ]; then

SUBJECT="ATTENTION: Memory Utilization is $ram_current % for $(hostname) at $(date)"

MESSAGE="/tmp/Mail.out"

TO="cm.gan@myeg.com.my"

  echo "Current System Resource Utilization Is:\n\n $ram_usage \n $disk_usage \n $cpu_usage" >> $MESSAGE

  echo "" >> $MESSAGE

  echo "------------------------------------------------------------------" >> $MESSAGE

  echo "Top Memory Consuming Process" >> $MESSAGE

  echo "------------------------------------------------------------------" >> $MESSAGE

  echo "$(top -b -o +%MEM | head -n 20 | sed 1,6d)" >> $MESSAGE

  echo "" >> $MESSAGE

  echo "------------------------------------------------------------------" >> $MESSAGE

  echo "Last 20 Lines of Syslog" >> $MESSAGE

  echo "------------------------------------------------------------------" >> $MESSAGE

  echo "$(tail -n 20 /var/log/syslog)" >> $MESSAGE

  echo "" >> $MESSAGE

  echo "------------------------------------------------------------------" >> $MESSAGE


  mail -s "$SUBJECT" "$TO" < $MESSAGE

  rm /tmp/Mail.out

  fi
