#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
######=#####- COLOR CODE -########=######
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
############- END COLOR CODE -###########
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                 ${WH}⇱ UPDATE ⇲                    ${NC} $COLOR1 $NC"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}⇱ SCRIPT TERBARU ⇲                ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"


#hapus menu
rm -rf restore
rm -rf m-trgo
rm -rf backup
rm -rf menu
rm -rf addnoobz
rm -rf cek-noobz
rm -rf m-noobz
rm -rf m-vmess
rm -rf m-vless
rm -rf m-trojan
rm -rf m-system
rm -rf m-sshovpn
rm -rf m-ssws
rm -rf running
rm -rf m-update
rm -rf m-backup
rm -rf m-theme
rm -rf m-ip
rm -rf m-bot
rm -rf update
rm -rf ws-dropbear
rm -rf bckpbot
rm -rf tendang
rm -rf bottelegram
rm -rf restore
rm -rf backup
rm -rf cleaner
rm -rf m-allxray
rm -rf xraylimit
rm -rf xp
rm -rf trialvmess
rm -rf trialvless
rm -rf trialtrojan
rm -rf trialssh
rm -rf bantwidth

# download menu
cd /usr/bin
rm -rf restore
rm -rf m-trgo
rm -rf backup
rm -rf menu
rm -rf addnoobz
rm -rf cek-noobz
rm -rf m-noobz
rm -rf m-vmess
rm -rf m-vless
rm -rf m-trojan
rm -rf m-system
rm -rf m-sshovpn
rm -rf m-ssws
rm -rf running
rm -rf m-backup
rm -rf m-theme
rm -rf m-ip
rm -rf m-bot
rm -rf update
rm -rf ws-dropbear
rm -rf bckpbot
rm -rf tendang
rm -rf bottelegram
rm -rf restore
rm -rf backup
rm -rf cleaner
rm -rf m-allxray
rm -rf xraylimit
rm -rf xp
rm -rf trialvmess
rm -rf trialvless
rm -rf trialtrojan
rm -rf trialssh
rm -rf autocpu
rm -rf bantwidth


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
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
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
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}
res1() {
    
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/m-trgo "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-trgo.sh" && chmod +x /usr/bin/m-trgo
wget -q -O /usr/bin/restore "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/restore.sh" && chmod +x /usr/bin/restore
wget -q -O /usr/bin/backup "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/backup.sh" && chmod +x /usr/bin/backup
wget -q -O /usr/bin/addnoobz "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/bot/addnoobz.sh" && chmod +x /usr/bin/addnoobz
wget -q -O /usr/bin/cek-noobz "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/bot/cek-noobz.sh" && chmod +x /usr/bin/cek-noobz
wget -q -O /usr/bin/m-noobz "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-noobz.sh" && chmod +x /usr/bin/m-noobz
wget -q -O /usr/bin/m-ip "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-ip.sh" && chmod +x /usr/bin/m-ip
wget -q -O /usr/bin/m-bot "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-bot.sh" && chmod +x /usr/bin/m-bot
wget -q -O /usr/bin/m-theme "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-theme.sh" && chmod +x /usr/bin/m-theme
wget -q -O /usr/bin/m-vmess "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-vmess.sh" && chmod +x /usr/bin/m-vmess
wget -q -O /usr/bin/m-vless "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-vless.sh" && chmod +x /usr/bin/m-vless
wget -q -O /usr/bin/m-trojan "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-trojan.sh" && chmod +x /usr/bin/m-trojan
wget -q -O /usr/bin/m-system "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-system.sh" && chmod +x /usr/bin/m-system
wget -q -O /usr/bin/m-sshovpn "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-sshovpn.sh" && chmod +x /usr/bin/m-sshovpn
wget -q -O /usr/bin/running "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/running.sh" && chmod +x /usr/bin/running
wget -q -O /usr/bin/m-backup "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/m-backup.sh" && chmod +x /usr/bin/m-backup
wget -q -O /usr/bin/speedtest "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/speedtest_cli.py" && chmod +x /usr/bin/speedtest
wget -q -O /usr/bin/bckpbot "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/bckpbot.sh" && chmod +x /usr/bin/bckpbot
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/tendang.sh" && chmod +x /usr/bin/tendang
wget -q -O /usr/bin/bottelegram "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/bottelegram.sh" && chmod +x /usr/bin/bottelegram
wget -q -O /usr/bin/xraylimit "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/xraylimit.sh" && chmod +x /usr/bin/xraylimit
wget -q -O /usr/bin/trialvmess "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/trialvmess.sh" && chmod +x /usr/bin/trialvmess
wget -q -O /usr/bin/trialvless "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/trialtrojan.sh" && chmod +x /usr/bin/trialtrojan
wget -q -O /usr/bin/trialtrojan "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/trialvless.sh" && chmod +x /usr/bin/trialvless
wget -q -O /usr/bin/trialssh "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu/trialssh.sh" && chmod +x /usr/bin/trialssh
wget -q -O /usr/bin/autocpu "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/install/autocpu.sh" && chmod +x /usr/bin/autocpu
wget -q -O /usr/bin/bantwidth "https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/install/bantwidth" && chmod +x /usr/bin/bantwidth
chmod +x menu
chmod +x m-vmess
chmod +x m-vless
chmod +x m-trojan
chmod +x m-system
chmod +x m-sshovpn
chmod +x running
chmod +x m-backup
chmod +x m-theme
chmod +x m-ip
chmod +x m-bot
chmod +x bckpbot
chmod +x tendang
chmod +x bottelegram
chmod +x backup
chmod +x restore
chmod +x cleaner
chmod +x xraylimit
chmod +x xp
chmod +x trialvmess
chmod +x trialvless
chmod +x trialtrojan
chmod +x trialssh
chmod +x autocpu
chmod +x bantwidth
cd
rm -rf *
clear

}
echo -e ""
echo -e "  \033[1;91m Update Script...\033[1;37m"
fun_bar 'res1'

echo -e ""
cd
menu
