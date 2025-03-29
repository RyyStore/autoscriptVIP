#!/bin/bash
# Ohp Script
# Mod By RMBL VPN 
# ==========================================
# Warna untuk output
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Memastikan unzip tersedia
apt update && apt install -y unzip wget

# Download File Ohp (menggunakan versi 64-bit untuk Ubuntu 22.04)
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux64.zip
unzip ohpserver-linux64.zip
chmod +x ohpserver
mv ohpserver /usr/local/bin/ohpserver
rm -rf ohpserver-linux64.zip

# Instalasi Service
# SSH OHP Port 8181
cat > /etc/systemd/system/ssh-ohp.service << END
[Unit]
Description=SSH OHP Redirection Service
Documentation=https://t.me/abecasdee13
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8181 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:22
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# Dropbear OHP 8282
cat > /etc/systemd/system/dropbear-ohp.service << END
[Unit]
Description=Dropbear OHP Redirection Service
Documentation=https://t.me/abecasdee13
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8282 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:109
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# OpenVPN OHP 8383
cat > /etc/systemd/system/openvpn-ohp.service << END
[Unit]
Description=OpenVPN OHP Redirection Service
Documentation=https://t.me/abecasdee13
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8383 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# Reload dan aktifkan service
systemctl daemon-reload
systemctl enable ssh-ohp dropbear-ohp openvpn-ohp
systemctl restart ssh-ohp dropbear-ohp openvpn-ohp

#------------------------------
printf 'INSTALLATION COMPLETED!\n'
sleep 0.5
printf 'CHECKING LISTENING PORT\n'

# Pengecekan service
for port in 8181 8282 8383; do
    if ss -tupln | grep -q "ohpserver" | grep -w "$port"; then
        echo "OHP Redirection on port $port Running"
    else
        echo "OHP Redirection on port $port Not Found, please check manually"
    fi
    sleep 0.5
done
