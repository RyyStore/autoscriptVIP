#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ipinfo.io/ip)
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
echo -e "             \033[0;33mContact Your Admin ${NC}"
echo -e "     \033[0;36mTelegram${NC}: https://t.me/masansor"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
exit
fi
}
checking_sc
cd
bash2=$( pgrep bash | wc -l )
if [[ $bash2 -gt "20" ]]; then
killall bash
fi
inaIP=$(wget -qO- ipv4.icanhazip.com)
timenow=$(date +%T" WIB")
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domen=`cat /etc/xray/domain`
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
author=$(cat /etc/profil)
type=$(cat /etc/typexray)
waktulock=$(cat /etc/waktulock)
if [[ -z ${waktulock} ]]; then
echo "15" > /etc/waktulock
fi
if [[ -z ${type} ]]; then
echo "delete" > /etc/typexray
fi
tim2sec() {
mult=1
arg="$1"
inu=0
while [ ${#arg} -gt 0 ]; do
prev="${arg%:*}"
if [ "$prev" = "$arg" ]; then
curr="${arg#0}"
prev=""
else
curr="${arg##*:}"
curr="${curr#0}"
fi
curr="${curr%.*}"
inu=$((inu + curr * mult))
mult=$((mult * 60))
arg="$prev"
done
echo "$inu"
}
function convert() {
local -i bytes=$1
if [[ $bytes -lt 1024 ]]; then
echo "${bytes} B"
elif [[ $bytes -lt 1048576 ]]; then
echo "$(((bytes + 1023) / 1024)) KB"
elif [[ $bytes -lt 1073741824 ]]; then
echo "$(((bytes + 1048575) / 1048576)) MB"
else
echo "$(((bytes + 1073741823) / 1073741824)) GB"
fi
}
function vmess() {
cd
if [[ ! -e /etc/limit/vmess ]]; then
mkdir -p /etc/limit/vmess
fi
vm=($(cat /etc/xray/config.json | grep "^#vmg" | awk '{print $2}' | sort -u))
echo -n >/tmp/vm
for db1 in ${vm[@]}; do
logvm=$(cat /var/log/xray/access.log | grep -w "email: ${db1}" | tail -n 150)
while read a; do
if [[ -n ${a} ]]; then
set -- ${a}
ina="${7}"
inu="${2}"
anu="${3}"
enu=$(echo "${anu}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
now=$(tim2sec ${timenow})
client=$(tim2sec ${inu})
nowt=$(((${now} - ${client})))
if [[ ${nowt} -lt 40 ]]; then
cat /tmp/vm | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/vm
splvm=$(cat /tmp/vm)
fi
fi
fi
done <<<"${logvm}"
done
if [[ ${splvm} != "" ]]; then
for vmuser in ${vm[@]}; do
vmhas=$(cat /tmp/vm | grep -w "${vmuser}" | wc -l)
vmhas2=$(cat /tmp/vm | grep -w "${vmuser}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
vmsde=$(ls "/etc/vmess" | grep -w "${vmuser}IP")
if [[ -z ${vmsde} ]]; then
vmip="0"
else
vmip=$(cat /etc/vmess/${vmuser}IP)
fi
if [[ ${vmhas} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/vmess/${vmuser} ]; then
echo "${downlink}" > /etc/limit/vmess/${vmuser}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/vmess/${vmuser})
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/vmess/${vmuser}
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/vmess/${vmuser}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
if [ ! -e /etc/vmess/${vmuser} ]; then
echo "999999999999" > /etc/vmess/${vmuser}
fi
limit=$(cat /etc/vmess/${vmuser})
usage=$(cat /etc/limit/vmess/${vmuser})
if [ $usage -gt $limit ]; then
exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vmuser $exp $uuid" >> /etc/vmess/userQuota
sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
rm /etc/limit/vmess/${vmuser} >/dev/null 2>&1
systemctl restart xray
fi
fi
if [[ ${vmhas} -gt $vmip ]]; then
byt=$(cat /etc/limit/vmess/$vmuser)
gb=$(convert ${byt})
echo "$vmuser ${vmhas}" >> /etc/vmess/${vmuser}login
vmessip=$(cat /etc/vmess/${vmuser}login | wc -l)
ssvmess1=$(ls "/etc/vmess" | grep -w "notif")
if [[ -z ${ssvmess1} ]]; then
ssvmess="3"
else
ssvmess=$(cat /etc/vmess/notif)
fi
if [ $vmessip = $ssvmess ]; then
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VMESS MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vmuser </b>
<b>TOTAL LOGIN IP : ${vmhas} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vmhas2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${ssvmess}x Multi Login Lock Account $waktulock Minutes...</i>
"
echo "" > /tmp/vm
sed -i "/${vmuser}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
rm /etc/vmess/${vmuser}login >/dev/null 2>&1
cat> /etc/cron.d/vmess${vmuser} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray vmess $vmuser $uuid $exp
EOF
systemctl restart xray
service cron restart
fi
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VMESS MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vmuser </b>
<b>TOTAL LOGIN IP : ${vmhas} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vmhas2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${ssvmess}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/vm
sed -i "/${vmuser}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
rm /etc/vmess/${vmuser}login >/dev/null 2>&1
systemctl restart xray
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VMESS MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vmuser </b>
<b>TOTAL LOGIN IP : ${vmhas} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vmhas2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${vmessip}x Multi Login : ${ssvmess}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/vm
sed -i "/${vmuser}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $vmessip -gt $ssvmess ]; then
exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
rm /etc/vmess/${vmuser}login >/dev/null 2>&1
systemctl restart xray
fi
fi
done
fi
}
function vless() {
cd
if [[ ! -e /etc/limit/vless ]]; then
mkdir -p /etc/limit/vless
fi
vldat=($(cat /etc/xray/config.json | grep "^#vlg" | awk '{print $2}' | sort -u))
echo -n >/tmp/vl
for db2 in ${vldat[@]}; do
logvl=$(cat /var/log/xray/access.log | grep -w "email: ${db2}" | tail -n 150)
while read a; do
if [[ -n ${a} ]]; then
set -- ${a}
ina="${7}"
inu="${2}"
anu="${3}"
enu=$(echo "${anu}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
now=$(tim2sec ${timenow})
client=$(tim2sec ${inu})
nowt=$(((${now} - ${client})))
if [[ ${nowt} -lt 40 ]]; then
cat /tmp/vl | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/vl
spll=$(cat /tmp/vl)
fi
fi
fi
done <<<"${logvl}"
done
if [[ ${spll} != "" ]]; then
for vlus in ${vldat[@]}; do
vlsss=$(cat /tmp/vl | grep -w "${vlus}" | wc -l)
vlsss2=$(cat /tmp/vl | grep -w "${vlus}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
sdf=$(ls "/etc/vless" | grep -w "${vlus}IP")
if [[ -z ${sdf} ]]; then
vmip="0"
else
vmip=$(cat /etc/vless/${vlus}IP)
fi
if [[ ${vlsss} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/vless/${vlus} ]; then
echo "${downlink}" > /etc/limit/vless/${vlus}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/vless/${vlus})
cd
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/vless/${vlus}
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/vless/${vlus}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
cd
if [ ! -e /etc/vless/${vlus} ]; then
echo "999999999999" > /etc/vless/${vlus}
fi
limit=$(cat /etc/vless/${vlus})
usage=$(cat /etc/limit/vless/${vlus})
if [ $usage -gt $limit ]; then
expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vlus $expvl $uuidvl" >> /etc/vless/userQuota
sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
rm /etc/limit/vless/${vlus} >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
if [[ ${vlsss} -gt $vmip ]]; then
byt=$(cat /etc/limit/vless/$vlus)
gb=$(convert ${byt})
echo "$vlus ${vlsss}" >> /etc/vless/${vlus}login
vlessip=$(cat /etc/vless/${vlus}login | wc -l)
ssvless1=$(ls "/etc/vless" | grep -w "notif")
if [[ -z ${ssvless1} ]]; then
ssvless="3"
else
ssvless=$(cat /etc/vless/notif)
fi
if [ $vlessip = $ssvless ]; then
echo -ne
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VLESS MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vlus </b>
<b>TOTAL LOGIN IP : ${vlsss} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vlsss2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${ssvless}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/vl
sed -i "/${vlus}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vlus $expvl $uuidvl" >> /etc/vless/listlock
sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
rm /etc/vless/${vlus}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VLESS MULTI LOGIN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vlus </b>
<b>TOTAL LOGIN IP : ${vlsss} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vlsss2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${ssvless}x Multi Login Lock Account $waktulock Minutes...</i>
"
echo "" > /tmp/vl
sed -i "/${vlus}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vlus $expvl $uuidvl" >> /etc/vless/listlock
sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
rm /etc/vless/${vlus}login >/dev/null 2>&1
cat> /etc/cron.d/vless${vlus} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray vless $vlus $uuidvl $expvl
EOF
systemctl restart xray
service cron restart
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ VLESS MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $vlus </b>
<b>TOTAL LOGIN IP : ${vlsss} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$vlsss2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${vlessip}x Multi Login : ${ssvless}x Multi Login Auto Lock Account..</i>
"
echo "" > /tmp/vl
sed -i "/${vlus}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $vlessip -gt $ssvless ]; then
expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vlus $expvl $uuidvl" >> /etc/vless/listlock
sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
rm /etc/vless/${vlus}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
done
fi
}
function trojan() {
cd
if [[ ! -e /etc/limit/trojan ]]; then
mkdir -p /etc/limit/trojan
fi
trda=($(cat /etc/xray/config.json | grep "^#trg" | awk '{print $2}' | sort -u))
echo -n >/tmp/tr
for db3 in ${trda[@]}; do
logtr=$(cat /var/log/xray/access.log | grep -w "email: ${db3}" | tail -n 150)
while read a; do
if [[ -n ${a} ]]; then
set -- ${a}
ina="${7}"
inu="${2}"
anu="${3}"
enu=$(echo "${anu}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
now=$(tim2sec ${timenow})
client=$(tim2sec ${inu})
nowt=$(((${now} - ${client})))
if [[ ${nowt} -lt 40 ]]; then
cat /tmp/tr | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/tr
restr=$(cat /tmp/tr)
fi
fi
fi
done <<<"${logtr}"
done
if [[ ${restr} != "" ]]; then
for usrtr in ${trda[@]}; do
trip=$(cat /tmp/tr | grep -w "${usrtr}" | wc -l)
trip2=$(cat /tmp/tr | grep -w "${usrtr}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
sdf=$(ls "/etc/trojan" | grep -w "${usrtr}IP")
if [[ -z ${sdf} ]]; then
sadsde="0"
else
sadsde=$(cat /etc/trojan/${usrtr}IP)
fi
if [[ ${trip} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/trojan/$usrtr ]; then
echo "${downlink}" > /etc/limit/trojan/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/trojan/$usrtr)
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/trojan/$usrtr
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/trojan/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
if [ ! -e /etc/trojan/${usrtr} ]; then
echo "999999999999" > /etc/trojan/${usrtr}
fi
limit=$(cat /etc/trojan/${usrtr})
usage=$(cat /etc/limit/trojan/${usrtr})
if [ $usage -gt $limit ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/userQuota
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/limit/trojan/${usrtr} >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
if [[ ${trip} -gt $sadsde ]]; then
byt=$(cat /etc/limit/trojan/$usrtr)
gb=$(convert ${byt})
echo "$usrtr ${trip}" >> /etc/trojan/${usrtr}login
trojanip=$(cat /etc/trojan/${usrtr}login | wc -l)
sstrojan1=$(ls "/etc/trojan" | grep -w "notif")
if [[ -z ${sstrojan1} ]]; then
sstrojan="3"
else
sstrojan=$(cat /etc/trojan/notif)
fi
if [ $trojanip = $sstrojan ]; then
echo -ne
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan/${usrtr}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Lock Account $waktulock Minutes...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan/${usrtr}login >/dev/null 2>&1
cat> /etc/cron.d/trojan${usrtr} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray trojan $usrtr $uuidtr $exptr
EOF
systemctl restart xray
service cron restart
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${trojanip}x Multi Login : ${sstrojan}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $trojanip -gt $sstrojan ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan/${usrtr}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
done
fi
}
####### TROJAN-GO #######
function trojan-go() {
cd
if [[ ! -e /etc/limit/trojan-go ]]; then
mkdir -p /etc/limit/trojan-go
fi
trda=($(cat /etc/xray/config.json | grep "^#trg" | awk '{print $2}' | sort -u))
echo -n >/tmp/tr
for db3 in ${trda[@]}; do
logtr=$(cat /var/log/xray/access.log | grep -w "email: ${db3}" | tail -n 150)
while read a; do
if [[ -n ${a} ]]; then
set -- ${a}
ina="${7}"
inu="${2}"
anu="${3}"
enu=$(echo "${anu}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
now=$(tim2sec ${timenow})
client=$(tim2sec ${inu})
nowt=$(((${now} - ${client})))
if [[ ${nowt} -lt 40 ]]; then
cat /tmp/tr | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/tr
restr=$(cat /tmp/tr)
fi
fi
fi
done <<<"${logtr}"
done
if [[ ${restr} != "" ]]; then
for usrtr in ${trda[@]}; do
trip=$(cat /tmp/tr | grep -w "${usrtr}" | wc -l)
trip2=$(cat /tmp/tr | grep -w "${usrtr}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
sdf=$(ls "/etc/trojan-go" | grep -w "${usrtr}IP")
if [[ -z ${sdf} ]]; then
sadsde="0"
else
sadsde=$(cat /etc/trojan-go/${usrtr}IP)
fi
if [[ ${trip} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/trojan-go/$usrtr ]; then
echo "${downlink}" > /etc/limit/trojan-go/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/trojan-go/$usrtr)
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/trojan-go/$usrtr
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/trojan-go/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
if [ ! -e /etc/trojan-go/${usrtr} ]; then
echo "999999999999" > /etc/trojan-go/${usrtr}
fi
limit=$(cat /etc/trojan-go/${usrtr})
usage=$(cat /etc/limit/trojan-go/${usrtr})
if [ $usage -gt $limit ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan-go/userQuota
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/limit/trojan-go/${usrtr} >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
if [[ ${trip} -gt $sadsde ]]; then
byt=$(cat /etc/limit/trojan-go/$usrtr)
gb=$(convert ${byt})
echo "$usrtr ${trip}" >> /etc/trojan-go/${usrtr}login
trojanip=$(cat /etc/trojan-go/${usrtr}login | wc -l)
sstrojan1=$(ls "/etc/trojan-go" | grep -w "notif")
if [[ -z ${sstrojan1} ]]; then
sstrojan="3"
else
sstrojan=$(cat /etc/trojan-go/notif)
fi
if [ $trojanip = $sstrojan ]; then
echo -ne
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan-go/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan-go/${usrtr}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Lock Account $waktulock Minutes...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan-go/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan-go/${usrtr}login >/dev/null 2>&1
cat> /etc/cron.d/trojan-go${usrtr} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray trojan-go $usrtr $uuidtr $exptr
EOF
systemctl restart xray
service cron restart
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN : ${domen} </b>
<b>ISP : ${ISP}</b>
<b>CITY : ${CITY}</b>
<b>DATE LOGIN : $DATE</b>
<b>USERNAME : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USAGE : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIME LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${trojanip}x Multi Login : ${sstrojan}x Multi Login Auto Lock Account...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $trojanip -gt $sstrojan ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan-go/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan-go/${usrtr}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
done
fi
}
vmess
vless
trojan
trojan-go
