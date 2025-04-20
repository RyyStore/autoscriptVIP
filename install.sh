#!/bin/bash
# Xray Auto Cleanup Installer
# Created by RyyStore
# GitHub: https://github.com/ryystore/xray_auto_cleanup

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error: This script must be run as root${NC}" >&2
  exit 1
fi

# Check if Xray is installed
if ! command -v xray &> /dev/null; then
  echo -e "${RED}Error: Xray is not installed on this system${NC}"
  exit 1
fi

echo -e "${GREEN}Installing Xray Auto Cleanup...${NC}"

# Create main script
cat << 'EOF' > /usr/local/bin/xray_auto_cleanup
#!/bin/bash
# Xray Auto Cleanup Script
# GitHub: https://github.com/ryystore/xray_auto_cleanup

# Configuration
LOG_FILE="/var/log/xray_auto_cleanup.log"
XRAY_CONFIG="/etc/xray/config.json"
BACKUP_DIR="/etc/xray/backup_accounts"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Function for colored output
colored() {
    local color="$1"
    local message="$2"
    case "$color" in
        red) echo -e "\033[0;31m$message\033[0m" ;;
        green) echo -e "\033[0;32m$message\033[0m" ;;
        yellow) echo -e "\033[1;33m$message\033[0m" ;;
        *) echo -e "$message" ;;
    esac
}

# Function to log messages
log() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo -e "$message" | tee -a "$LOG_FILE"
}

# Load environment
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# List of tags for each protocol
tags_vmess=("#vm" "#vmg" "#vmess")
tags_vless=("#vl" "#vlg" "#vless")
tags_trojan=("#tr" "#trg" "#trojan")

# Main cleanup function
cleanup_expired() {
    local type=$1
    local tags=("${!2}")
    local log_prefix=$3

    current_date=$(date +%s)
    log "$log_prefix Starting cleanup process..."

    deleted=0
    errors=0

    for tag in "${tags[@]}"; do
        # Extract accounts with the current tag
        accounts=($(grep -E "^${tag} " "$XRAY_CONFIG" | awk '{print $2,$3,$4}'))
        
        for ((i=0; i<${#accounts[@]}; i+=3)); do
            user=${accounts[i]}
            exp_date=${accounts[i+1]}
            uuid=${accounts[i+2]}

            # Skip if date is invalid
            if ! exp_seconds=$(date -d "$exp_date" +%s 2>/dev/null); then
                log "$log_prefix [ERROR] Invalid date format for account: $user (Date: $exp_date)"
                ((errors++))
                continue
            fi

            if [[ $exp_seconds -lt $current_date ]]; then
                log "$log_prefix Deleting expired $type account: $user (Expired: $exp_date)"

                # Backup account info before deletion
                backup_file="$BACKUP_DIR/${type}_deleted_$(date +%Y%m%d).txt"
                echo "$type $user $exp_date $uuid" >> "$backup_file"

                # Remove account from config
                if ! sed -i "/^${tag} $user $exp_date/,/\"email\": \"$user\"/d" "$XRAY_CONFIG"; then
                    log "$log_prefix [ERROR] Failed to remove account: $user"
                    ((errors++))
                    continue
                fi

                # Remove related files
                rm -f "/etc/$type/${user}" "/etc/$type/${user}IP" "/home/vps/public_html/$type-$user.txt" 2>/dev/null

                ((deleted++))
            fi
        done
    done

    log "$log_prefix Result: Deleted $deleted expired $type accounts, $errors errors encountered"
}

# Main execution
{
    echo "======================================"
    log "Xray Auto Cleanup Started"

    # Create backup of config before making changes
    config_backup="/etc/xray/config_backup_$(date +%Y%m%d_%H%M%S).json"
    cp "$XRAY_CONFIG" "$config_backup"
    log "Config backup created at: $config_backup"

    # Cleanup for each protocol
    cleanup_expired "vmess" tags_vmess[@] "[VMESS]"
    cleanup_expired "vless" tags_vless[@] "[VLESS]"
    cleanup_expired "trojan" tags_trojan[@] "[TROJAN]"

    # Restart xray if accounts were deleted
    if [ "$deleted" -gt 0 ]; then
        if systemctl restart xray; then
            log "Xray service restarted successfully"
        else
            log "[ERROR] Failed to restart Xray service"
        fi
    else
        log "No expired accounts found. Xray service not restarted."
    fi

    log "Cleanup process completed"
    echo "======================================"
} | tee -a "$LOG_FILE"
EOF

# Set permissions
chmod +x /usr/local/bin/xray_auto_cleanup
log "Main script installed at /usr/local/bin/xray_auto_cleanup"

# Create log file
touch /var/log/xray_auto_cleanup.log
chmod 644 /var/log/xray_auto_cleanup.log
log "Log file created at /var/log/xray_auto_cleanup.log"

# Create backup directory
mkdir -p /etc/xray/backup_accounts
chmod 700 /etc/xray/backup_accounts
log "Backup directory created at /etc/xray/backup_accounts"

# Add to cron
cat <<EOF > /etc/cron.d/xray_auto_cleanup
# Xray Auto Cleanup - Runs daily at 00:00
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 0 * * * root /usr/local/bin/xray_auto_cleanup
EOF

log "Cron job installed at /etc/cron.d/xray_auto_cleanup"

# First run test
echo -e "${YELLOW}Running initial test...${NC}"
/usr/local/bin/xray_auto_cleanup

echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "Details:"
echo -e "- Main script: /usr/local/bin/xray_auto_cleanup"
echo -e "- Log file: /var/log/xray_auto_cleanup.log"
echo -e "- Backup directory: /etc/xray/backup_accounts"
echo -e "- Cron job: /etc/cron.d/xray_auto_cleanup"
echo -e "\nYou can monitor the cleanup process by checking the log file."
