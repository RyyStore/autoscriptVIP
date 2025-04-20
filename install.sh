#!/bin/bash
# Xray Auto Cleanup Installer - Fixed for RyyStore Config
# GitHub: https://github.com/RyyStore/autoscriptVIP

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Run as root!"; exit 1; }

# Install dependencies
if ! command -v jq &> /dev/null; then
    apt update && apt install jq -y
fi

# Create main script
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Xray Cleanup Compatible with RyyStore Config

LOG_FILE="/var/log/xray_auto_cleanup.log"
CONFIG="/etc/xray/config.json"
BACKUP_DIR="/etc/xray/backup_deleted"

# Initialize
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cleanup_accounts() {
    local protocol=$1
    log "[$protocol] Starting cleanup..."
    
    deleted=0
    current_epoch=$(date +%s)
    
    # Process using jq
    accounts=$(jq -r --arg proto "$protocol" '.inbounds[] | select(.protocol == $proto) | .settings.clients[] | select(.email) | "\(.email) \(.expiry)"' "$CONFIG")
    
    while read -r account; do
        [ -z "$account" ] && continue
        
        email=$(echo "$account" | awk '{print $1}')
        expiry=$(echo "$account" | awk '{print $2}')
        
        # Skip if no expiry date
        [[ -z "$expiry" ]] && {
            log "[$protocol] WARNING: No expiry for $email"
            continue
        }
        
        # Convert expiry to epoch
        if ! expiry_epoch=$(date -d "$expiry" +%s 2>/dev/null); then
            log "[$protocol] ERROR: Invalid date format for $email - $expiry"
            continue
        fi
        
        # Check if expired
        if [ "$current_epoch" -gt "$expiry_epoch" ]; then
            log "[$protocol] Deleting expired: $email (Expired: $expiry)"
            
            # Backup account info
            echo "$email $expiry" >> "$BACKUP_DIR/${protocol}_deleted_$(date +%F).log"
            
            # Remove from config using jq
            jq --arg email "$email" --arg proto "$protocol" \
               '(.inbounds[] | select(.protocol == $proto).settings.clients |= map(select(.email != $email))' \
               "$CONFIG" > "${CONFIG}.tmp" && mv "${CONFIG}.tmp" "$CONFIG"
            
            ((deleted++))
        fi
    done <<< "$accounts"
    
    log "[$protocol] Deleted $deleted accounts"
}

# Main process
{
    echo "======================================"
    log "Xray Auto Cleanup Started"
    
    # Backup config
    cp "$CONFIG" "${CONFIG}.bak_$(date +%s)"
    
    # Clean protocols
    cleanup_accounts "vmess"
    cleanup_accounts "vless"
    cleanup_accounts "trojan"
    
    # Restart if changes made
    if grep -q "Deleted [1-9]" "$LOG_FILE"; then
        systemctl restart xray
        log "Xray restarted"
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
