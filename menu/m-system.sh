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
function add-host(){
fun_bar() {
CMD[0]="$1"
CMD[1]="$2"
(
[[ -e $HOME/fim ]] && rm $HOME/fim
${CMD[0]} -y >/dev/null 2>&1
${CMD[1]} -y >/dev/null 2>&1
touch $HOME/fim
) >/dev/null 2>&1 &
tput civis
echo -ne "  \033[0;33mUodate Domain... \033[1;37m- \033[0;33m["
while true; do
for ((i = 0; i < 18; i++)); do
echo -ne "\033[0;32m#"
sleep 0.1s
done
[[ -e $HOME/fim ]] && rm $HOME/fim && break
echo -e "\033[0;33m]"
sleep 1s
tput cuu1
tput dl1
echo -ne "  \033[0;33mUpdate Domain... \033[1;37m- \033[0;33m["
done
echo -e "\033[0;33m]\033[1;37m -\033[1;32m Succes !\033[1;37m"
tput cnorm
}
sldns() {
wget https://raw.githubusercontent.com./jvoscript/autoscript/main/slowdns/ && chmod +x installsl.sh && ./installsl.sh
}
res1() {
wget https://raw.githubusercontent.com./jvoscript/autoscript/main/slowdns/ && chmod +x rmbl.sh && ./rmbl.sh
clear
}
res2() {
wget https://raw.githubusercontent.com./jvoscript/autoscript/main/slowdns/ && chmod +x rmbl1.sh && ./rmbl1.sh
clear
}
res3() {
wget https://raw.githubusercontent.com./jvoscript/autoscript/main/slowdns/ && chmod +x rmbl2.sh && ./rmbl2.sh
clear
}
clear
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set Domain              ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}Domain kamu Sendri    ${NC}"
echo -e "$COLOR1│  [ 2 ]  ${WH}Domain Yang Punya Script     ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
until [[ $dns =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-2 or Any Button(Random) : " dns
done
if [[ $dns == "1" ]]; then
clear
echo -e  "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}DARI SAYA                  $COLOR1│${NC}"
echo -e  "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo " "
until [[ $dnss =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dnss
done
echo ""
echo "$dnss" > /etc/xray/domain
echo "$dnss" > /etc/root/domain
echo "IP=$dnss" > /var/lib/kyt/ipvps.conf
read -n 1 -s -r -p "  Press any key to Back Menu"
certv2ray
clear
elif [[ $dns == "2" ]]; then
clear
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice to Set Domain$COLOR1│${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mDomain xxx.tepllovpn.eu.org       ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
until [[ $domain2 =~ ^[1-2]+$ ]]; do
read -p "   Please select numbers : " domain2
done
if [[ $domain2 == "1" ]]; then
clear
until [[ $dn2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn2
done
echo "$dn2" > /etc/xray/domain
echo "$dn2" > /root/subdomainx
cd
sleep 1
fun_bar 'res2'
clear
rm -rf /root/subdomainx
fi
read -n 1 -s -r -p "  Press any key to Renew Cert or Ctrl + C to Exit"
certv2ray
clear
elif [[ $dns == "3" ]]; then
clear
cd
sleep 1
fun_bar 'sldns'
read -n 1 -s -r -p "  Press any key to Back Menu"
menu
clear
elif [[ $dns == "4" ]]; then
clear
echo -e  "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}TUNNEL STORES                   $COLOR1│${NC}"
echo -e  "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo " "
until [[ $dns1 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dns1
done
echo ""
echo "$dns1" > /etc/xray/domain
echo "$dns1" > /etc/root/domain
echo "IP=$dns1" > /var/lib/kyt/ipvps.conf
clear
echo -e  "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}TUNNEL STORES                   $COLOR1│${NC}"
echo -e  "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo " "
until [[ $dns2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan Domain SlowDNS kamu Disini : " -e dns2
done
echo $dns2 >/etc/xray/dns
read -n 1 -s -r -p "  Press any key to Back Menu"
menu
clear
elif [[ $dns == "5" ]]; then
clear
echo -e  "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}TUNNEL STORES                   $COLOR1│${NC}"
echo -e  "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo " "
until [[ $dnscl =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dnscl
done
echo ""
echo "$dnscl" > /etc/cloudfront
fi
echo -e " Back To Menu"
sleep 1
menu
}

function auto-reboot(){
clear
if [ ! -e /etc/cron.d/re_otm ]; then
rm -rf /etc/cron.d/re_otm
fi
if [ ! -e /usr/local/bin/reboot_otomatis ]; then
echo '#!/bin/bash' > /usr/local/bin/reboot_otomatis
echo 'tanggal=$(date +"%m-%d-%Y")' >> /usr/local/bin/reboot_otomatis
echo 'waktu=$(date +"%T")' >> /usr/local/bin/reboot_otomatis
echo 'echo "Server successfully rebooted on the date of $tanggal hit $waktu." >> /etc/log-reboot.txt' >> /usr/local/bin/reboot_otomatis
echo '/sbin/shutdown -r now' >> /usr/local/bin/reboot_otomatis
chmod +x /usr/local/bin/reboot_otomatis
fi
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[0;100;33m       • AUTO-REBOOT MENU •        \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "[\e[36m•1\e[0m] Set Auto-Reboot Setiap 1 Jam"
echo -e "[\e[36m•2\e[0m] Set Auto-Reboot Setiap 6 Jam"
echo -e "[\e[36m•3\e[0m] Set Auto-Reboot Setiap 12 Jam"
echo -e "[\e[36m•4\e[0m] Set Auto-Reboot Setiap 1 Hari"
echo -e "[\e[36m•5\e[0m] Set Auto-Reboot Setiap 1 Minggu"
echo -e "[\e[36m•6\e[0m] Set Auto-Reboot Setiap 1 Bulan"
echo -e "[\e[36m•7\e[0m] Set Auto-Rebooot CPU 100%"
echo -e "[\e[36m•8\e[0m] Matikan Auto-Reboot & Auto-Reboot CPU 100%"
echo -e "[\e[36m•9\e[0m] View reboot log"
echo -e "[\e[36m•10\e[0m] Remove reboot log"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " x
if test $x -eq 1; then
echo "10 * * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been set every an hour."
sleep 2
menu
elif test $x -eq 2; then
echo "10 */6 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set every 6 hours."
sleep 2
menu
elif test $x -eq 3; then
echo "10 */12 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set every 12 hours."
sleep 2
menu
elif test $x -eq 4; then
echo -e " CONTOH FORMAT Tiap jam 5 Subuh Tulis 5 "
read -p " Waktu Restart : " wkt
echo "0 $wkt * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a day."
sleep 2
menu
elif test $x -eq 5; then
echo -e " CONTOH FORMAT Tiap jam 8 Malam Tulis 20 "
read -p " Waktu Restart : " wkt2
echo "10 $wkt2 */7 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a week."
sleep 2
menu
elif test $x -eq 6; then
echo -e " CONTOH FORMAT Tiap jam 10 Malam Tulis 20 "
read -p " Waktu Restart : " wkt3
echo "10 $wkt3 1 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a month."
sleep 2
menu
elif test $x -eq 7; then
cat> /etc/cron.d/autocpu << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/7 * * * * root /usr/bin/autocpu
END
echo "Auto-Reboot CPU 100% TURN ON."
sleep 2
menu
elif test $x -eq 8; then
rm -f /etc/cron.d/reboot_otomatis
rm -f /etc/cron.d/autocpu
echo "Auto-Reboot successfully TURNED OFF."
sleep 2
menu
elif test $x -eq 9; then
if [ ! -e /etc/log-reboot.txt ]; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}       ${WH} • AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo "No reboot activity found"
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
else
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}        ${WH}• AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo 'LOG REBOOT'
cat /etc/log-reboot.txt
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
fi
elif test $x -eq 10; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}        ${WH}• AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo "" > /etc/log-reboot.txt
echo "Auto Reboot Log successfully deleted!"
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
elif test $x -eq 0; then
clear
menu
else
clear
echo ""
echo "Options Not Found In Menu"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
fi
}
function bw(){
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}      • BANDWITH MONITOR •         ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e " ${WH}[${COLOR1}•1${WH}]${NC} ${COLOR1} Lihat Total Bandwith Tersisa"
echo -e " ${WH}[${COLOR1}•2${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap 5 Menit"
echo -e " ${WH}[${COLOR1}•3${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Jam"
echo -e " ${WH}[${COLOR1}•4${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Hari"
echo -e " ${WH}[${COLOR1}•5${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Bulan"
echo -e " ${WH}[${COLOR1}•6${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Tahun"
echo -e " ${WH}[${COLOR1}•7${WH}]${NC} ${COLOR1} Tabel Penggunaan Tertinggi"
echo -e " ${WH}[${COLOR1}•8${WH}]${NC} ${COLOR1} Statistik Penggunaan Setiap Jam"
echo -e " ${WH}[${COLOR1}•9${WH}]${NC} ${COLOR1} Lihat Penggunaan Aktif Saat Ini"
echo -e " ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1} Lihat Trafik Penggunaan Aktif Saat Ini [5s]"
echo -e ""
echo -e " [\e[31m•0${WH}]${NC} ${COLOR1} \e[31mBACK TO MENU${NC}"
echo -e " [\e[31m•x${WH}]${NC} ${COLOR1} Keluar"
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • TOTAL BANDWITH SERVER TERSISA • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
2)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • TOTAL BANDWITH SETIAP 5 MENIT • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -5
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
3)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}   • TOTAL BANDWITH SETIAP JAM •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -h
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
4)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP HARI •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -d
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
5)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP BULAN •  ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -m
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
6)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP TAHUN •  ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -y
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
7)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}    • TOTAL BANDWITH TERTINGGI •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -t
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
8)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • STATISTIK TERPAKAI SETIAP JAM • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -hg
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
9)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}     • LIVE BANDWITH SAAT INI •    ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e   " Press [ Ctrl+C ] • To-Exit"
echo -e ""
vnstat -l
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
10)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}• LIVE TRAFIK PENGGUNAAN BANDWITH •${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -tr
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
0)
sleep 1
menu
;;
x)
exit
;;
*)
echo -e ""
echo -e "Anda salah tekan"
sleep 1
bw
;;
esac
}
function limitspeed(){
clear
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(cat /home/limit)
NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');
function start () {
echo -e "Limit Speed All Service"
read -p "Set maximum download rate (in Kbps): " down
read -p "Set maximum upload rate (in Kbps): " up
if [[ -z "$down" ]] && [[ -z "$up" ]]; then
echo > /dev/null 2>&1
else
echo "Start Configuration"
sleep 0.5
wondershaper -a $NIC -d $down -u $up > /dev/null 2>&1
systemctl enable --now wondershaper.service
echo "start" > /home/limit
echo "Done"
fi
}
function stop () {
wondershaper -ca $NIC
systemctl stop wondershaper.service
echo "Stop Configuration"
sleep 0.5
echo > /home/limit
echo "Done"
}
if [[ "$cek" = "start" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "=================================="
echo -e "    Limit Bandwidth Speed $sts    "
echo -e "=================================="
echo -e "[1]. Start Limit"
echo -e "[2]. Stop Limit"
echo -e "==============================="
read -rp "Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
else
clear
echo " You Entered The Wrong Number"
menu
fi
}
function certv2ray(){
echo -e ""
echo start
sleep 0.5
source /var/lib/ipvps.conf
domain=$(cat /etc/xray/domain)
STOPWEBSERVER=$(lsof -i:89 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
rm -rf /root/.acme.sh
mkdir /root/.acme.sh
systemctl stop $STOPWEBSERVER
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --register-account -m rmbl@slowapp.cfd
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key  
systemctl restart nginx
systemctl restart xray
menu
}
function clearcache(){
clear
echo ""
echo ""
echo -e "[ \033[32mInfo\033[0m ] Clear RAM Cache"
echo 1 > /proc/sys/vm/drop_caches
sleep 3
echo -e "[ \033[32mok\033[0m ] Cache cleared"
echo ""
echo "Back to menu in 2 sec "
sleep 2
menu
}
function m-bot2(){
clear
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1  ${WH}Please select a Bot type below                 ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1  [ 1 ] ${WH}Buat/Edit BOT INFO Multi Login SSH, XRAY & TRANSAKSI   ${NC}"
echo -e ""
echo -e "$COLOR1  [ 2 ] ${WH}Buat/Edit BOT INFO Create User & Lain Lain    ${NC}"
echo -e ""
echo -e "$COLOR1  [ 3 ] ${WH}Buat/Edit BOT INFO Backup Telegram    ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
read -p "   Please select numbers 1-3 or Any Button(Random) to exit : " bot
echo ""
if [[ $bot == "1" ]]; then
clear
rm -rf /etc/perlogin
mkdir -p /etc/perlogin
cd /etc/perlogin
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Multi Login"
read -rp "Enter Token (Creat on @BotFather) : " -e token2
echo "$token2" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat
echo "$idat" > id
sleep 1
m-bot2
fi
if [[ $bot == "2" ]]; then
clear
rm -rf /etc/per
mkdir -p /etc/per
cd /etc/per
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Akun Dan Lain Lain"
read -rp "Enter Token (Creat on @BotFather) : " -e token3
echo "$token3" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat2
echo "$idat2" > id
sleep 1
m-bot2
fi
if [[ $bot == "3" ]]; then
clear
rm -rf /usr/bin/token
rm -rf /usr/bin/idchat
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Backup Telegram"
read -rp "Enter Token (Creat on @BotFather) : " -e token23
echo "$token23" > /usr/bin/token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idchat
echo "$idchat" > /usr/bin/idchat
sleep 1
m-bot2
fi
menu
}
function m-webmin() {
clear
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Installed]${Font_color_suffix}"
Error="${Red_font_prefix}[Not Installed]${Font_color_suffix}"
cek=$(netstat -ntlp | grep 10000 | awk '{print $7}' | cut -d'/' -f2)
function install () {
IP=$(wget -qO- ifconfig.me/ip);
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m        • INSTALL WEBMIN •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo -e "\033[32m[Info]\033[0m Adding Repository Webmin"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
apt install gnupg gnupg1 gnupg2 -y > /dev/null 2>&1
wget http://www.webmin.com/jcameron-key.asc > /dev/null 2>&1
apt-key add jcameron-key.asc > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Start Install Webmin"
sleep 0.5
apt update > /dev/null 2>&1
apt install webmin -y > /dev/null 2>&1
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
echo -e "\033[32m[Info]\033[0m Restart Webmin"
/etc/init.d/webmin restart > /dev/null 2>&1
rm -f /root/jcameron-key.asc > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Install Successfully !"
echo ""
echo " $IP:10000"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
function restart () {
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m        • RESTART WEBMIN •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo " Restarting Webmin"
service webmin restart > /dev/null 2>&1
echo ""
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Start Successfully !"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
function uninstall () {
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • UNINSTALL WEBMIN •        \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo -e "\033[32m[Info]\033[0m Removing Repositori Webmin"
rm -f /etc/apt/sources.list.d/webmin.list
apt update > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Start Uninstall Webmin"
apt autoremove --purge webmin -y > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Uninstall Successfully !"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
if [[ "$cek" = "perl" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m          • WEBMIN MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " Status $sts"
echo -e " [\e[36m•1\e[0m] Install Webmin"
echo -e " [\e[36m•2\e[0m] Restart Webmin"
echo -e " [\e[36m•3\e[0m] Uninstall Webmin"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -rp " Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
install
elif [[ "$num" = "2" ]]; then
restart
elif [[ "$num" = "3" ]]; then
uninstall
elif [[ "$num" = "0" ]]; then
menu
elif [[ "$num" = "x" ]]; then
exit
else
clear
echo " You Entered The Wrong Number"
sleep 2
m-webmin
fi
}
function speed(){
cd
if [[ -e /etc/speedi ]]; then
speedtest
else
sudo apt-get install curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
touch /etc/speedi
speedtest
fi
}
function gotopp(){
cd
if [[ -e /usr/bin/gotop ]]; then
gotop
else
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop &> /dev/null
/tmp/gotop/scripts/download.sh &> /dev/null
chmod +x /root/gotop
mv /root/gotop /usr/bin
gotop
fi
}
function coremenu(){
cd
if [[ -e /usr/local/bin/modxray ]]; then
echo -ne
else
wget -O /usr/local/bin/modxray https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit &> /dev/null
fi
cd
if [[ -e /usr/local/bin/offixray ]]; then
echo -ne
else
cp -r /usr/local/bin/xray /usr/local/bin/offixray &> /dev/null
fi
clear
echo -e " "
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set CORE MENU           ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}XRAY CORE OFFICIAL       ${NC}"
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 2 ]  ${WH}XRAY CORE MOD DHARAK    ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
until [[ $core =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-2 or Any Button(EXIT) : " core
done
if [[ $core == "1" ]]; then
clear
echo -e " "
cp -r /usr/local/bin/offixray /usr/local/bin/xray &> /dev/null
chmod 755 /usr/local/bin/xray
systemctl restart xray
echo -e "$COLOR1 [ INFO ] ${WH}Succes Change Xray Core Official"
fi
if [[ $core == "2" ]]; then
clear
echo -e " "
cp -r /usr/local/bin/modxray /usr/local/bin/xray &> /dev/null
chmod 755 /usr/local/bin/xray
systemctl restart xray
echo -e  "$COLOR1 [ INFO ] ${WH}Succes Change Xray Core Mod Dharak"
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function dobot(){
clear
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set           ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}INSTAL BOT CRATE AKUN DIGITAL OCEAN      ${NC}"
echo -e "$COLOR1│  [ 2 ]  ${WH}COPY BOT CREATE AKUN DIGITAL OCEAN   ${NC}"
if [[ -e /etc/cron.d/bantwidth ]]; then
echo -ne
else
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 3 ]  ${WH}SET BANTWIDTH BUAT JUALAN DIGITAL OCEAN${NC}"
fi
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
until [[ $dobot =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-3 or Any Button(BACK) : " dobot
done
if [[ $dobot == "1" ]]; then
clear
wget https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/dobot/install.sh &> /dev/null
chmod +x install.sh
bash install.sh
rm -rf install.sh
fi
if [[ $dobot == "2" ]]; then
clear
if [[ -e /etc/dobot ]]; then
echo -ne
else
echo -e " SILAHKAN INSTALL DULU BOT CREATE AKUN DIGITAL OCEAN NYA"
read -n 1 -s -r -p "Press any key to back on menu"
m-system
fi
until [[ $dobot2 =~ ^[0-9]+$ ]]; do
read -p "   SILAHKAN TULIS COPY BOTNYA CONTOH 1 atau 3 : " dobot2
done
if [[ -e /etc/dobot${dobot2} ]]; then
echo -e "Angka Copyan Sudah ADA Silahkan tulis Angka yg lain"
read -n 1 -s -r -p "Press any key to back on menu"
m-system
fi
cp -r /etc/dobot /etc/dobot${dobot2}
read -e -p "[*] Input your Nama Store : " nama
read -e -p "[*] Input your Bot Token : " bottoken
read -e -p "[*] Input Your Id Telegram :" admin
rm -rf /etc/dobot${dobot2}/config.json
cat > /etc/dobot${dobot2}/config.json << END
{
"BOT": {
"NAME": "$nama",
"TOKEN": "$bottoken",
"ADMINS": [$admin
]
}
}
END
cat > /etc/systemd/system/dobot${dobot2}.service << END
[Unit]
Description=SGDO
After=network.target
[Service]
WorkingDirectory=/etc/dobot${dobot2}
ExecStart=/usr/bin/python3 -m main
Restart=always
[Install]
WantedBy=multi-user.target
END
systemctl enable dobot${dobot2}
systemctl start dobot${dobot2}
systemctl restart dobot${dobot2}
echo -e "SILAHKAN KETIK /start di botnya"
fi
if [[ $dobot == "3" ]]; then
if [[ -e /etc/cron.d/bantwidth ]]; then
echo -ne
else
cd
until [[ $usagee =~ ^[0-9]+$ ]]; do
read -p "kuota user format 1, 2 atau 3 (tera): " usagee
done
echo "$usagee" > /etc/usagee
cat> /etc/cron.d/bantwidth << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/bin/bantwidth
END
echo "Auto-Shutdown $usagee TERA TURN ON."
sleep 1
fi
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function nameauthor(){
read -rp "Input Your New Name : " -e name
echo "$name" > /etc/profil
read -n 1 -s -r -p " Succes Change Press Any key to Back Menu"
menu
}
clear
echo -e " $COLOR1╔══════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC}${COLBG1}                 ${WH}• SYSTEM MENU •                      ${NC}$COLOR1║ $NC"
echo -e " $COLOR1╚══════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔══════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}CHANGE DOMAIN   ${WH}    ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}CHANGE BANNER ${WH}     $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}SPEEDTEST   ${WH}        ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}INSTALL ADBLOCK ${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}AUTO REBOOT   ${WH}      ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}CHANGE  BOT INFO${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}CHECK BANDWITH${WH}      ${WH}[${COLOR1}12${WH}]${NC} ${COLOR1}• ${WH}FIX NGINX OFF${WH}      $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}INSTALL WEBMIN${WH}      ${WH}[${COLOR1}13${WH}]${NC} ${COLOR1}• ${WH}CEK PERFORMA VPS ${WH}  $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}INSTALL TCP BBR ${WH}    ${WH}[${COLOR1}14${WH}]${NC} ${COLOR1}• ${WH}CHANGE CORE MENU${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}GANTI TEMA WARNA${WH}    ${WH}[${COLOR1}15${WH}]${NC} ${COLOR1}• ${WH}BOT DO MENU ${WH}       $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}LIMIT SPEED${WH}         ${WH}[${COLOR1}16${WH}]${NC} ${COLOR1}• ${WH}GANTI NAMA CLIENT${WH}  $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}GO BACK $NC            ${WH}[${COLOR1}99${WH}]${NC} ${COLOR1}• ${WH}CLEAR RAM CACHE ${WH}   $COLOR1║ $NC"
echo -e " $COLOR1╚══════════════════════════════════════════════════════╝${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 |1) clear ; add-host ; exit ;;
02 |2) clear ; speed ; exit ;;
03 |3) clear ; auto-reboot ; exit ;;
04 |4) clear ; bw ; exit ;;
05 |5) clear ; m-webmin ; exit ;;
06 |6) clear ; m-tcp ; exit ;;
07 |7) clear ; m-theme ; exit ;;
08 |8) clear ; limitspeed ; exit ;;
09 |9) clear ; nano /etc/issue.net ; exit ;;
10 |10) clear ; ins-helium ;;
11 |11) clear ; m-bot2 ; exit ;;
12 |12) clear ; certv2ray ; exit ;;
13 |13) clear ; gotopp ; exit ;;
14 |14) clear ; coremenu ; exit ;;
15 |15) clear ; dobot ; exit ;;
16 |16) clear ; nameauthor ; exit ;;
99 |99) clear ; clearcache ; exit ;;
00 |0) clear ; menu ; exit ;;
*) echo -e "" ; echo "Anda salah tekan" ; sleep 1 ; m-system ;;
esac
