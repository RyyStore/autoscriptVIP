#!/bin/bash
# Xray Auto Cleanup with Telegram Notification
# GitHub: https://github.com/RyyStore/xray-cleanup

CONFIG="/etc/xray/config.json"
LOG_FILE="/var/log/xray-cleanup.log"
BACKUP_DIR="/etc/xray/backup_deleted"
TG_TOKEN="7716923032:AAHPQMZ1R0mFrI1voZ306oR3z85eO0fim6c"      # Ganti dengan token bot Telegram Anda
TG_CHAT_ID="7251232303"     # Ganti dengan chat ID Anda

# Fungsi notifikasi Telegram
notify_telegram() {
  local message="$1"
  curl -s -X POST \
    "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
    -d "chat_id=${TG_CHAT_ID}&text=${message}" > /dev/null
}

# Inisialisasi
mkdir -p "$BACKUP_DIR"
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "=== Cleanup Started $START_TIME ===" > "$LOG_FILE"

# Proses cleanup
clean_accounts() {
  local tag=$1
  local proto=$2
  local count=0

  while read -r line; do
    username=$(awk '{print $2}' <<< "$line")
    exp_date=$(awk '{print $3}' <<< "$line")
    
    if [ "$(date +%s)" -gt "$(date -d "$exp_date" +%s 2>/dev/null || echo 0)" ]; then
      # Backup dan hapus
      echo "$proto|$username|$exp_date" >> "$BACKUP_DIR/deleted_$(date +%F).log"
      sed -i "/^$tag $username $exp_date/,+1d" "$CONFIG"
      echo "[DELETED] $proto | $username | Expired: $exp_date" >> "$LOG_FILE"
      ((count++))
    fi
  done < <(grep "^$tag " "$CONFIG")

  [ $count -gt 0 ] && echo "Removed $count $proto accounts" >> "$LOG_FILE"
  return $count
}

# Eksekusi utama
{
  # Clean semua protokol
  clean_accounts "#vl" "VLESS"
  clean_accounts "#vlg" "VLESS-GRPC"
  clean_accounts "#vm" "VMESS"
  clean_accounts "#vmg" "VMESS-GRPC"
  clean_accounts "#tr" "TROJAN"
  clean_accounts "#trg" "TROJAN-GRPC"

  # Restart service jika ada perubahan
  if grep -q "\[DELETED\]" "$LOG_FILE"; then
    systemctl restart xray
    echo "Xray service restarted" >> "$LOG_FILE"
  fi

  echo "=== Cleanup Completed ===" >> "$LOG_FILE"
} | tee -a "$LOG_FILE"

# Kirim notifikasi Telegram
LOG_CONTENT=$(cat "$LOG_FILE")
notify_telegram "🛡️ Xray Cleanup Report ($START_TIME)%0A%0A${LOG_CONTENT//$'\n'/%0A}"
