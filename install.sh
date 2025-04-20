#!/bin/bash
# Ultimate Xray Cleanup Installer for RyyStore
# GitHub: https://github.com/RyyStore/autoscriptVIP

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Run as root!"; exit 1; }

# Create main script
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Ultimate Xray Cleanup for RyyStore Config

LOG_FILE="/var/log/xray_auto_cleanup.log"
CONFIG="/etc/xray/config.json"
BACKUP_DIR="/etc/xray/backup_deleted"

# Initialize
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Alternative cleanup method for non-standard configs
alternative_cleanup() {
    local protocol=$1
    local tag=$2
    
    log "[$protocol] Starting alternative cleanup for tag: $tag"
    deleted=0
    
    # Get current date in YYYY-MM-DD format
    current_date=$(date +%Y-%m-%d)
    
    # Process each account line
    while read -r line; do
        # Extract user and expiry date (format: #tag user expiry_date)
        if [[ "$line" =~ ^${tag}[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
            user="${BASH_REMATCH[1]}"
            exp_date="${BASH_REMATCH[2]}"
            
            # Compare dates
            if [[ "$current_date" > "$exp_date" ]]; then
                log "[$protocol] Deleting expired: $user (Expired: $exp_date)"
                
                # Backup account info
                echo "$user $exp_date" >> "$BACKUP_DIR/${protocol}_deleted_$(date +%F).log"
                
                # Remove from config (simple line removal)
                sed -i "/^${tag} ${user} ${exp_date}/d" "$CONFIG"
                
                ((deleted++))
            fi
        fi
    done < <(grep "^${tag} " "$CONFIG")
    
    log "[$protocol] Deleted $deleted accounts"
}

# Main process
{
    echo "======================================"
    log "Xray Auto Cleanup Started (Alternative Method)"
    
    # Backup config
    cp "$CONFIG" "${CONFIG}.bak_$(date +%s)"
    
    # Clean protocols using alternative method
    alternative_cleanup "vmess" "#vm"
    alternative_cleanup "vless" "#vl"
    alternative_cleanup "trojan" "#tr"
    
    # Restart if changes made
    if grep -q "Deleted [1-9]" "$LOG_FILE"; then
        systemctl restart xray
        log "Xray restarted"
    else
        log "No accounts deleted"
    fi
    
    log "Cleanup completed"
    echo "======================================"
} | tee -a "$LOG_FILE"
EOF

# Set permissions
chmod +x /usr/local/bin/xray_auto_cleanup
mkdir -p /etc/xray/backup_deleted
touch /var/log/xray_auto_cleanup.log

# Add to cron
cat <<EOF > /etc/cron.d/xray_auto_cleanup
0 0 * * * root /usr/local/bin/xray_auto_cleanup
EOF

# First run
echo "Running initial test..."
/usr/local/bin/xray_auto_cleanup

echo -e "\nInstallation complete!"
echo "Log file: /var/log/xray_auto_cleanup.log"
echo "Backups: /etc/xray/backup_deleted/"
echo "Note: Using alternative cleanup method for compatibility"
