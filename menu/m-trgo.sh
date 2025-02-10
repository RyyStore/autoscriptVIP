#!/bin/bash
# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_CTYPE='en_US.utf8'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${COLOR1} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${COLOR1}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="autosc.me/aio"
export Server_Port="2087"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="XdrgVPN"

colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'

clear
MYIP=$(wget -qO- ipinfo.io/ip);
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domain=`cat /etc/xray/domain`
CHATID2=$(cat /etc/perlogin/id)
KEY2=$(cat /etc/perlogin/token)
URL2="https://api.telegram.org/bot$KEY2/sendMessage"
if [ ! -e /etc/trojan-go/akun ]; then
mkdir -p /etc/trojan-go/akun
fi
function addtrgo() {

until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		user_EXISTS=$(grep -w $user /etc/trojan-go/trgo | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${COLOR1}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /etc/trojan-go/uuid.txt)
read -p "Expired (days): " masaaktif
read -p "Limit User (IP) or 0 Unlimited: " iplimit
read -p "Limit User (GB) or 0 Unlimited: " Quota
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan-go/config.json
echo -e "### $user $exp" >> /etc/trojan-go/trgo
systemctl restart trojan-go.service
linktls="trojan-go://${user}@${domain}:2087/?sni=${domain}&type=ws&host=${domain}&path=/trojango&encryption=none#$user"
linktrgotls="trojan-go://${user}@${domain}:2087?%26sni=${domain}%26type=ws%26host=${domain}%26path=%2Ftrojango%26encryption=none#${user}"

if [ ! -e /etc/trojan-go ]; then
  mkdir -p /etc/trojan-go
fi

if [[ $iplimit -gt 0 ]]; then
mkdir -p /etc/sfvt/limit/trojan-go/ip
echo -e "$iplimit" > /etc/sfvt/limit/trojan-go/ip/$user
else
echo > /dev/null
fi

if [ -z ${Quota} ]; then
  Quota="0"
fi

c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$((${c} * 1024 * 1024 * 1024))

if [[ ${c} != "0" ]]; then
  echo "${d}" >/etc/trojan-go/${user}
fi
DATADB=$(cat /etc/trojan-go/trgo | grep "^###" | grep -w "${user}" | awk '{print $2}')
if [[ "${DATADB}" != '' ]]; then
  sed -i "/\b${user}\b/d" /etc/trojan-go/trgo
fi
echo "### ${user} ${exp} ${uuid} ${Quota} ${iplimit}" >>/etc/trojan-go/trgo
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Premium Trojan-GO Account
◇━━━━━━━━━━━━━━━━━◇
Remarks : <code>${user}</code>
IP/Host : <code>${MYIP}</code>
Address : <code>${domain}</code>
Port : <code>2087</code>
Password : <code>${user}</code>
Encryption : <code>none</code>
Path : <code>/trojango</code>
Created : <code>$hariini</code>
Expired : <code>$exp</code>
◇━━━━━━━━━━━━━━━━━◇
Link TrGo TLS : <code>${linktrgotls}</code>
◇━━━━━━━━━━━━━━━━━◇
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
user2=$(echo "$user" | cut -c 1-3)
TIME2=$(date +'%Y-%m-%d %H:%M:%S')
TEXT2="
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<b>   PEMBELIAN TROJAN-GO SUCCES </b>
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN  :</b> <code>${domain} </code>
<b>CITY    :</b> <code>$CITY </code>
<b>DATE    :</b> <code>${TIME2} WIB </code>
<b>DETAIL  :</b> <code>Trx TROJAN-GO </code>
<b>USER    :</b> <code>${user2}xxx </code>
<b>IP      :</b> <code>${iplimit} IP </code>
<b>DURASI  :</b> <code>$masaaktif Hari </code>
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<i>Notif Pembelian Akun Trojan-GO..</i>"
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
clear
echo -e ""
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━━━◇$NC"
echo -e "$WH• Premium Trojan-Go Account • $NC"
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━━━◇$NC"
echo -e "$WH  Remarks : ${user} $NC "
echo -e "$WH  Address : ${domain} $NC "
echo -e "$WH  Port TLS : 2087 $NC "
echo -e "$WH  Key : ${user} $NC "
echo -e "$WH  Encryption : none $NC "
echo -e "$WH  Path : /trojango $NC "
echo -e "$WH  Expired : $exp $NC "
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━━━◇$NC"
echo -e "$WH Link TrGo TLS  : ${linktls} $NC"
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━━━◇$NC"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

function deletetrgo() {
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/trojan-go/trgo")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
CLIENT_NAME=$(grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 2-3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/d" /etc/trojan-go/trgo
sed -i '/^,"'"$user"'"$/d' /etc/trojan-go/config.json
systemctl restart trojan-go.service
service cron restart
clear
echo ""
echo "============================"
echo "  TrojanGo Account Deleted  "
echo "============================"
echo "Username : $user"
echo "Expired  : $exp"
echo "============================"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
m-trgo
}

function renewtrgo() {
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/trojan-go/trgo")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo "Select the existing client you want to renew"
	echo " Press CTRL+C to return"
	echo -e "==============================="
	grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (Days) : " masaaktif
user=$(grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/trojan-go/trgo" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### $user $exp/### $user $exp4/g" /etc/trojan-go/trgo
clear
echo ""
echo "============================"
echo "  TrojanGo Account Renewed  "
echo "============================"
echo "Username : $user"
echo "Expired  : $exp4"
echo "=========================="
echo "Script Mod By SL"
}


function cektrgo() {
clear
function con() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(( (bytes + 1048575)/1048576 ))MB"
    else
        echo "$(( (bytes + 1073741823)/1073741824 ))GB"
    fi
}
echo -n > /tmp/other.txt
data=( `cat /etc/trojan-go/trgo | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}            ${WH}• TROJAN-GO USER ONLINE •            ${NC}$COLOR1 │ $NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "${COLOR1}|${NC} ${WH} USERNAME ${NC}${COLOR1}|${NC}${WH}  USAGE  ${NC}${COLOR1}|${NC}${WH} LMT QUOTA ${NC}${COLOR1}|${NC}${WH} LGN IP ${NC}${COLOR1}|${NC}${WH} LMT IP ${NC}${COLOR1}|${NC}"
echo -e "$COLOR1╠═══════════════════════════════════════════════════╣${NC}"
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/iptrojango.txt
data2=( `cat /var/log/trojan-go/trojan-go.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/trojan-go/trojan-go.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$iplimit" | sort | uniq)
if [[ "$jum" = "$iplimit" ]]; then
echo "$jum" >> /tmp/iptrojango.txt
else
echo "$iplimit" >> /tmp/other.txt
fi
jum2=$(cat /tmp/iptrojango.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/iptrojango.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
iplimit=$(cat /etc/sfvt/limit/trojan-go/ip/${akun})
jum2=$(cat /tmp/iptrojango.txt | wc -l)
byte=$(cat /etc/trojan-go/${akun})
lim=$(con ${byte})
wey=$(cat /etc/limit/trojan-go/${akun})
gb=$(con ${wey})
lastlogin=$(cat /var/log/trojan-go/trojan-go.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
printf "${WH}%-13s %-7s %-8s %2s${NC}\n" "   ${akun} "  " ${gb}   "  "    ${lim} "      "    $jum2 IP / $iplimit IP    "
fi 
rm -rf /tmp/iptrojango.txt
done
rm -rf /tmp/other.txt
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-trgo
}

clear
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}              ${WH}• TROJAN-GO PANEL MENU •           ${NC}$COLOR1 │ $NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ $NC  ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}ADD TRGO${NC}      ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}RENEW AKUN${NC}    $COLOR1 $NC"
echo -e "$COLOR1│ $NC  ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}DELETE TRGO${NC}   ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}CHECK USER${NC}    $COLOR1 $NC"
echo -e "$COLOR1│ $NC  ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}BACK ${NC}"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═════════════════════ • ${WH}BY${NC}${COLOR1} • ══════════════════════╮${NC}"
printf "                      ${COLOR1}%3s${NC} ${WH}%0s${NC} ${COLOR1}%3s${NC}\n" "• " "$author" " •"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 | 1) clear ; addtrgo ;;
02 | 2) clear ; deletetrgo ;;
03 | 3) clear ; renewtrgo ;;
04 | 4) clear ; cektrgo ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
