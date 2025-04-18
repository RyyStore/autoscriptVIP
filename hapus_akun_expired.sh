#!/bin/bash
# Script: hapus_akun_expired.sh
# Fungsi: Auto cleaner untuk akun VMESS, VLESS, Trojan yang sudah expired
# Author: RyyStore
# Repo: https://github.com/RyyStore/autoscriptVIP/main/hapus_akun_expired.sh
#!/bin/bash
# Script: hapus_akun_expired.sh
# Penulis: RyyStore
# Repo: https://github.com/RyyStore/autoscriptVIP

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
TODAY_EPOCH=$(date -d "$TODAY" +%s)

# Fungsi untuk logging
log() {
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
  echo -e "$1"
}

# Fungsi untuk membersihkan akun
bersihkan_akun() {
  local user=$1
  local exp_date=$2
  local protokol=$3

  log "${YELLOW}[*] Menghapus akun ${BLUE}${protokol}${YELLOW}: ${GREEN}${user}${NC} (Expired: ${RED}${exp_date}${NC})"

  # Hapus dari config.json
  sed -i "/#${protokol} ${user} ${exp_date}/,/},{/d" "$XRAY_CONFIG"

  # Hapus file terkait
  case $protokol in
    "vm")
      rm -f "/etc/vmess/${user}"* \
            "/var/www/html/vmess-${user}"* \
            "/home/vps/public_html/vmess-${user}"* 2>/dev/null
      ;;
    "tr")
      rm -f "/etc/trojan/${user}"* \
            "/var/www/html/trojan-${user}"* \
            "/home/vps/public_html/trojan-${user}"* 2>/dev/null
      ;;
    "vlg")
      rm -f "/etc/vless/${user}"* \
            "/var/www/html/vless-${user}"* \
            "/home/vps/public_html/vless-${user}"* 2>/dev/null
      ;;
  esac

  # Hapus limit IP
  rm -f "/etc/kyt/limit/${protokol}/ip/${user}"* 2>/dev/null
}

# Fungsi untuk memproses akun
proses_akun() {
  local protokol=$1
  local tag=$2
  local terhapus=0

  log "\n${YELLOW}[*] Memindai akun ${BLUE}${protokol}${YELLOW}...${NC}"

  # Cari akun dengan format spesifik
  grep -A1 "#${tag} " "$XRAY_CONFIG" | grep -E "#${tag} [^ ]+ [0-9]{4}-[0-9]{2}-[0-9]{2}" | while read -r line; do
    user=$(echo "$line" | awk '{print $2}')
    exp_date=$(echo "$line" | awk '{print $3}')

    if [[ -z "$exp_date" ]]; then
      log "${YELLOW}[!] Tidak menemukan tanggal expired untuk ${GREEN}${user}${NC}"
      continue
    fi

    exp_epoch=$(date -d "$exp_date" +%s 2>/dev/null || true)
    if [[ -z "$exp_epoch" ]]; then
      log "${RED}[!] Format tanggal invalid untuk ${GREEN}${user}${RED}: ${exp_date}${NC}"
      continue
    fi

    if [[ $exp_epoch -lt $TODAY_EPOCH ]]; then
      bersihkan_akun "$user" "$exp_date" "$tag"
      ((terhapus++))
    else
      log "${BLUE}[i] Akun ${GREEN}${user}${BLUE} aktif hingga ${RED}${exp_date}${NC}"
    fi
  done

  log "${GREEN}[✓] Total akun ${protokol} dihapus: ${RED}${terhapus}${NC}"
}

# Main execution
echo -e "${YELLOW}╭─────────────────────────────────────────────╮${NC}"
echo -e "${YELLOW}│${NC} ${BLUE}• PENGHAPUS AKUN EXPIRED XRAY •${NC}               ${YELLOW}│${NC}"
echo -e "${YELLOW}╰─────────────────────────────────────────────╯${NC}"

# Verifikasi config.json
if [[ ! -f "$XRAY_CONFIG" ]]; then
  echo -e "${RED}[!] File config Xray tidak ditemukan di ${XRAY_CONFIG}${NC}"
  exit 1
fi

# Proses semua protokol
proses_akun "vmess" "vm"
proses_akun "trojan" "tr"
proses_akun "vless" "vlg"

# Restart Xray
echo -e "\n${YELLOW}[*] Merestart layanan Xray...${NC}"
systemctl restart xray
if systemctl is-active --quiet xray; then
  echo -e "${GREEN}[✓] Xray berhasil direstart${NC}"
else
  echo -e "${RED}[!] Gagal merestart Xray${NC}"
fi

echo -e "${YELLOW}╭─────────────────────────────────────────────╮${NC}"
echo -e "${YELLOW}│${NC} ${GREEN}• PROSES SELESAI •${NC}                          ${YELLOW}│${NC}"
echo -e "${YELLOW}╰─────────────────────────────────────────────╯${NC}"

# Install mode
if [[ "$1" == "--install" ]]; then
  install_script
  exit 0
fi

# Jalankan main
main