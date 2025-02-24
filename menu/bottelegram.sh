#!/bin/bash

# Mendapatkan tanggal dari server
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")

# Menentukan tema warna
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(grep -w "TEXT" /etc/rmbl/theme/$colornow | cut -d: -f2 | sed 's/ //g')"
COLBG1="$(grep -w "BG" /etc/rmbl/theme/$colornow | cut -d: -f2 | sed 's/ //g')"
WH='\033[1;37m'

# Mengambil IP VPS dengan metode alternatif
ipsaya=$(curl -s https://api.ipify.org || curl -s https://checkip.amazonaws.com || curl -s https://icanhazip.com)

# Cek apakah IP berhasil diambil
if [[ -z "$ipsaya" ]]; then
    echo -e "\033[0;31mGagal mendapatkan IP VPS!\033[0m"
    exit 1
fi

echo -e "\033[0;32mIP VPS: $ipsaya\033[0m"

# Mengambil tanggal server dari Google
data_server=$(curl -sI https://google.com/ | grep -i "^date:" | sed -e 's/Date: //I')

# Konversi ke format yang bisa dibaca
if [[ -n "$data_server" ]]; then
    date_list=$(date +"%Y-%m-%d" -d "$data_server")
else
    echo -e "\033[0;31mGagal mendapatkan tanggal dari server!\033[0m"
    exit 1
fi

echo -e "\033[0;32mTanggal Server: $date_list\033[0m"

# URL daftar IP izin
data_ip="https://raw.githubusercontent.com/RyyStore/permission/main/ip"

# Fungsi untuk memeriksa izin script
checking_sc() {
    useexp=$(curl -sS "$data_ip" | grep -w "$ipsaya" | awk '{print $3}')

    if [[ -z "$useexp" ]]; then
        echo -e "\033[0;31mIP tidak ditemukan dalam daftar izin!\033[0m"
        exit 1
    fi

    if [[ "$date_list" < "$useexp" ]]; then
        echo -e "\033[0;32mAkses diperbolehkan hingga: $useexp\033[0m"
    else
        echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
        echo -e "$COLOR1│${NC} ${COLBG1}         ${WH}• AUTOSCRIPT PREMIUM •                ${NC} $COLOR1│ $NC"
        echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
        echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
        echo -e "$COLOR1│            ${COLOR1}PERMISSION DENIED !${NC}                  │"
        echo -e "$COLOR1│   \033[0;33mYour VPS${NC} $ipsaya \033[0;33mHas been Banned${NC}          │"
        echo -e "$COLOR1│     \033[0;33mBuy access permissions for scripts${NC}      │"
        echo -e "$COLOR1│             \033[0;33mContact Your Admin ${NC}              │"
        echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
        exit 1
    fi
}

# Menjalankan fungsi pengecekan
checking_sc
IP=$(curl -sS ipv4.icanhazip.com);
date=$(date +"%Y-%m-%d")
time=$(date +'%H:%M:%S')
domain=$(cat /etc/xray/domain)
token=$(cat /usr/bin/token)
id_chat=$(cat /usr/bin/idchat)
clear
sleep 1
echo -e "${COLOR1}[ INFO ] ${WH}Processing... "
mkdir -p /root/backup
echo -e "${COLOR1}[ INFO ] ${WH}Mohon Ditunggu... "
wget -O /root/backup/ipmini https://raw.githubusercontent.com/RyyStore/permission/main/ip &> /dev/null
cp -r /etc/passwd /root/backup/ &> /dev/null
cp -r /etc/group /root/backup/ &> /dev/null
cp -r /etc/shadow /root/backup/ &> /dev/null
cp -r /etc/gshadow /root/backup/ &> /dev/null
cp -r /usr/bin/idchat /root/backup/ &> /dev/null
cp -r /usr/bin/token /root/backup/ &> /dev/null
cp -r /etc/per/id /root/backup/ &> /dev/null
cp -r /etc/per/token /root/backup/token2 &> /dev/null
cp -r /etc/perlogin/id /root/backup/loginid &> /dev/null
cp -r /etc/perlogin/token /root/backup/logintoken &> /dev/null
cp -r /etc/xray/config.json /root/backup/xray &> /dev/null
cp -r /etc/xray/ssh /root/backup/ssh &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html &> /dev/null
cp -r /etc/xray/sshx /root/backup/sshx &> /dev/null
cp -r /etc/vmess /root/backup/vmess &> /dev/null
cp -r /etc/vless /root/backup/vless &> /dev/null
cp -r /etc/trojan /root/backup/trojan &> /dev/null
cp -r /etc/issue.net /root/backup/issue &> /dev/null
cd /root
zip -r $IP.zip backup > /dev/null 2>&1
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
curl -F chat_id="$id_chat" -F document=@"$IP.zip" -F caption="Thank You For Using this Script
Domain : $domain
IP VPS : $IP
Date   : $date
Time   : $time WIB
Link Google : $link" https://api.telegram.org/bot$token/sendDocument &> /dev/null
rm -fr /root/backup &> /dev/null
rm -fr /root/user-backup &> /dev/null
rm -f /root/$NameUser.zip &> /dev/null
rm -r /root/$IP-$date.zip &> /dev/null
rm -f /root/$IP.zip &> /dev/null
echo " Please Check Your BOT"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
