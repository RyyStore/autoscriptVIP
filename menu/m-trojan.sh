#!/bin/bash

# ==========================================
# Color Configuration
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

# ==========================================
# System Configuration
DOMAIN=$(cat /etc/xray/domain 2>/dev/null)
ISP=$(cat /etc/xray/isp 2>/dev/null)
CITY=$(cat /etc/xray/city 2>/dev/null)
DATE=$(date +"%Y-%m-%d")
AUTHOR=$(cat /etc/profil 2>/dev/null)

# ==========================================
# Telegram Notification Config (Optional)
TIMES="10"
CHATID=$(cat /etc/per/id 2>/dev/null)
KEY=$(cat /etc/per/token 2>/dev/null)
URL="https://api.telegram.org/bot$KEY/sendMessage"

# ==========================================
# Function to Validate Input
validate_input() {
    local input="$1"
    local type="$2"
    
    case "$type" in
        "username")
            if [[ ! "$input" =~ ^[a-zA-Z0-9_]+$ ]]; then
                echo -e "${RED}Error: Username hanya boleh huruf, angka, dan underscore${NC}"
                return 1
            fi
            ;;
        "number")
            if [[ ! "$input" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}Error: Input harus angka${NC}"
                return 1
            fi
            ;;
        "expiry")
            if [[ ! "$input" =~ ^[0-9]+$ || "$input" -lt 1 ]]; then
                echo -e "${RED}Error: Masa aktif minimal 1 hari${NC}"
                return 1
            fi
            ;;
    esac
    return 0
}

# ==========================================
# Add Trojan Account
add-tr() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}          • TAMBAH AKUN TROJAN •          ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Username Validation
    while true; do
        read -p "Masukkan Username: " user
        if validate_input "$user" "username"; then
            if grep -q "$user" /etc/xray/config.json; then
                echo -e "${RED}Username sudah digunakan!${NC}"
            else
                break
            fi
        fi
    done

    # Expiry Validation
    while true; do
        read -p "Masa Aktif (hari): " masaaktif
        validate_input "$masaaktif" "expiry" && break
    done

    # IP Limit Validation
    while true; do
        read -p "Limit IP (0 = Unlimited): " iplim
        validate_input "$iplim" "number" && break
    done

    # Quota Validation
    while true; do
        read -p "Limit Quota (GB, 0 = Unlimited): " Quota
        validate_input "$Quota" "number" && break
    done

    # Generate UUID
    uuid=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null)
    if [ -z "$uuid" ]; then
        echo -e "${RED}Gagal generate UUID!${NC}"
        exit 1
    fi

    # Calculate Expiry Date
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    # Set Unlimited if 0
    [ "$iplim" == "0" ] && iplim="999999"
    [ "$Quota" == "0" ] && Quota="999999"

    # Calculate Quota in Bytes
    quota_bytes=$(($Quota * 1024 * 1024 * 1024))

    # Create Quota File
    echo "$quota_bytes" > "/etc/trojan/$user"
    echo "$iplim" > "/etc/trojan/${user}IP"

    # Add User to Config (Atomic Operation)
    (
        flock -x 200
        sed -i '/#trojanws$/a\#tr '"$user $exp $uuid"'\
        },{"password": "'"$uuid"'","email": "'"$user"'"' /etc/xray/config.json
        sed -i '/#trojangrpc$/a\#trg '"$user $exp"'\
        },{"password": "'"$uuid"'","email": "'"$user"'"' /etc/xray/config.json
    ) 200>/etc/xray/config.lock

    # Restart Xray if Config is Valid
    if xray -test -confdir /etc/xray 2>/dev/null; then
        systemctl restart xray
    else
        echo -e "${RED}Error: Gagal restart Xray, config tidak valid!${NC}"
        exit 1
    fi

    # Generate Trojan Links
    trojan_ws="trojan://${uuid}@${DOMAIN}:443?path=%2Ftrojan-ws&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${user}"
    trojan_grpc="trojan://${uuid}@${DOMAIN}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=${DOMAIN}#${user}"

    # Save Config to File
    cat > "/home/vps/public_html/trojan-$user.txt" <<-EOF
==========================
      TROJAN ACCOUNT
==========================
Domain: $DOMAIN
Username: $user
UUID: $uuid
Expired: $exp
IP Limit: $iplim
Quota: $Quota GB
==========================
Link WS (CDN):
$trojan_ws
==========================
Link gRPC:
$trojan_grpc
==========================
EOF

    # Send Notification (Telegram)
    if [ -f "/etc/per/token" ]; then
        TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  TROJAN ACCOUNT CREATED</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN:</b> <code>$DOMAIN</code>
<b>USERNAME:</b> <code>$user</code>
<b>EXPIRED:</b> <code>$exp</code>
<b>IP LIMIT:</b> <code>$iplim</code>
<b>QUOTA:</b> <code>$Quota GB</code>
<code>◇━━━━━━━━━━━━━━◇</code>
"
        curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
    fi

    # Show Success Message
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ AKUN TROJAN BERHASIL DIBUAT ✅${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Username: $user"
    echo -e "Expired: $exp"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    sleep 3
    menu-trojan
}

# ==========================================
# Trial Trojan Account
trial-trojan() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}        • TRIAL AKUN TROJAN •        ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━��━━━━━━━━━━━━━━━${NC}"

    # Set Default Trial Config
    user="trial-$(</dev/urandom tr -dc a-z0-9 | head -c4)"
    masaaktif=1
    iplim=1
    Quota=1

    # Generate UUID
    uuid=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null)
    if [ -z "$uuid" ]; then
        echo -e "${RED}Gagal generate UUID!${NC}"
        exit 1
    fi

    # Calculate Expiry Date
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    # Create Quota File
    quota_bytes=$(($Quota * 1024 * 1024 * 1024))
    echo "$quota_bytes" > "/etc/trojan/$user"
    echo "$iplim" > "/etc/trojan/${user}IP"

    # Add User to Config (Atomic Operation)
    (
        flock -x 200
        sed -i '/#trojanws$/a\#tr '"$user $exp $uuid"'\
        },{"password": "'"$uuid"'","email": "'"$user"'"' /etc/xray/config.json
        sed -i '/#trojangrpc$/a\#trg '"$user $exp"'\
        },{"password": "'"$uuid"'","email": "'"$user"'"' /etc/xray/config.json
    ) 200>/etc/xray/config.lock

    # Restart Xray if Config is Valid
    if xray -test -confdir /etc/xray 2>/dev/null; then
        systemctl restart xray
    else
        echo -e "${RED}Error: Gagal restart Xray, config tidak valid!${NC}"
        exit 1
    fi

    # Generate Trojan Links
    trojan_ws="trojan://${uuid}@${DOMAIN}:443?path=%2Ftrojan-ws&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${user}"
    trojan_grpc="trojan://${uuid}@${DOMAIN}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=${DOMAIN}#${user}"

    # Save Config to File
    cat > "/home/vps/public_html/trojan-$user.txt" <<-EOF
==========================
      TROJAN TRIAL
==========================
Domain: $DOMAIN
Username: $user
UUID: $uuid
Expired: $exp
IP Limit: $iplim
Quota: $Quota GB
==========================
Link WS (CDN):
$trojan_ws
==========================
Link gRPC:
$trojan_grpc
==========================
EOF

    # Send Notification (Telegram)
    if [ -f "/etc/per/token" ]; then
        TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  TROJAN TRIAL CREATED</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN:</b> <code>$DOMAIN</code>
<b>USERNAME:</b> <code>$user</code>
<b>EXPIRED:</b> <code>$exp</code>
<code>◇━━━━━━━━━━━━━━◇</code>
"
        curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
    fi

    # Show Success Message
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ TRIAL TROJAN BERHASIL DIBUAT ✅${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Username: $user"
    echo -e "Expired: $exp"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    sleep 3
    menu-trojan
}

# ==========================================
# Main Trojan Menu
menu-trojan() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}      • TROJAN ACCOUNT MANAGER •      ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "1. Tambah Akun Trojan"
    echo -e "2. Trial Akun Trojan"
    echo -e "3. Kembali ke Menu Utama"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Pilih menu [1-3]: " opt
    case $opt in
        1) add-tr ;;
        2) trial-trojan ;;
        3) menu ;;
        *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1; menu-trojan ;;
    esac
}

# ==========================================
# Start Trojan Menu
menu-trojan
