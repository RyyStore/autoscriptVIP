#!/bin/bash
# Installer untuk xray_auto_cleanup
# By RyyStore

echo "Menginstal Xray Auto Cleanup..."

# Buat file utama
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Script untuk menghapus akun expired (vmess, vless, trojan)
# By RyyStore

LOG_FILE="/var/log/xray_auto_cleanup.log"
XRAY_CONFIG="/etc/xray/config.json"

# Fungsi log
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# Load env
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Daftar tag
tags_vmess=("#vm" "#vmg")
tags_vless=("#vl" "#vlg")
tags_trojan=("#tr" "#trg")

# Fungsi utama cleanup
cleanup_expired() {
    local type=$1
    local tags=("${!2}")
    local log_prefix=$3

    current_date=$(date +%s)
    log "$log_prefix Starting cleanup..."

    deleted=0

    for tag in "${tags[@]}"; do
        accounts=($(grep -E "^${tag} " "$XRAY_CONFIG" | awk '{print $2,$3,$4}'))
        
        for ((i=0; i<${#accounts[@]}; i+=3)); do
            user=${accounts[i]}
            exp_date=${accounts[i+1]}
            uuid=${accounts[i+2]}

            exp_seconds=$(date -d "$exp_date" +%s 2>/dev/null) || continue

            if [[ $exp_seconds -lt $current_date ]]; then
                log "$log_prefix Deleting $type account: $user (Expired: $exp_date)"

                echo "### $user $exp_date $uuid" >> "/etc/$type/akundelete"

                sed -i "/^${tag} $user $exp_date/,/\"email\": \"$user\"/d" "$XRAY_CONFIG"

                rm -f "/etc/$type/${user}" "/etc/$type/${user}IP" "/home/vps/public_html/$type-$user.txt" 2>/dev/null

                ((deleted++))
            fi
        done
    done

    log "$log_prefix Deleted $deleted expired $type accounts"
}

# Eksekusi utama
{
    echo "======================================"
    log "Starting Xray Auto Cleanup"

    cleanup_expired "vmess" tags_vmess[@] "[VMESS]"
    cleanup_expired "vless" tags_vless[@] "[VLESS]"
    cleanup_expired "trojan" tags_trojan[@] "[TROJAN]"

    # Restart xray jika ada penghapusan
    if grep -q "Deleted [1-9]" $LOG_FILE; then
        systemctl restart xray
        log "Xray service restarted"
    fi

    log "Cleanup completed"
    echo "======================================"
} | tee -a $LOG_FILE
EOF

# Buat file log
touch /var/log/xray_auto_cleanup.log
chmod 644 /var/log/xray_auto_cleanup.log

# Set permission
chmod +x /usr/local/bin/xray_auto_cleanup

# Tambahkan ke cron
cat <<EOF > /etc/cron.d/xray_auto_cleanup
# Cleanup expired accounts daily at 00:00
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 0 * * * root /usr/local/bin/xray_auto_cleanup
EOF

echo "Cronjob dibuat di /etc/cron.d/xray_auto_cleanup"

# Test awal
echo "Menjalankan test pertama..."
/usr/local/bin/xray_auto_cleanup

echo "Instalasi selesai. Log tersedia di /var/log/xray_auto_cleanup.log"
