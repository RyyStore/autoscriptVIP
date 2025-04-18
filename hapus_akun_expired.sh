#!/bin/bash
# Skrip untuk menghapus akun yang sudah kadaluarsa

# Mendefinisikan warna untuk tampilan
COLOR1='\033[0;33m'
NC='\033[0m'
WH='\033[1;37m'
COLBG1='\033[1;44m'

# Mendapatkan tanggal saat ini dalam format epoch
current_date=$(date +%s)

echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}        ${WH}• Deleting Expired Accounts •      ${NC} $COLOR1│ $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"

echo -e "Current date (epoch): $current_date"

# Mengambil akun-akun dari file config.json untuk VMess, Trojan, dan Vless
mapfile -t vmess_accounts < <(grep -E "^#vmg " "/etc/xray/config.json")
mapfile -t trojan_accounts < <(grep -E "^#tg " "/etc/xray/config.json")
mapfile -t vless_accounts < <(grep -E "^#vl " "/etc/xray/config.json")

# Mengecek apakah ada akun
if [[ ${#vmess_accounts[@]} -eq 0 && ${#trojan_accounts[@]} -eq 0 && ${#vless_accounts[@]} -eq 0 ]]; then
    echo -e "$COLOR1│${NC} No accounts found! ${NC}"
    exit 1
fi

deleted=0

# Fungsi untuk menghapus akun berdasarkan tipe
delete_account() {
    local account_type="$1"
    local accounts=("${!2}")
    for account in "${accounts[@]}"; do
        user=$(echo "$account" | awk '{print $2}')
        exp_date=$(echo "$account" | awk '{print $3}')
        uuid=$(echo "$account" | awk '{print $4}')

        # Konversi tanggal kadaluarsa ke epoch
        exp_seconds=$(date -d "$exp_date" +%s 2>/dev/null)

        if [[ $? -ne 0 ]]; then
            echo -e "$COLOR1│${NC} Invalid date format for user: $user, date: $exp_date ${NC}"
            continue
        fi

        echo -e "$COLOR1│${NC} Checking user: $user, Exp: $exp_date, UUID: $uuid ${NC}"

        # Jika akun sudah expired
        if [[ $exp_seconds -lt $current_date ]]; then
            echo -e "$COLOR1│${NC} Deleting account: $user (Expired: $exp_date) ${NC}"

            # Menghapus akun dari config.json berdasarkan tipe
            if [[ "$account_type" == "vmess" ]]; then
                sed -i "/^#vmg $user $exp_date $uuid/,/^},{/d" /etc/xray/config.json
                sed -i "/^#vm $user $exp_date/,/^},{/d" /etc/xray/config.json
            elif [[ "$account_type" == "trojan" ]]; then
                sed -i "/^#tg $user $exp_date $uuid/,/^},{/d" /etc/xray/config.json
                sed -i "/^#tg $user $exp_date/,/^},{/d" /etc/xray/config.json
            elif [[ "$account_type" == "vless" ]]; then
                sed -i "/^#vl $user $exp_date $uuid/,/^},{/d" /etc/xray/config.json
                sed -i "/^#vl $user $exp_date/,/^},{/d" /etc/xray/config.json
            fi

            # Hapus file terkait dengan akun
            rm -f /etc/vmess/${user}IP /etc/vmess/${user} /home/vps/public_html/vmess-$user.txt 2>/dev/null
            rm -f /etc/trojan/${user}IP /etc/trojan/${user} /home/vps/public_html/trojan-$user.txt 2>/dev/null
            rm -f /etc/vless/${user}IP /etc/vless/${user} /home/vps/public_html/vless-$user.txt 2>/dev/null

            ((deleted++))
        else
            echo -e "$COLOR1│${NC} User: $user is still active until $exp_date ${NC}"
        fi
    done
}

# Menghapus akun VMess, Trojan, dan Vless
delete_account "vmess" vmess_accounts[@]
delete_account "trojan" trojan_accounts[@]
delete_account "vless" vless_accounts[@]

# Restart Xray service setelah penghapusan
systemctl restart xray

if [[ $? -ne 0 ]]; then
    echo -e "$COLOR1│${NC} Failed to restart xray service! ${NC}"
fi

# Menampilkan jumlah akun yang dihapus
if [[ $deleted -eq 0 ]]; then
    echo -e "$COLOR1│${NC} No expired accounts found. ${NC}"
else
    echo -e "$COLOR1│${NC} Successfully deleted $deleted expired account(s). ${NC}"
fi

echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
