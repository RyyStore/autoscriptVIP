#!/bin/bash
user="$2"

user2=$(grep -wE "^#vl $user" "/etc/xray/config.json" | cut -d ' ' -f 2 | sort | uniq)
exp=$(grep -wE "^#vl $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)

sed -i "/^#vl $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $user $exp/,/^},{/d" /etc/xray/config.json
rm -rf /var/www/html/vless-$user.txt
rm -rf /etc/vless/${user}IP
rm -rf /etc/vless/${user}login
rm -rf /etc/cron.d/trialvless$user
systemctl restart xray