#!/bin/bash
# Xray Auto Cleanup Ultimate Installer
# GitHub: https://github.com/RyyStore/xray-cleanup

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error: This script must be run as root${NC}" >&2
  exit 1
fi

# Install dependencies
if ! command -v jq &> /dev/null; then
  echo -e "${YELLOW}Installing jq package...${NC}"
  apt update && apt install jq -y
fi

# Create cleanup script
cat > /usr/local/bin/xray-cleanup << 'EOL'
#!/bin/bash
# Xray Auto Cleanup Core Script

CONFIG="/etc/xray/config.json"
LOG_FILE="/var/log/xray-cleanup.log"
BACKUP_DIR="/etc/xray/backup_deleted"

# Initialize
mkdir -p "$BACKUP_DIR"
echo "=== Cleanup Started $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"

clean_accounts() {
  local tag=$1
  local proto=$2
  local count=0

  while read -r line; do
    username=$(awk '{print $2}' <<< "$line")
    exp_date=$(awk '{print $3}' <<< "$line")
    
    if [ "$(date +%s)" -gt "$(date -d "$exp_date" +%s 2>/dev/null || echo 0)" ]; then
      # Backup account
      echo "$proto|$username|$exp_date" >> "$BACKUP_DIR/deleted_$(date +%F).log"
      
      # Remove from config
      sed -i "/^$tag $username $exp_date/,+1d" "$CONFIG"
      
      # Log deletion
      echo "[DELETED] $proto | $username | Expired: $exp_date" >> "$LOG_FILE"
      ((count++))
    fi
  done < <(grep "^$tag " "$CONFIG")

  [ $count -gt 0 ] && echo "Removed $count $proto accounts" >> "$LOG_FILE"
}

# Main process
clean_accounts "#vl" "VLESS"
clean_accounts "#vlg" "VLESS-GRPC"
clean_accounts "#vm" "VMESS"
clean_accounts "#vmg" "VMESS-GRPC"
clean_accounts "#tr" "TROJAN"
clean_accounts "#trg" "TROJAN-GRPC"

# Restart if changes
if grep -q "[DELETED]" "$LOG_FILE"; then
  systemctl restart xray
  echo "Xray service restarted" >> "$LOG_FILE"
fi

echo "=== Cleanup Completed ===" >> "$LOG_FILE"
EOL

# Set permissions
chmod +x /usr/local/bin/xray-cleanup

# Create log rotation
cat > /etc/logrotate.d/xray-cleanup << EOL
/var/log/xray-cleanup.log {
  daily
  rotate 7
  missingok
  notifempty
  compress
  delaycompress
}
EOL

# Setup cron job
CRON_JOB="0 0 * * * root /usr/local/bin/xray-cleanup"
if ! grep -q "xray-cleanup" /etc/cron.d/xray-cleanup 2>/dev/null; then
  echo "$CRON_JOB" > /etc/cron.d/xray-cleanup
  chmod 644 /etc/cron.d/xray-cleanup
fi

# First run test
echo -e "${YELLOW}Running initial test...${NC}"
/usr/local/bin/xray-cleanup

# Verify installation
echo -e "\n${GREEN}Installation Completed!${NC}"
echo -e "Cleanup script: ${YELLOW}/usr/local/bin/xray-cleanup${NC}"
echo -e "Log file: ${YELLOW}/var/log/xray-cleanup.log${NC}"
echo -e "Backup dir: ${YELLOW}/etc/xray/backup_deleted/${NC}"
echo -e "Cron job: ${YELLOW}cat /etc/cron.d/xray-cleanup${NC}"
echo -e "\nView last log: ${YELLOW}tail -f /var/log/xray-cleanup.log${NC}"
