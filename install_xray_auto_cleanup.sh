#!/bin/bash
# Installer otomatis untuk Xray Auto Cleanup

echo "=== Memulai instalasi Xray Auto Cleanup ==="

# Buat file script cleanup
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Script untuk menghapus akun expired (vmess, vless, trojan)

LOG_FILE="/var/log/xray_auto_cleanup.log"
XRAY_CONFIG="/etc/xray/config.json"

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cleanup_expired() {
    local type=$1
    local tag=$2
    local log_prefix=$3
    
    current_date=$(date +%s)
    log "$log_prefix Starting cleanup..."
    
    accounts=($(grep -E "^${tag} " "$XRAY_CONFIG" | awk '{print $2,$3,$4}'))
    deleted=0

    for ((i=0; i<${#accounts[@]}; i+=3)); do
        user=${accounts[i]}
        exp_date=${accounts[i+1]}
        uuid=${accounts[i+2]}
        
        exp_seconds=$(date -d "$exp_date" +%s 2>/dev/null) || continue
        
        if [[ $exp_seconds -lt $current_date ]]; then
            log "$log_prefix Deleting $type account: $user (Expired: $exp_date)"
            echo "### $user $exp_date $uuid" >> "/etc/$type/akundelete"
            sed -i "/^${tag} $user $exp_date/,/^},{/d" "$XRAY_CONFIG"
            rm -f "/etc/$type/${user}" "/etc/$type/${user}IP" "/home/vps/public_html/$type-$user.txt" 2>/dev/null
            ((deleted++))
        fi
    done
    
    log "$log_prefix Deleted $deleted expired $type accounts"
}

{
    echo "======================================"
    log "Starting Xray Auto Cleanup"
    cleanup_expired "vmess" "#vmg" "[VMESS]"
    cleanup_expired "vless" "#vlg" "[VLESS]"
    cleanup_expired "trojan" "#trg" "[TROJAN]"

    if grep -q "Deleted [1-9]" $LOG_FILE; then
        systemctl restart xray
        log "Xray service restarted"
    fi

    log "Cleanup completed"
    echo "======================================"
} | tee -a $LOG_FILE
EOF

# Beri izin eksekusi
chmod +x /usr/local/bin/xray_auto_cleanup

# Buat cronjob
cat <<EOF > /etc/cron.d/xray_auto_cleanup
# Cleanup expired accounts daily at 00:00
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 0 * * * root /usr/local/bin/xray_auto_cleanup
EOF

# Buat log file
touch /var/log/xray_auto_cleanup.log
chmod 644 /var/log/xray_auto_cleanup.log

echo "=== Instalasi selesai. Menjalankan tes manual... ==="
bash /usr/local/bin/xray_auto_cleanup

echo "=== Cek log dengan perintah: tail -f /var/log/xray_auto_cleanup.log ==="
