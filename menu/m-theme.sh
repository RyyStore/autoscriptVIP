#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
author=$(cat /etc/profil)
clear
echo -e " $COLOR1╔════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC}${COLBG1}             ${WH}• THEMES PANEL MENU •                  ${NC}$COLOR1║ $NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}01${WH}]$NC ${COLOR1}• ${WH}COLOR RED         ${WH}[${COLOR1}08${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT RED$NC$COLOR1    ║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}02${WH}]$NC ${COLOR1}• ${WH}COLOR GREEN       ${WH}[${COLOR1}09${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT GREEN$NC$COLOR1  ║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}03${WH}]$NC ${COLOR1}• ${WH}COLOR YELLOW      ${WH}[${COLOR1}10${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT YELLOW$NC$COLOR1 ║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}04${WH}]$NC ${COLOR1}• ${WH}COLOR BLUE        ${WH}[${COLOR1}11${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT BLUE$NC$COLOR1   ║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}05${WH}]$NC ${COLOR1}• ${WH}COLOR MAGENTA     ${WH}[${COLOR1}12${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT MAGENTA$NC$COLOR1║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}06${WH}]$NC ${COLOR1}• ${WH}COLOR CYAN        ${WH}[${COLOR1}13${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT CYAN$NC$COLOR1   ║$NC"
echo -e " $COLOR1║$NC ${WH}[${COLOR1}07${WH}]$NC ${COLOR1}• ${WH}COLOR LIGHT GRAY  ${WH}[${COLOR1}14${WH}]$NC ${COLOR1}• ${WH}COLOR DARKGRAY$NC$COLOR1     ║$NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔═════════════════════════ ${WH}BY${NC} ${COLOR1}═══════════════════════╗ ${NC}"
echo -e "  $COLOR1${NC}              ${WH}   • $author •                 $COLOR1 $NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read colormenu
case $colormenu in
01 | 1)
clear
echo "red" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
02 | 2)
clear
echo "green" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
03 | 3)
clear
echo "yellow" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
04 | 4)
clear
echo "blue" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
05 | 5)
clear
echo "magenta" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
06 | 6)
clear
echo "cyan" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
07 | 7)
clear
echo "lightgray" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
08 | 8)
clear
echo "lightred" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
09 | 9)
clear
echo "lightgreen" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
10 | 10)
clear
echo "lightyellow" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
11 | 11)
clear
echo "lightblue" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
12 | 12)
clear
echo "lightmagenta" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
13 | 13)
clear
echo "lightcyan" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
14 | 14)
clear
echo "darkgray" >/etc/rmbl/theme/color.conf
echo -e "SUCCES Ganti Tema"
;;
00 | 0)
clear
menu
;;
*)
clear
m-theme
;;
esac
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
