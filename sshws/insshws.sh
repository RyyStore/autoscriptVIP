#!/bin/bash
# Proxy Untuk Edukasi & Imclass - Versi Compatible Ubuntu 22.04

# Link hosting Anda
SFVPN="https://raw.githubusercontent.com/litfina/autoscript-vip/main/install"

## 1. INSTALASI DEPENDENSI ##
echo "Memasang dependensi untuk Ubuntu 22.04..."
apt update
apt install -y python3 python3-pip libssl-dev
pip3 install --upgrade pip
update-alternatives --install /usr/bin/python python /usr/bin/python3 1

## 2. FUNGSI PEMBUATAN SERVICE ##
buat_service() {
  local nama_service=$1
  local nama_binary=$2
  local port=${3:-""}
  
  echo "Menginstall $nama_service..."
  wget -O "/usr/local/bin/$nama_binary" "$SFVPN/sshws/$nama_binary"
  chmod +x "/usr/local/bin/$nama_binary"

  cat > "/etc/systemd/system/$nama_service.service" << END
[Unit]
Description=Python Proxy Mod By SFVPN
Documentation=https://t.me/abecasdee13
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /usr/local/bin/$nama_binary $port
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
END

  systemctl daemon-reload
  systemctl enable "$nama_service.service"
  systemctl start "$nama_service.service"
  echo "$nama_service berhasil diinstall!"
}

## 3. INSTALASI SERVICE ##
# Dropbear WebSocket
buat_service "ws-dropbear" "ws-dropbear"

# OpenVPN WebSocket (Port 2086)
buat_service "ws-ovpn" "ws-ovpn.py" "2086"

# SSL Tunnel
buat_service "ws-stunnel" "ws-stunnel"

## 4. KONFIGURASI FIREWALL ##
echo "Mengatur firewall (nftables)..."
apt install -y nftables

cat > /etc/nftables.conf << END
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0;
        # Izinkan koneksi yang sudah established
        ct state established,related accept
        # Izinkan loopback
        iif lo accept
        # Izinkan ping
        ip protocol icmp accept
        # Izinkan port penting
        tcp dport {22, 80, 443, 2086} accept
        # Tolak yang lain
        counter drop
    }
    
    chain forward {
        type filter hook forward priority 0;
    }
    
    chain output {
        type filter hook output priority 0;
    }
}
END

systemctl enable nftables
systemctl start nftables

## 5. SELESAI ##
echo ""
echo "INSTALASI BERHASIL!"
echo "=================="
echo "Service yang terinstall:"
echo "- ws-dropbear (SSH WebSocket)"
echo "- ws-ovpn (OpenVPN WebSocket port 2086)"
echo "- ws-stunnel (SSL Tunnel)"
echo ""
echo "Firewall sudah dikonfigurasi untuk membuka port: 22, 80, 443, 2086"
