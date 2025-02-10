#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )

ipsaya=$(curl -s -4 icanhazip.com)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/jvoscript/permission/main/ip"
checking_sc() {
    useexp=$(curl -sS $data_ip | grep $ipsaya | awk '{print $3}')
    if [[ $date_list < $useexp ]]; then
        echo -ne
    else
        echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
        echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •               ${NC} $COLOR1 $NC"
        echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
        echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
        echo -e "            ${RED}PERMISSION DENIED !${NC}"
        echo -e "   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}"
        echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
        echo -e "             \033[0;33mContact Admin :${NC}"
        echo -e "     \033[0;36mTelegram${NC}: https://t.me/masansor"
        echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
        exit
    fi
}
checking_sc

MYIP=$(curl -sS ipv4.icanhazip.com)

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/jvoscript/permission/main/ip | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'
clear


# GETTING OS INFORMATION
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID

# VPS ISP INFORMATION
#ITAM='\033[0;30m'
#echo -e "$ITAM"
REGION=$( curl -s ipinfo.io/region )
#clear
#COUNTRY=$( curl -s ipinfo.io/country )
#clear
#WAKTU=$( curl -s ipinfo.ip/timezone )
#clear
CITY=$( curl -s ipinfo.io/city )
#clear
#REGION=$( curl -s ipinfo.io/region )
#clear

# CHEK STATUS
#openvpn_service="$(systemctl show openvpn.service --no-page)"
#oovpn=$(echo "${openvpn_service}" | grep 'ActiveState=' | cut -f2 -d=)
oovpn=$(systemctl status openvpn | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)
#status_openvp=$(/etc/init.d/openvpn status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
#status_ss_tls="$(systemctl show shadowsocks-libev-server@tls.service --no-page)"
#ss_tls=$(echo "${status_ss_tls}" | grep 'ActiveState=' | cut -f2 -d=)
#sst_status=$(systemctl status shadowsocks-libev-server@tls | grep Active | awk '{print $0}' | cut -d "(" -f2 | cut -d ")" -f1)
#ssh_status=$(systemctl status shadowsocks-libev-server@http | grep Active | awk '{print $0}' | cut -d "(" -f2 | cut -d ")" -f1)
#status_ss_http="$(systemctl show shadowsocks-libev-server@http.service --no-page)"
#ss_http=$(echo "${status_ss_http}" | grep 'ActiveState=' | cut -f2 -d=)
#sssohtt=$(systemctl status shadowsocks-libev-server@*-http | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
#status="$(systemctl show shadowsocks-libev.service --no-page)"
#status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
shadowsocks=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan_server=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wstls=$(systemctl status ws-stunnel.service | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wsovpn=$(systemctl status ws-ovpn | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
osslh=$(systemctl status sslh | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
udp=$(systemctl status udp-custom | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
sls=$(systemctl status server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
slc=$(systemctl status client | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
noobz=$(systemctl status noobzvpns | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trgoo=$(systemctl status trojan-go | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# COLOR VALIDATION
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear

# STATUS SERVICE OPENVPN
if [[ $oovpn == "active" ]]; then
  status_openvpn=" ${GREEN}Online ${NC}"
else
  status_openvpn="${RED}Offline ${NC}"
fi

# STATUS SERVICE  SSH
if [[ $ssh_service == "running" ]]; then
   status_ssh=" ${GREEN}Online ${NC}"
else
   status_ssh="${RED}Offline ${NC}"
fi

# STATUS SERVICE  SQUID
if [[ $squid_service == "running" ]]; then
   status_squid=" ${GREEN}Online ${NC}"
else
   status_squid="${RED}Offline ${NC}"
fi

# STATUS SERVICE  VNSTAT
if [[ $vnstat_service == "running" ]]; then
   status_vnstat=" ${GREEN}Online ${NC}"
else
   status_vnstat="${RED}Offline ${NC}"
fi

# STATUS SERVICE  CRONS
if [[ $cron_service == "running" ]]; then
   status_cron=" ${GREEN}Online ${NC}"
else
   status_cron="${RED}Offline ${NC}"
fi

# STATUS SERVICE  FAIL2BAN
if [[ $fail2ban_service == "running" ]]; then
   status_fail2ban=" ${GREEN}Online ${NC}"
else
   status_fail2ban="${RED}Offline ${NC}"
fi

# STATUS SERVICE  TLS
if [[ $tls_v2ray_status == "running" ]]; then
   status_tls_v2ray=" ${GREEN}Online ${NC}"
else
   status_tls_v2ray="${RED}Offline ${NC}"
fi

# STATUS SERVICE NON TLS V2RAY
if [[ $nontls_v2ray_status == "running" ]]; then
   status_nontls_v2ray=" ${GREEN}Online ${NC}"
else
   status_nontls_v2ray="${RED}Offline ${NC}"
fi

# STATUS SERVICE VLESS HTTPS
if [[ $vless_tls_v2ray_status == "running" ]]; then
  status_tls_vless=" ${GREEN}Online ${NC}"
else
  status_tls_vless="${RED}Offline ${NC}"
fi

# STATUS SERVICE VLESS HTTP
if [[ $vless_nontls_v2ray_status == "running" ]]; then
  status_nontls_vless=" ${GREEN}Online ${NC}"
else
  status_nontls_vless="${RED}Offline ${NC}"
fi
# STATUS SERVICE TROJAN
if [[ $trojan_server == "running" ]]; then
   status_virus_trojan=" ${GREEN}Online ${NC}"
else
   status_virus_trojan="${RED}Offline ${NC}"
fi
# STATUS SERVICE TROJAN-GO
if [[ $trgoo == "running" ]]; then
   status_trgo=" ${GREEN}Online ${NC}"
else
   status_trgo="${RED}Offline ${NC}"
fi
# STATUS SERVICE DROPBEAR
if [[ $dropbear_status == "running" ]]; then
   status_beruangjatuh=" ${GREEN}Online${NC}"
else
   status_beruangjatuh="${RED}Offline ${NC}"
fi

# STATUS SERVICE STUNNEL
if [[ $stunnel_service == "running" ]]; then
   status_stunnel=" ${GREEN}Online ${NC}"
else
   status_stunnel="${RED}Offline ${NC}"
fi
# STATUS SERVICE WEBSOCKET TLS
if [[ $wstls == "running" ]]; then
   swstls=" ${GREEN}Online ${NC}"
else
   swstls="${RED}Offline ${NC}"
fi

# STATUS SERVICE SSLH / SSH
if [[ $osslh == "running" ]]; then 
   sosslh=" ${GREEN}Online ${NC}"
else
   sosslh="${RED}Offline ${NC}"
fi

# STATUS OHP DROPBEAR
if [[ $udp == "running" ]]; then 
   udp=" ${GREEN}Online ${NC}"
else
   udp="${RED}Offline ${NC}"
fi

# STATUS OHP OpenVPN
if [[ $sls == "running" ]]; then 
   sls=" ${GREEN}Online ${NC}"
else
   sls="${RED}Offline ${NC}"
fi

# STATUS OHP SSH
if [[ $slc == "running" ]]; then 
   slc=" ${GREEN}Online ${NC}"
else
   slc="${RED}Offline ${NC}"
fi

# STATUS SQUID
if [[ $status_squid == "running" ]]; then 
   status_squid=" ${GREEN}Online ${NC}"
else
   status_squid="${RED}Offline ${NC}"
fi

# STATUS SHADOWSOCKS
if [[ $shadowsocks == "running" ]]; then
   status_shadowsocks=" ${GREEN}Online ${NC}"
else
   status_shadowsocks="${RED}Offline ${NC}"
fi

# STATUS NOOBZVPNS
if [[ $noobz == "running" ]]; then 
   noobz=" ${GREEN}Online ${NC}"
else
   noobz="${RED}Offline ${NC}"
fi



# TOTAL RAM
total_ram=`grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))

# KERNEL TERBARU
kernelku=$(uname -r)

# WAKTU SEKARANG
DATE=$(date +'%Y-%m-%d')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

today=`date -d "0 days" +"%Y-%m-%d"`
Exp2=$(curl -sS https://raw.githubusercontent.com/jvoscript/permission/main/ip | grep $MYIP | awk '{print $3}')

# CERTIFICATE STATUS
d1=$(date -d "$Exp2" +%s)
d2=$(date -d "$today" +%s)
certificate=$(( (d1 - d2) / 86400 ))

# DNS PATCH
#tipeos2=$(uname -m)
Name2=$(curl -sS https://raw.githubusercontent.com/jvoscript/permission/main/ip | grep $MYIP | awk '{print $2}')
# GETTING DOMAIN NAME
Domen="$(cat /etc/xray/domain)"
echo -e ""
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}               ${WH}⇱ SYSTEM INFORMATION ⇲            ${NC}${COLOR1} │$NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Hostname    ${COLOR1}: ${WH}$HOSTNAME$NC"
echo -e "$COLOR1 $NC  ${WH}❈ OS Name     ${COLOR1}: ${WH}$Tipe$NC"
echo -e "$COLOR1 $NC  ${WH}❈ Total RAM   ${COLOR1}: ${WH}${totalram}MB$NC"
echo -e "$COLOR1 $NC  ${WH}❈ Public IP   ${COLOR1}: ${WH}$MYIP$NC"
echo -e "$COLOR1 $NC  ${WH}❈ Domain      ${COLOR1}: ${WH}$Domen$NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}          ${WH}⇱ SUBSCRIPTION INFORMATION ⇲           ${NC}${COLOR1} │$NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ $NC ${WH}❈ Client Name ${COLOR1}: ${WH}$Name2${NC}"
echo -e "$COLOR1│ $NC ${WH}❈ License     ${COLOR1}: ${WH}$certificate days${NC}"
echo -e "$COLOR1│ $NC ${WH}❈ Version     ${COLOR1}: ${WH}$(cat /opt/.ver) Version${NC}"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}              ${WH}⇱ SERVICE INFORMATION ⇲            ${NC}${COLOR1} │$NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ SSH / TUN               ${COLOR1}: ${WH}$status_ssh${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ OpenVPN                 ${COLOR1}: ${WH}$status_openvpn${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Dropbear                ${COLOR1}: ${WH}$status_beruangjatuh${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Crons                   ${COLOR1}: ${WH}$status_cron${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Vnstat                  ${COLOR1}: ${WH}$status_vnstat${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ XRAYS Vmess TLS         ${COLOR1}: ${WH}$status_tls_v2ray${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ XRAYS Vmess None TLS    ${COLOR1}: ${WH}$status_nontls_v2ray${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ XRAYS Vless TLS         ${COLOR1}: ${WH}$status_tls_vless${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ XRAYS Vless None TLS    ${COLOR1}: ${WH}$status_nontls_vless${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ XRAYS Trojan            ${COLOR1}: ${WH}$status_virus_trojan${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Shadowsocks             ${COLOR1}: ${WH}$status_shadowsocks${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Websocket TLS           ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Websocket None TLS      ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ Websocket None TLS      ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ NOOBZVPNS               ${COLOR1}: ${WH}$noobz${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ TROJAN-GO               ${COLOR1}: ${WH}$status_trgo${NC}"
echo -e "$COLOR1 $NC  ${WH}❈ SSH UDP COSTUM          ${COLOR1}: ${WH}$udp${NC}"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═══════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${NC}${COLBG1}              ${WH}⇱ AUTOSCRIPT PREMIUM ⇲             ${NC}${COLOR1} │$NC"
echo -e "$COLOR1╰═══════════════════════════════════════════════════╯${NC}"
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
menu
