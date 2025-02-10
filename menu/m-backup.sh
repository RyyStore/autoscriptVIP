#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
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
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •               ${NC} $COLOR1 $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "            ${RED}PERMISSION DENIED !${NC}"
echo -e "   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}"
echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
echo -e "             \033[0;33mContact Your Admin ${NC}"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
exit
fi
}
checking_sc
clear
function jamhabis(){
clear
rm -rf /etc/cron.d/autobackup
rm -rf /etc/cron.d/bckp_otm
rm -rf /etc/jam
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(grep -c -E "^# Autobackup" /etc/cron.d/autobackup)
if [[ "$cek" = "1" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1${NC}${COLBG1}             AUTO BACKUP          ${NC}$COLOR1$NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Status Auto Backup : $sts        "
echo -e ""
echo -e "[1]  AutoBackup After 30 Minutes"
echo -e "[2]  AutoBackup After 60 Minutes"
echo -e "[3]  AutoBackup After 120 Minutes"
echo -e "[4]  AutoBackup After 180 Minutes"
echo -e "[5]  AutoBackup After 240 Minutes"
echo -e "[6]  Turn Off Auto  Backup"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -p "Select From Options [1-4 or x] :  " backup
if [ -z $backup ]; then
jamhabis
fi
echo -e ""
case $backup in
1)
echo -e ""
sleep 1
clear
echo > /etc/cron.d/autobackup
echo "# Autobackup" >/etc/cron.d/autobackup
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/autobackup
echo "*/30 * * * *  root /usr/bin/bottelegram" >>/etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      AutoBackup Every     : 30 Minutes"
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
2)
echo -e ""
sleep 1
clear
echo > /etc/cron.d/autobackup
echo "# Autobackup" >/etc/cron.d/autobackup
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/autobackup
echo "*/60 * * * *  root /usr/bin/bottelegram" >>/etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      AutoBackup Every     : 60 Minutes"
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
3)
echo -e ""
sleep 1
clear
echo > /etc/cron.d/autobackup
echo "# Autobackup" >/etc/cron.d/autobackup
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/autobackup
echo "*/120 * * * *  root /usr/bin/bottelegram" >>/etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      AutoBackup Every     : 120 Minutes"
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
4)
echo -e ""
sleep 1
clear
echo > /etc/cron.d/autobackup
echo "# Autobackup" >/etc/cron.d/autobackup
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/autobackup
echo "*/180 * * * *  root /usr/bin/bottelegram" >>/etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      AutoBackup Every     : 180 Minutes"
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
5)
echo -e ""
sleep 1
clear
echo > /etc/cron.d/autobackup
echo "# Autobackup" >/etc/cron.d/autobackup
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/autobackup
echo "*/240 * * * *  root /usr/bin/bottelegram" >>/etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      AutoBackup Every     : 240 Minutes"
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
6)
clear
rm /etc/cron.d/autobackup
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "      Auto Backup Turned Off  "
echo -e ""
echo -e "======================================"
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
;;
x)
clear
menu
;;
esac
}
function jam2(){
clear
rm -rf /etc/cron.d/autobackup
rm -rf /etc/cron.d/bckp_otm
rm -rf /etc/cron.d/bckp_otm2
rm -rf /etc/jam
echo -e ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 Silahkan Tulis Jamnya contoh : 2 Jam Tulis 2. dst.${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e " "
read -p "   Silahkan tulis jam auto backup nya : " jam2
echo "$jam2" > /etc/jam2
echo ""
clear
jam2=$(cat /etc/jam2)
cat > /etc/cron.d/autobackup <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
10 */${jam2} * * * root /usr/bin/bottelegram
END
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
echo -e "${BIGreen}Auto Backup Tiap ${jam2} JAM ${NC} "
echo -e ""
}
function jam(){
clear
rm -rf /etc/cron.d/autobackup
rm -rf /etc/cron.d/bckp_otm
rm -rf /etc/cron.d/bckp_otm2
rm -rf /etc/jam
echo -e ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 Contoh Format Jam : 4 = jam 4 pagi, 20 = jam 8 malam ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e " "
read -p "   Silahkan tulis jam auto backup nya : " jam
echo "$jam" > /etc/jam
echo ""
clear
jam2=$(cat /etc/jam)
cat > /etc/cron.d/bckp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 ${jam2} * * * root /usr/bin/bottelegram
END
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
echo -e "${BIGreen}Auto Backup Tiap ${jam}:00 WIB${NC} "
echo -e ""
}
clear
function autobckpbot(){
clear
echo ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│        ${WH}Please select a your Choice       $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│           [ 1 ]  ${WH}OFF AUTO BACKUP         $COLOR1│${NC}"
echo -e "$COLOR1│           [ 2 ]  ${WH}ON AUTO BACKUP          $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
read -p "   Please select numbers 1-2 or Any Button(back) : " bot
echo ""
if [[ $bot == "1" ]]; then
rm -rf /etc/cron.d/bckp_otm
rm -rf /etc/cron.d/autobackup
rm -rf /etc/jam
echo -e  "Sukses OFF Auto Backup"
echo " "
read -n 1 -s -r -p "Press any key to back on menu"
menu
clear
elif [[ $bot == "2" ]]; then
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│        ${WH}Please select a your Choice       $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│           [ 1 ]  ${WH}AUTO BACKUP TIAP JAM    $COLOR1│${NC}"
echo -e "$COLOR1│           [ 2 ]  ${WH}AUTO BACKUP TIAP HARI   $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
read -p "   Please select numbers 1-2 or Any Button(Random) : " bott
echo ""
fi
if [[ $bott == "1" ]]; then
jam2
elif [[ $bott == "2" ]]; then
jam
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu
clear
}
function mbot(){
cd
if [[ -e /usr/bin/token ]]; then
bottelegram
else
clear
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Backup Telegram"
read -rp "Enter Token (Creat on @BotFather) : " -e token2
echo "$token2" > /usr/bin/token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idchat
echo "$idchat" > /usr/bin/idchat
sleep 1
bottelegram
fi
}
clear
author=$(cat /etc/profil)
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• BACKUP PANEL MENU •             ${NC} $COLOR1 $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e " $COLOR1╭═══════════════════════════════════════════════╮${NC}"
echo -e " $COLOR1 $NC   ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}RESTORE VPS/TELE BOT $COLOR1 $NC"
echo -e " $COLOR1 $NC                                               $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}BACKUP VPS  $COLOR1 $NC"
echo -e " $COLOR1 $NC                                               $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}BACKUP VPS TELE BOT  $COLOR1 $NC"
echo -e " $COLOR1 $NC                                               $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}SET JAM AUTO BACKUP TELE BOT$COLOR1 $NC"
echo -e " $COLOR1 $NC                                               $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}GO BACK${NC}                              $COLOR1 $NC"
echo -e " $COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1┌────────────────────── ${WH}BY${NC} ${COLOR1}───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• $author •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
echo -e ""
case $opt in
01 | 1) clear ; restore ;;
02 | 2) clear ; backup ;;
03 | 3) clear ; mbot ;;
04 | 4) clear ; autobckpbot ;;
00 | 0) clear ; menu ;;
*) clear ; menu-backup ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
