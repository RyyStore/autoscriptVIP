#!/bin/bash
# Xray Auto Cleanup Installer - Fixed Version

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root" >&2
  exit 1
fi

# Check Xray
if ! command -v xray &> /dev/null; then
  echo "Error: Xray is not installed on this system"
  exit 1
fi

echo "Installing Xray Auto Cleanup..."

# Create main script
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Xray Auto Cleanup Script - Fixed Version

LOG_FILE="/var/log/xray_auto_cleanup.log"
XRAY_CONFIG="/etc/xray/config.json"

# Improved log function
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Better date validation
validate_date() {
    local date_str=$1
    if [[ "$date_str" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        date -d "$date_str" +%s &>/dev/null && return 0 || return 1
    else
        return 1
    fi
}

# Main cleanup function
cleanup() {
    local protocol=$1
    local tag=$2
    
    log "[${protocol^^}] Starting cleanup for tag: $tag"
    deleted=0
    errors=0

    # Process each account
    while read -r line; do
        user=$(echo "$line" | awk '{print $2}')
        exp_date=$(echo "$line" | awk '{print $3}')
        uuid=$(echo "$line" | awk '{print $4}')

        if validate_date "$exp_date"; then
            exp_seconds=$(date -d "$exp_date" +%s)
            current_seconds=$(date +%s)
            
            if [[ $exp_seconds -lt $current_seconds ]]; then
                log "[${protocol^^}] Deleting expired account: $user (Expired: $exp_date)"
                
                # Backup account info
                mkdir -p "/etc/xray/backup"
                echo "$protocol $user $exp_date $uuid" >> "/etc/xray/backup/deleted_$(date +%F).log"
                
                # Remove from config
                sed -i "/^${tag} ${user} ${exp_date}/,/^#${tag}/d" "$XRAY_CONFIG" && \
                sed -i "/\"email\": \"${user}\"/,/},/d" "$XRAY_CONFIG"
                
                ((deleted++))
            fi
        else
            log "[${protocol^^}] WARNING: Invalid date format for $user - $exp_date"
            ((errors++))
        fi
    done < <(grep -E "^${tag} " "$XRAY_CONFIG")

    log "[${protocol^^}] Deleted $deleted accounts, $errors errors"
}

# Main execution
{
    echo "======================================"
    log "Xray Auto Cleanup Started"
    
    # Backup config first
    cp "$XRAY_CONFIG" "${XRAY_CONFIG}.bak_$(date +%s)"
    
    # Cleanup different protocols
    cleanup "vmess" "#vm"
    cleanup "vless" "#vl"
    cleanup "trojan" "#tr"
    
    # Restart if needed
    if grep -q "Deleted [1-9]" "$LOG_FILE"; then
        systemctl restart xray
        log "Xray service restarted"
    fi
    
    log "Cleanup completed"
    echo "======================================"
} | tee -a "$LOG_FILE"
EOF

# Set permissions
chmod +x /usr/local/bin/xray_auto_cleanup
mkdir -p /etc/xray/backup
touch /var/log/xray_auto_cleanup.log
chmod 644 /var/log/xray_auto_cleanup.log

# Add to cron
cat <<EOF > /etc/cron.d/xray_auto_cleanup
0 0 * * * root /usr/local/bin/xray_auto_cleanup
EOF

echo "Installation completed successfully!"
echo "First run output:"
/usr/local/bin/xray_auto_cleanup
