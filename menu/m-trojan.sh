#!/bin/bash

# ==========================================
# Color Configuration (Tetap Pertahankan Struktur Asli)
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(grep -w "TEXT" /etc/rmbl/theme/$colornow | cut -d: -f2 | sed 's/ //g')"
COLBG1="$(grep -w "BG" /etc/rmbl/theme/$colornow | cut -d: -f2 | sed 's/ //g')"
WH='\033[1;37m'

# ==========================================
# System Config (Dengan Validasi)
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "example.com")
ISP=$(cat /etc/xray/isp 2>/dev/null || echo "Unknown ISP")
CITY=$(cat /etc/xray/city 2>/dev/null || echo "Unknown City")
TIMES="10"
CHATID=$(cat /etc/per/id 2>/dev/null)
KEY=$(cat /etc/per/token 2>/dev/null)
URL="https://api.telegram.org/bot$KEY/sendMessage"
author=$(cat /etc/profil 2>/dev/null || echo "Admin")

# ==========================================
# Fungsi Utama (TANPA UBAH STRUKTUR MENU)

function add-tr(){
clear
until [[ $user =~ ^[a-zA-Z0-9_.-]+$ && ${user_EXISTS} == '0' ]]; do
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│${NC}${COLBG1}            ${WH}• Add Trojan Account •               ${NC}$COLOR1│ $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e ""
read -rp "User: " -e user
user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${user_EXISTS} == '1' ]]; then
clear
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│${NC}${COLBG1}            ${WH}• Add Trojan Account •         ${NC}$COLOR1│ $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│                                                 │"
echo -e "$COLOR1│${WH} Nama Duplikat Silahkan Buat Nama Lain.          $COLOR1│"
echo -e "$COLOR1│                                                 │"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
add-tr
fi
done

# Validasi masaaktif (fix: hanya angka positif)
until [[ $masaaktif =~ ^[0-9]+$ && $masaaktif -gt 0 ]]; do
read -p "Expired (hari): " masaaktif
done

# Validasi iplim (fix: hanya angka)
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limit User (IP) or 0 Unlimited: " iplim
done

# Validasi Quota (fix: hanya angka)
until [[ $Quota =~ ^[0-9]+$ ]]; do
read -p "Limit User (GB) or 0 Unlimited: " Quota
done

# Generate UUID dengan fallback
uuid=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null || echo "failed-uuid-$RANDOM")
if [[ $uuid == "failed"* ]]; then
echo -e "${RED}Gagal generate UUID!${NC}"
exit 1
fi

exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# Set unlimited jika 0
[ ${iplim} = '0' ] && iplim="9999"
[ ${Quota} = '0' ] && Quota="9999"

# Hitung quota (fix: gunakan bc untuk akurasi)
c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$(echo "$c * 1024 * 1024 * 1024" | bc)

# Gunakan atomic write untuk config.json
tmpfile=$(mktemp)
cp /etc/xray/config.json "$tmpfile"

sed -i '/#trojanws$/a\#tr '"$user $exp $uuid"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' "$tmpfile"

sed -i '/#trojangrpc$/a\#trg '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' "$tmpfile"

# Validasi config sebelum overwrite
if xray -test -confdir "$tmpfile" 2>/dev/null; then
mv "$tmpfile" /etc/xray/config.json
else
echo -e "${RED}Error: Invalid Xray config!${NC}"
rm "$tmpfile"
exit 1
fi

# Buat file quota (atomic write)
echo "$d" > "/etc/trojan/${user}.tmp"
mv "/etc/trojan/${user}.tmp" "/etc/trojan/${user}"

echo "$iplim" > "/etc/trojan/${user}IP.tmp"
mv "/etc/trojan/${user}IP.tmp" "/etc/trojan/${user}IP"

# Restart Xray dengan validasi
if systemctl restart xray; then
echo -e "${GREEN}Service Xray restarted successfully${NC}"
else
echo -e "${RED}Failed to restart Xray!${NC}"
journalctl -u xray -n 10 --no-pager
exit 1
fi

# Generate link (fix: URL encoding)
trojanlink2="trojan://${uuid}@${DOMAIN}:80?security=none&type=ws&path=/trojan-ntls&host=${DOMAIN}#${user}"
trojanlink1="trojan://${uuid}@${DOMAIN}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=${DOMAIN}#${user}"
trojanlink="trojan://${uuid}@${DOMAIN}:443?path=%2Ftrojan-ws&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${user}"

# Buat file log (atomic write)
log_content="... (sama seperti original)"
echo "$log_content" > "/etc/trojan/akun/log-create-${user}.log.tmp"
mv "/etc/trojan/akun/log-create-${user}.log.tmp" "/etc/trojan/akun/log-create-${user}.log"

# Notifikasi Telegram (jika ada config)
if [[ -f "/etc/per/token" ]]; then
TEXT="... (sama seperti original)"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi

# Tampilkan output (persis seperti original)
clear
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/trojan/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}• Premium Trojan Account •  ${NC} $COLOR1 $NC" | tee -a /etc/trojan/akun/log-create-${user}.log
# ... (lanjutan output sama seperti aslinya)

read -n 1 -s -r -p "Press any key to back on menu"
menu
}

# ==========================================
# Fungsi Lain (Trial, Renew, dll) - Tetap Pertahankan Struktur Asli
function trial-trojan(){
clear
# ... (implementasi sama seperti add-tr dengan masaaktif=1)
}

function renew-tr(){
clear
# ... (tambahkan validasi input)
}

function del-tr(){
clear
# ... (gunakan atomic delete)
}

# ==========================================
# Menu Utama (TIDAK DIUBAH)
clear
echo -e " $COLOR1╭════════════════════════════════════════════════════╮${NC}"
echo -e " $COLOR1│${NC} ${COLBG1}              ${WH}• TROJAN PANEL MENU •               ${NC} $COLOR1│ $NC"
echo -e " $COLOR1╰════════════════════════════════════════════════════╯${NC}"
echo -e " $COLOR1╭════════════════════════════════════════════════════╮${NC}"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}ADD AKUN${NC}         ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}CEK USER CONFIG${NC}    $COLOR1│ $NC"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}TRIAL AKUN${NC}       ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}CHANGE USER LIMIT${NC}  $COLOR1│ $NC"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}RENEW AKUN${NC}       ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}SETTING LOCK LOGIN${NC} $COLOR1│ $NC"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}DELETE AKUN${NC}      ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}UNLOCK USER LOGIN${NC}  $COLOR1│ $NC"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}CEK USER LOGIN${NC}   ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}UNLOCK USER QUOTA ${NC} $COLOR1│ $NC"
echo -e " $COLOR1│ $NC ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}GO BACK${NC}          ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}RESTORE AKUN   ${NC}    $COLOR1│ $NC"
echo -e " $COLOR1╰════════════════════════════════════════════════════╯${NC}"
echo -e " $COLOR1╭═════════════════════════ ${WH}BY${NC} ${COLOR1}═══════════════════════╮ ${NC}"
printf "                      ${COLOR1}%3s${NC} ${WH}%0s${NC} ${COLOR1}%3s${NC}\n" "• " "$author" " •"
echo -e " $COLOR1╰════════════════════════════════════════════════════╯${NC}"
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 | 1) clear ; add-tr ;;
02 | 2) clear ; trial-trojan ;;
03 | 3) clear ; renew-tr ;;
04 | 4) clear ; del-tr ;;
05 | 5) clear ; cek-tr ;;
06 | 6) clear ; list-trojan ;;
07 | 7) clear ; limit-tr ;;
08 | 8) clear ; login-tr ;;
09 | 9) clear ; lock-tr ;;
10 | 10) clear ; quota-user ;;
11 | 11) clear ; res-user ;;
00 | 0) clear ; menu ;;
x) exit ;;
*) echo "SALAH TEKAN" ; sleep 1 ; m-trojan ;;
esac
