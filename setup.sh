#!/bin/bash
# AutoScript VPN Premium
# Compatible with Ubuntu 22.04 LTS
# Modified by RyyStore

# Color Configuration
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BG='\e[1;97;41m'

# Check Root
if [ "${EUID}" -ne 0 ]; then
  echo -e "${RED}You need to run this script as root${NC}"
  exit 1
fi

# Check Virtualization
if [ "$(systemd-detect-virt)" == "openvz" ]; then
  echo -e "${RED}OpenVZ is not supported${NC}"
  exit 1
fi

# Ubuntu 22.04 Specific Fixes
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" == "22.04" ]]; then
  echo -e "${YELLOW}[INFO] Ubuntu 22.04 Detected - Applying Compatibility Fixes${NC}"
  
  # Python 2 Fallback
  if ! command -v python2 &> /dev/null; then
    apt-get install -y python2
    ln -sf /usr/bin/python2 /usr/bin/python
  fi
  
  # OpenSSL 3.0 Configuration
  export OPENSSL_CONF=/etc/ssl/
  
  # Systemd Workarounds
  sed -i 's/PrivateTmp=yes/#PrivateTmp=yes/g' /etc/systemd/system/*.service 2>/dev/null
fi

# Initial Setup
clear
echo -e "${BLUE}╭══════════════════════════════════════════╮${NC}"
echo -e "${BLUE}│ ${BG}          AUTOSCRIPT PREMIUM           ${NC}${BLUE}│${NC}"
echo -e "${BLUE}│ ${BG}        UBUNTU 22.04 COMPATIBLE        ${NC}${BLUE}│${NC}"
echo -e "${BLUE}╰══════════════════════════════════════════╯${NC}"

# User Information
until [[ $name =~ ^[a-zA-Z0-9_.-]+$ ]]; do
  read -rp "Enter your name (no spaces): " -e name
done
echo "$name" > /etc/profil
author=$(cat /etc/profil)

# System Preparation
localip=$(hostname -I | cut -d\  -f1)
mkdir -p /etc/rmbl/theme
mkdir -p /var/lib/
echo "IP=" > /var/lib/ipvps.conf

# Dependency Installation
echo -e "${YELLOW}[INFO] Installing Dependencies...${NC}"
apt-get update -y
apt-get install -y git curl wget python2 python3 python3-pip sudo iptables net-tools \
                   resolvconf dnsutils netfilter-persistent

# Python Compatibility
ln -sf /usr/bin/python2 /usr/bin/python
python3 -m pip install --upgrade pip
pip3 install requests bs4

# Main Installation Functions
function CEKIP() {
  ipsaya=$(wget -qO- ifconfig.me)
  MYIP=$(curl -sS ipv4.icanhazip.com)
  IPVPS=$(curl -sS https://raw.githubusercontent.com/RyyStore/permission/main/ip | grep $MYIP | awk '{print $4}')
  if [[ "1" == "1" ]]; then
    domain
    Casper2
  else
    key2
    domain
    Casper2
  fi
}

function domain() {
  echo -e "${BLUE}╭══════════════════════════════════════════╮${NC}"
  echo -e "${BLUE}│ ${BG}        DOMAIN CONFIGURATION           ${NC}${BLUE}│${NC}"
  echo -e "${BLUE}╰══════════════════════════════════════════╯${NC}"
  
  until [[ $dnss =~ ^[a-zA-Z0-9_.-]+$ ]]; do 
    read -rp "Enter your domain: " -e dnss
  done
  
  # Domain Setup
  rm -rf /etc/xray /etc/v2ray /etc/nsdomain
  mkdir -p /etc/xray /etc/v2ray /etc/nsdomain
  
  echo "$dnss" > /root/domain
  echo "$dnss" > /etc/xray/domain
  echo "$dnss" > /etc/v2ray/domain
  echo "IP=$dnss" > /var/lib/ipvps.conf
  
  echo -e "${GREEN}[SUCCESS] Domain configured!${NC}"
}

function Casper2() {
  echo -e "${YELLOW}[INFO] Starting Core Installation...${NC}"
  
  # SSH & OpenVPN
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install/ssh-vpn.sh -O ssh-vpn.sh
  chmod +x ssh-vpn.sh
  ./ssh-vpn.sh
  
  # Xray Core
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install/ins-xray.sh -O ins-xray.sh
  chmod +x ins-xray.sh
  ./ins-xray.sh
  
  # Websocket
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/sshws/insshws.sh -O insshws.sh
  chmod +x insshws.sh
  ./insshws.sh
  
  # OHP
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/sshws/ohp.sh -O ohp.sh
  chmod +x ohp.sh
  ./ohp.sh
  
  # SlowDNS
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/slowdns/installsl.sh -O installsl.sh
  chmod +x installsl.sh
  bash installsl.sh
  
  # UDP Custom
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install/udp-custom.sh -O udp-custom.sh
  chmod +x udp-custom.sh
  bash udp-custom.sh
  
  # NoobzVPN
  wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/noobz/noobzvpns.zip
  unzip noobzvpns.zip
  chmod +x noobzvpns/*
  cd noobzvpns
  bash install.sh
  cd ..
  rm -rf noobzvpns*
  
  echo -e "${GREEN}[SUCCESS] Core Installation Completed!${NC}"
}

# Telegram Notification
function iinfo() {
  domain=$(cat /etc/xray/domain)
  CHATID="7251232303"
  KEY="8186435445:AAGcaG2pd8a7zQQx_gm7TznyhfHHm_t4YXA"
  TIME=$(date '+%d %b %Y')
  TEXT="
<code>🧿 INSTALL AUTOSCRIPT 🧿</code>
<code>Domain     : </code><code>$domain</code>
<code>User       : </code><code>$author</code>
<code>OS         : </code><code>Ubuntu $UBUNTU_VERSION</code>
<code>Date       : </code><code>$TIME</code>
<code>IP         : </code><code>$MYIP</code>
"
  curl -s --max-time 10 -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" \
  "https://api.telegram.org/bot$KEY/sendMessage" >/dev/null
}

# Finalization
function finalize() {
  # Cleanup
  rm -f ssh-vpn.sh ins-xray.sh insshws.sh ohp.sh installsl.sh udp-custom.sh
  
  # Profile Setup
  cat <<EOF > /root/.profile
if [ "\$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
clear
menu
EOF
  
  # System Optimization
  wget -q https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/fix.sh
  chmod +x fix.sh
  ./fix.sh
  rm fix.sh
  
  # Reboot Prompt
  echo -e "${BLUE}╭══════════════════════════════════════════╮${NC}"
  echo -e "${BLUE}│ ${BG} INSTALLATION COMPLETED - REBOOT NOW  ${NC}${BLUE}│${NC}"
  echo -e "${BLUE}╰══════════════════════════════════════════╯${NC}"
  
  read -p "Reboot now? (y/n): " -e answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    reboot
  else
    echo -e "${YELLOW}Please reboot manually when ready${NC}"
  fi
}

# Execution Flow
CEKIP
iinfo
finalize
