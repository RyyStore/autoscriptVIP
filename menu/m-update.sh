#!/bin/bash

# Hapus menu yang lama
declare -a files=(
    "restore" "m-trgo" "backup" "menu" "addnoobz" "cek-noobz" "m-noobz" "m-vmess" "m-vless" "m-trojan"
    "m-system" "m-sshovpn" "m-ssws" "running" "m-update" "m-backup" "m-theme" "m-ip" "m-bot" "update"
    "ws-dropbear" "bckpbot" "tendang" "bottelegram" "cleaner" "m-allxray" "xraylimit" "xp" "trialvmess"
    "trialvless" "trialtrojan" "trialssh" "bantwidth" "autocpu"
)

for file in "${files[@]}"; do
    rm -rf "/usr/bin/$file"
done

fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

res1() {
    base_url="https://raw.githubusercontent.com/jvoscript/autoscript-vip/main/menu"
    declare -A downloads=(
        ["menu"]="menu.sh" ["m-trgo"]="m-trgo.sh" ["restore"]="restore.sh" ["backup"]="backup.sh"
        ["addnoobz"]="../bot/addnoobz.sh" ["cek-noobz"]="../bot/cek-noobz.sh" ["m-noobz"]="m-noobz.sh"
        ["m-ip"]="m-ip.sh" ["m-bot"]="m-bot.sh" ["m-theme"]="m-theme.sh" ["m-vmess"]="m-vmess.sh"
        ["m-vless"]="m-vless.sh" ["m-trojan"]="m-trojan.sh" ["m-system"]="m-system.sh"
        ["m-sshovpn"]="m-sshovpn.sh" ["running"]="running.sh" ["m-backup"]="m-backup.sh"
        ["speedtest"]="../speedtest_cli.py" ["bckpbot"]="bckpbot.sh" ["tendang"]="tendang.sh"
        ["bottelegram"]="bottelegram.sh" ["xraylimit"]="xraylimit.sh" ["trialvmess"]="trialvmess.sh"
        ["trialvless"]="trialvless.sh" ["trialtrojan"]="trialtrojan.sh" ["trialssh"]="trialssh.sh"
        ["autocpu"]="../install/autocpu.sh" ["bantwidth"]="../install/bantwidth"
    )

    for file in "${!downloads[@]}"; do
        wget -q -O "/usr/bin/$file" "$base_url/${downloads[$file]}" && chmod +x "/usr/bin/$file"
    done
    
    chmod +x /usr/bin/*
    clear
}

echo -e "\n  \033[1;91m Update Script...\033[1;37m"
fun_bar 'res1'

echo -e ""
menu
