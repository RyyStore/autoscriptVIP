#!/bin/bash

CONFIG_FILE="/etc/xray/config.json"
LOG_FILE="/var/log/hapus_akun_expired.log"
WAKTU_SAAT_INI=$(TZ=Asia/Jakarta date "+%Y-%m-%d %H:%M:%S")
EPOCH_SAAT_INI=$(TZ=Asia/Jakarta date +%s)

function hapus_akun_expired() {
    echo "╭─────────────────────────────────────────────╮" | tee "$LOG_FILE"
    echo "│ • PENGHAPUS AKUN EXPIRED XRAY •            │" | tee -a "$LOG_FILE"
    echo "╰─────────────────────────────────────────────╯" | tee -a "$LOG_FILE"
    echo "Waktu VPS saat ini: $WAKTU_SAAT_INI" | tee -a "$LOG_FILE"
    echo "[D] Epoch sekarang : $EPOCH_SAAT_INI" | tee -a "$LOG_FILE"

    declare -A TANDA=(
        [vmess]="#vm"
        [trojan]="#tr"
        [vless]="#vl"
    )

    for jenis in vmess trojan vless; do
        echo -e "\n[*] Memindai akun $jenis..." | tee -a "$LOG_FILE"
        count=0
        grep -a "${TANDA[$jenis]}" "$CONFIG_FILE" | while read -r line; do
            nama=$(echo "$line" | awk '{print $2}')
            tanggal_exp=$(echo "$line" | awk '{print $3}')
            expired_epoch=$(date -d "$tanggal_exp" +%s 2>/dev/null)

            if [[ -z $expired_epoch ]]; then
                echo "[!] Format tanggal salah pada akun $nama, dilewati." | tee -a "$LOG_FILE"
                continue
            fi

            if [[ $expired_epoch -lt $EPOCH_SAAT_INI ]]; then
                # hapus blok dari $CONFIG_FILE
                sed -i "/^${TANDA[$jenis]} $nama $tanggal_exp/,/^},{/d" "$CONFIG_FILE"
                rm -f /etc/xray/$nama*
                echo "[✓] $nama ($jenis) expired $tanggal_exp - dihapus." | tee -a "$LOG_FILE"
                ((count++))
            fi
        done
        echo "[✓] Total akun $jenis dihapus: $count" | tee -a "$LOG_FILE"
    done

    echo -e "\n[*] Merestart layanan Xray..." | tee -a "$LOG_FILE"
    systemctl restart xray && echo "[✓] Xray berhasil direstart" | tee -a "$LOG_FILE"
    echo "╭─────────────────────────────────────────────╮" | tee -a "$LOG_FILE"
    echo "│ • PROSES SELESAI •                         │" | tee -a "$LOG_FILE"
    echo "╰─────────────────────────────────────────────╯" | tee -a "$LOG_FILE"
}

hapus_akun_expired
