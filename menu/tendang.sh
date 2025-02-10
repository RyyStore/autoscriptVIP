#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/jvoscript/permission/main/ip"
checking_sc() {
useexp=$(curl -sS $data_ip | grep $ipsaya | awk '{print $3}')
if [[ $date_list < $useexp ]]; then
echo -ne
else
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •               ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "            ${RED}PERMISSION DENIED !${NC}"
echo -e "   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}"
echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
echo -e "             \033[0;33mContact Admin :${NC}"
echo -e "     \033[0;36mTelegram${NC}: https://t.me/masansor"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
exit
fi
}
checking_sc
rm -rf /tmp/ssh
clear
bash2=$( pgrep bash | wc -l )
if [[ $bash2 -gt "20" ]]; then
killall bash
fi
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domen=`cat /etc/xray/domain`
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
type=$(cat /etc/typessh)
waktulock=$(cat /etc/waktulockssh)
if [[ -z ${waktulock} ]]; then
echo "15" > /etc/waktulockssh
fi
if [[ -z ${type} ]]; then
echo "delete" > /etc/typessh
fi
MAX=$limitip
if [ -e "/var/log/auth.log" ]; then
OS=1;
LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
OS=2;
LOG="/var/log/secure";
fi
if [ $OS -eq 1 ]; then
service sshd restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
service sshd restart > /dev/null 2>&1;
fi
service dropbear restart > /dev/null 2>&1;
if [[ ${1+x} ]]; then
MAX=$limitip;
fi
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/user.txt
username1=( `cat "/etc/user.txt" `);
i="0";
for user in "${username1[@]}"
do
username[$i]=`echo $user | sed 's/'\''//g'`;
jumlah[$i]=0;
i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
limitip=$(cat /etc/xray/sshx/${username[$i]}IP)
if [[ ${jumlah[$i]} -gt $limitip ]]; then
date=`date +"%Y-%m-%d %X"`;
echo "$date - ${username[$i]} - ${jumlah[$i]}" >> /etc/xray/sshx/${username[$i]}login;
sship=$(cat /etc/xray/sshx/${username[$i]}login | wc -l)
sship2=$(cat /tmp/ssh | grep -w "${username[$i]}" | cut -d ' ' -f 2-8 | nl -s '. ' )
ssssh1=$(ls "/etc/xray/sshx" | grep -w "notif")
if [[ -z ${sssh1} ]]; then
ssssh="3"
else
ssssh=$(cat /etc/xray/sshx/notif)
fi
if [ $sship = $ssssh ]; then
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
systemctl restart ws-stunnel > /dev/null 2>&1
systemctl restart ws-dropbear > /dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Lock Account $waktulockssh Minutes...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
cat> /etc/cron.d/ssh${username[$i]}<< EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulockssh * * * * root /usr/bin/xray ssh ${username[$i]} $pass $exp
EOF
systemctl restart ws-stunnel > /dev/null 2>&1
restart service cron > /dev/null 2>&1
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${sship}x Multi Login : ${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $sship -gt $ssssh ]; then
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
sed -i "/^### ${username[$i]} $exp $pass/d" /etc/xray/ssh
cd
rm -rf /etc/xray/sshx/${username[$i]}login
systemctl restart ws-stunnel > /dev/null 2>&1
systemctl restart ws-dropbear > /dev/null 2>&1
fi
j=`expr $j + 1`;
fi
done
if [ $j -gt 0 ]; then
if [ $OS -eq 1 ]; then
service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
service sshd restart > /dev/null 2>&1;
fi
service dropbear restart > /dev/null 2>&1;
j=0;
fi RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/jvoscript/permission/main/ip"
checking_sc() {
useexp=$(curl -sS $data_ip | grep $ipsaya | awk '{print $3}')
if [[ $date_list < $useexp ]]; then
echo -ne
else
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •               ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "            ${RED}PERMISSION DENIED !${NC}"
echo -e "   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}"
echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
echo -e "             \033[0;33mContact Admin :${NC}"
echo -e "     \033[0;36mTelegram${NC}: https://t.me/rmblvpn1"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
exit
fi
}
checking_sc
rm -rf /tmp/ssh
clear
bash2=$( pgrep bash | wc -l )
if [[ $bash2 -gt "20" ]]; then
killall bash
fi
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domen=`cat /etc/xray/domain`
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
type=$(cat /etc/typessh)
waktulock=$(cat /etc/waktulockssh)
if [[ -z ${waktulock} ]]; then
echo "15" > /etc/waktulockssh
fi
if [[ -z ${type} ]]; then
echo "delete" > /etc/typessh
fi
MAX=$limitip
if [ -e "/var/log/auth.log" ]; then
OS=1;
LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
OS=2;
LOG="/var/log/secure";
fi
if [ $OS -eq 1 ]; then
service sshd restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
service sshd restart > /dev/null 2>&1;
fi
service dropbear restart > /dev/null 2>&1;
if [[ ${1+x} ]]; then
MAX=$limitip;
fi
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/user.txt
username1=( `cat "/etc/user.txt" `);
i="0";
for user in "${username1[@]}"
do
username[$i]=`echo $user | sed 's/'\''//g'`;
jumlah[$i]=0;
i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
limitip=$(cat /etc/xray/sshx/${username[$i]}IP)
if [[ ${jumlah[$i]} -gt $limitip ]]; then
date=`date +"%Y-%m-%d %X"`;
echo "$date - ${username[$i]} - ${jumlah[$i]}" >> /etc/xray/sshx/${username[$i]}login;
sship=$(cat /etc/xray/sshx/${username[$i]}login | wc -l)
sship2=$(cat /tmp/ssh | grep -w "${username[$i]}" | cut -d ' ' -f 2-8 | nl -s '. ' )
ssssh1=$(ls "/etc/xray/sshx" | grep -w "notif")
if [[ -z ${sssh1} ]]; then
ssssh="3"
else
ssssh=$(cat /etc/xray/sshx/notif)
fi
if [ $sship = $ssssh ]; then
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
systemctl restart ws-stunnel > /dev/null 2>&1
systemctl restart ws-dropbear > /dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Lock Account $waktulockssh Minutes...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
cat> /etc/cron.d/ssh${username[$i]}<< EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulockssh * * * * root /usr/bin/xray ssh ${username[$i]} $pass $exp
EOF
systemctl restart ws-stunnel > /dev/null 2>&1
restart service cron > /dev/null 2>&1
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${sship}x Multi Login : ${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $sship -gt $ssssh ]; then
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
passq"      dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/jvoscript/permission/main/ip"
checking_sc() {
useexp=$(curl -sS $data_ip | grep $ipsaya | awk '{print $3}')
if [[ $date_list < $useexp ]]; then
echo -ne
else
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •               ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "            ${RED}PERMISSION DENIED !${NC}"
echo -e "   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}"
echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
echo -e "             \033[0;33mContact Admin :${NC}"
echo -e "     \033[0;36mTelegram${NC}: https://t.me/Rmblvpn1"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
exit
fi
}
checking_sc
rm -rf /tmp/ssh
clear
bash2=$( pgrep bash | wc -l )
if [[ $bash2 -gt "20" ]]; then
killall bash
fi
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domen=`cat /etc/xray/domain`
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
type=$(cat /etc/typessh)
waktulock=$(cat /etc/waktulockssh)
if [[ -z ${waktulock} ]]; then
echo "15" > /etc/waktulockssh
fi
if [[ -z ${type} ]]; then
echo "delete" > /etc/typessh
fi
MAX=$limitip
if [ -e "/var/log/auth.log" ]; then
OS=1;
LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
OS=2;
LOG="/var/log/secure";
fi
if [ $OS -eq 1 ]; then
service sshd restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
service sshd restart > /dev/null 2>&1;
fi
service dropbear restart > /dev/null 2>&1;
if [[ ${1+x} ]]; then
MAX=$limitip;
fi
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/user.txt
username1=( `cat "/etc/user.txt" `);
i="0";
for user in "${username1[@]}"
do
username[$i]=`echo $user | sed 's/'\''//g'`;
jumlah[$i]=0;
i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
limitip=$(cat /etc/xray/sshx/${username[$i]}IP)
if [[ ${jumlah[$i]} -gt $limitip ]]; then
date=`date +"%Y-%m-%d %X"`;
echo "$date - ${username[$i]} - ${jumlah[$i]}" >> /etc/xray/sshx/${username[$i]}login;
sship=$(cat /etc/xray/sshx/${username[$i]}login | wc -l)
sship2=$(cat /tmp/ssh | grep -w "${username[$i]}" | cut -d ' ' -f 2-8 | nl -s '. ' )
ssssh1=$(ls "/etc/xray/sshx" | grep -w "notif")
if [[ -z ${sssh1} ]]; then
ssssh="3"
else
ssssh=$(cat /etc/xray/sshx/notif)
fi
if [ $sship = $ssssh ]; then
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
systemctl restart ws-stunnel > /dev/null 2>&1
systemctl restart ws-dropbear > /dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${ssssh}x Multi Login Lock Account $waktulockssh Minutes...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
cd
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
cd
rm -rf /etc/xray/sshx/${username[$i]}login
cat> /etc/cron.d/ssh${username[$i]}<< EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulockssh * * * * root /usr/bin/xray ssh ${username[$i]} $pass $exp
EOF
systemctl restart ws-stunnel > /dev/null 2>&1
restart service cron > /dev/null 2>&1
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b> ⚠️ SSH NOTIF MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : $CITY</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : ${username[$i]} </b>
<b>TOTAL LOGIN IP : ${jumlah[$i]} </b>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<b>TIME LOGIN : IP LOGIN </b>
<code>$sship2</code>
<code>◇━━━━━━━━━━━━━━━━◇</code>
<i>${sship}x Multi Login : ${ssssh}x Multi Login Auto Lock Account...</i>
"
sed -i "/${username[$i]}/d" /var/log/auth.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $sship -gt $ssssh ]; then
exp=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
pass=$(grep -i "### ${username[$i]}" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
echo "### ${username[$i]} $exp $pass" >> /etc/xray/sshx/listlock
passwd -l ${username[$i]}
sed -i "/^### ${username[$i]} $exp $pass/d" /etc/xray/ssh
cd
rm -rf /etc/xray/sshx/${username[$i]}login
systemctl restart ws-stunnel > /dev/null 2>&1
systemctl restart ws-dropbear > /dev/null 2>&1
fi
j=`expr $j + 1`;
fi
done
if [ $j -gt 0 ]; then
if [ $OS -eq 1 ]; then
service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
service sshd restart > /dev/null 2>&1;
fi
service dropbear restart > /dev/null 2>&1;
j=0;
fi
