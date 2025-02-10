#!/bin/bash

user="$2"


userdel -f $user
exp=$(grep -wE "^### $user" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -wE "^### $user" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
sed -i "s/### $user $exp $pass//g" /etc/xray/ssh 
rm -rf /var/www/html/ssh-$user.txt
rm -rf /etc/xray/sshx/${user}IP
rm -rf /etc/xray/sshx/${user}login
rm -rf /etc/cron.d/trialssh$user
systemctl restart sshd