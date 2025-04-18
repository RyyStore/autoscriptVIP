#!/bin/bash

CONFIG_FILE="/etc/xray/config.json"
LOG_FILE="/var/log/hapus_akun_expired.log"
CURRENT_EPOCH=$(date +%s)
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
deleted_vmess=0
deleted_trojan=0
deleted_vless=0

echo "╭─────────────────────────────────────────────╮" | tee "$LOG_FILE"
echo "│       • PENGHAPUS AKUN EXPIRED XRAY •       │" | tee -a "$LOG_FILE"
echo "╰─────────────────────────────────────────────╯" | tee -a "$LOG_FILE"
echo "Waktu VPS saat ini: $CURRENT_DATE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

delete_expired() {
    local tag="$1"
    local protocol="$2"
    local deleted_var="deleted_${protocol}"

    echo "[*] Memindai akun $protocol..." | tee -a "$LOG_FILE"
    while IFS= read -r line; do
        user=$(echo "$line" | cut -d ' ' -f2)
        exp=$(echo "$line" | cut -d ' ' -f3)

        exp_epoch=$(date -d "$exp" +%s 2>/dev/null)
        if [[ -z "$exp_epoch" ]]; then
            echo "[!] Format tanggal invalid untuk $user ($exp)" | tee -a "$LOG_FILE"
            continue
        fi

        if [[ $exp_epoch -lt $CURRENT_EPOCH ]]; then
            echo "[-] Menghapus $protocol: $user (Expired: $exp)" | tee -a "$LOG_FILE"
            # Hapus dari config
            sed -i "/^#${tag} $user $exp/,/^},{/d" "$CONFIG_FILE"
            # Hapus file akun (jika ada)
            rm -f /etc/$protocol/${user} /etc/$protocol/${user}IP /home/vps/public_html/${protocol}-${user}.txt
            # Tambah hitung
            (( ${deleted_var}++ ))
        fi
    done < <(grep -E "^#${tag} " "$CONFIG_FILE")
}

delete_expired "vm" "vmess"
delete_expired "tr" "trojan"
delete_expired "vl" "vless"

echo "" | tee -a "$LOG_FILE"
echo "[✓] Total akun vmess dihapus: $deleted_vmess" | tee -a "$LOG_FILE"
echo "[✓] Total akun trojan dihapus: $deleted_trojan" | tee -a "$LOG_FILE"
echo "[✓] Total akun vless dihapus: $deleted_vless" | tee -a "$LOG_FILE"

echo "[*] Merestart layanan Xray..." | tee -a "$LOG_FILE"
systemctl restart xray && echo "[✓] Xray berhasil direstart" | tee -a "$LOG_FILE"

echo "╭─────────────────────────────────────────────╮" | tee -a "$LOG_FILE"
echo "│              • PROSES SELESAI •             │" | tee -a "$LOG_FILE"
echo "╰─────────────────────────────────────────────╯" | tee -a "$LOG_FILE"
