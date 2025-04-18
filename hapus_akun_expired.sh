#!/bin/bash
# Script: hapus_akun_expired.sh
# Fungsi: Auto cleaner untuk akun VMESS, VLESS, Trojan yang sudah expired
# Author: RyyStore
# Repo: https://github.com/RyyStore/autoscriptVIP/main/hapus_akun_expired.sh

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Konfigurasi
XRAY_CONFIG="/etc/xray/config.json"
LOG_FILE="/var/log/hapus_akun_expired.log"
TODAY=$(date +%Y-%m-%d)
TODAY_EPOCH=$(date +%s)

# Fungsi instalasi
install_script() {
  echo -e "${YELLOW}[*] Memulai instalasi...${NC}"
  
  # Download script
  echo -e "${BLUE}[*] Mengunduh script...${NC}"
  curl -sSLo /usr/local/bin/hapus_akun_expired.sh https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/hapus_akun_expired.sh
  chmod +x /usr/local/bin/hapus_akun_expired.sh
  
  # Buat cronjob
  echo -e "${BLUE}[*] Membuat cronjob harian...${NC}"
  (crontab -l 2>/dev/null; echo "0 0 * * * /usr/local/bin/hapus_akun_expired.sh >> $LOG_FILE 2>&1") | crontab -
  
  echo -e "${GREEN}[✓] Instalasi selesai!${NC}"
  echo -e "${GREEN}[✓] Script akan berjalan otomatis setiap hari jam 00:00${NC}"
}

# Fungsi log
log() {
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
  echo -e "$1"
}

# Fungsi hapus akun
hapus_akun() {
  local protokol=$1
  local user=$2
  local exp_date=$3
  local uuid=$4

  log "${YELLOW}[*] Menghapus ${BLUE}$protokol${YELLOW} user: ${GREEN}$user${YELLOW} (exp: ${RED}$exp_date${NC})"
  
  # Hapus dari config.json
  if [[ -n "$uuid" ]]; then
    sed -i "/\"#$protokol $user $exp_date $uuid/,/},{/d" "$XRAY_CONFIG"
    sed -i "/\"#$protokol $user $exp_date/,/},{/d" "$XRAY_CONFIG"
  else
    sed -i "/\"#$protokol $user $exp_date/,/},{/d" "$XRAY_CONFIG"
  fi

  # Hapus semua file terkait
  case $protokol in
    "vm"|"vmg")
      rm -f "/etc/vmess/${user}" \
            "/etc/vmess/${user}IP" \
            "/var/www/html/vmess-${user}.txt" \
            "/home/vps/public_html/vmess-${user}.txt" 2>/dev/null
      ;;
    "vl"|"vlg")
      rm -f "/etc/vless/${user}" \
            "/etc/vless/${user}IP" \
            "/var/www/html/vless-${user}.txt" \
            "/home/vps/public_html/vless-${user}.txt" 2>/dev/null
      ;;
    "tr"|"trg")
      rm -f "/etc/trojan/${user}" \
            "/etc/trojan/${user}IP" \
            "/var/www/html/trojan-${user}.txt" \
            "/home/vps/public_html/trojan-${user}.txt" 2>/dev/null
      ;;
  esac

  # Hapus limit IP
  rm -f "/etc/kyt/limit/${protokol%%g}/ip/${user}" \
        "/etc/kyt/limit/${protokol%%g}/ip/${user}IP" 2>/dev/null
}

# Proses akun expired
proses_akun() {
  local protokol=$1
  local tag=$2
  local terhapus=0

  log "\n${YELLOW}[*] Memproses akun ${BLUE}${protokol}${YELLOW}...${NC}"

  # Ambil daftar akun
  mapfile -t akun_aktif < <(grep -A4 "\"#$tag " "$XRAY_CONFIG" | grep -E '"email"|"id"|"password"' | awk -F'"' '{print $4}' | paste -d " " - - -)

  if [[ ${#akun_aktif[@]} -eq 0 ]]; then
    log "${YELLOW}[!] Tidak ada akun ${protokol} ditemukan${NC}"
    return
  fi

  for akun in "${akun_aktif[@]}"; do
    user=$(echo "$akun" | awk '{print $1}')
    uuid=$(echo "$akun" | awk '{print $2}')
    exp_date=$(grep -A1 "\"#$tag $user " "$XRAY_CONFIG" | grep -oP '(?<=exp" : ")[^"]*')

    if [[ -z "$exp_date" ]]; then
      log "${YELLOW}[!] User ${GREEN}$user${YELLOW} tidak memiliki tanggal expired${NC}"
      continue
    fi

    exp_epoch=$(date -d "$exp_date" +%s 2>/dev/null)
    if [[ $? -ne 0 ]]; then
      log "${RED}[!] Format tanggal salah untuk user ${GREEN}$user${RED}: $exp_date${NC}"
      continue
    fi

    if [[ $exp_epoch -lt $TODAY_EPOCH ]]; then
      hapus_akun "$tag" "$user" "$exp_date" "$uuid"
      ((terhapus++))
    else
      log "${BLUE}[i] User ${GREEN}$user${BLUE} aktif hingga ${RED}$exp_date${NC}"
    fi
  done

  log "${GREEN}[✓] Total akun ${protokol} dihapus: ${RED}$terhapus${NC}"
}

# Main
main() {
  echo -e "${YELLOW}╭─────────────────────────────────────────────╮${NC}"
  echo -e "${YELLOW}│${NC} ${BLUE}• Penghapus Akun Expired Xray •${NC}               ${YELLOW}│${NC}"
  echo -e "${YELLOW}╰─────────────────────────────────────────────╯${NC}"

  # Cek config
  if [[ ! -f "$XRAY_CONFIG" ]]; then
    echo -e "${RED}[!] File config Xray tidak ditemukan!${NC}"
    exit 1
  fi

  # Proses semua protokol
  proses_akun "vmess" "vm"
  proses_akun "vmess" "vmg"
  proses_akun "vless" "vl"
  proses_akun "vless" "vlg"
  proses_akun "trojan" "tr"
  proses_akun "trojan" "trg"

  # Restart Xray
  echo -e "\n${YELLOW}[*] Merestart Xray...${NC}"
  systemctl restart xray
  if systemctl is-active --quiet xray; then
    echo -e "${GREEN}[✓] Xray berhasil direstart${NC}"
  else
    echo -e "${RED}[!] Gagal restart Xray${NC}"
  fi

  echo -e "${YELLOW}╭─────────────────────────────────────────────╮${NC}"
  echo -e "${YELLOW}│${NC} ${GREEN}• Proses penghapusan selesai •${NC}                ${YELLOW}│${NC}"
  echo -e "${YELLOW}╰─────────────────────────────────────────────╯${NC}"
}

# Install mode
if [[ "$1" == "--install" ]]; then
  install_script
  exit 0
fi

# Jalankan main
main