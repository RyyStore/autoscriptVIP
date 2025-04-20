# untuk install pake perintah ini #
```
apt update && apt upgrade -y && apt install build-essential -y && apt-get install -y jq && apt-get install shc && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/setup.sh && chmod +x setup.sh && ./setup.sh
```
# ApiServer
```
wget -q https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install/apiserver && chmod +x apiserver && ./apiserver apisellvpn
```
```
wget https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install_xray_auto_cleanup.sh && chmod +x install_xray_auto_cleanup.sh && ./install_xray_auto_cleanup.sh
```
# install autodel
```
bash
   wget -qO- https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/install.sh | bash
   ```
 Live log monitoring
```
tail -f /var/log/xray-cleanup.log
```
Cek cronjob
```
cat /etc/cron.d/xray-cleanup
```
Manual run
```
/usr/local/bin/xray-cleanup
```
# telebotnotif
```
wget -O /usr/local/bin/xray-cleanup \https://raw.githubusercontent.com/RyyStore/autoscriptVIP/main/xray-cleanup-telegram.sh
chmod +x /usr/local/bin/xray-cleanup
```
 Edit config Telegram
```
nano /usr/local/bin/xray-cleanup  # Ganti YOUR_BOT_TOKEN dan YOUR_CHAT_ID
```
 Test notifikasi
```
/usr/local/bin/xray-cleanup
