#!/bin/bash

# Install cron if not installed
echo "Checking if cron is installed..."
if ! command -v cron &> /dev/null
then
    echo "Cron is not installed. Installing..."
    apt update && apt install cron -y
    systemctl enable cron
    systemctl start cron
fi

# Creating the cleanup script file
echo "Creating cleanup script..."

cat << 'EOF' > /usr/local/bin/xray_cleanup.sh
#!/bin/bash

# Function to delete VMess accounts
function del-vmess(){
  clear
  NUMBER_OF_CLIENTS=$(grep -c -E "^#vm " "/etc/xray/config.json")
  if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo "No existing clients found for VMess"
    return
  fi
  echo "Deleting VMess accounts..."
  for user in $(grep -E "^#vm " "/etc/xray/config.json" | cut -d ' ' -f 2); do
    exp=$(grep -E "^#vm $user " "/etc/xray/config.json" | cut -d ' ' -f 3)
    if [[ "$(date +%Y-%m-%d)" > "$exp" ]]; then
      sed -i "/^#vm $user /,/},{/d" /etc/xray/config.json
      echo "Deleted VMess account: $user, Expired on $exp"
    fi
  done
}

# Function to delete Vless accounts
function del-vless(){
  clear
  NUMBER_OF_CLIENTS=$(grep -c -E "^#vl " "/etc/xray/config.json")
  if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo "No existing clients found for Vless"
    return
  fi
  echo "Deleting Vless accounts..."
  for user in $(grep -E "^#vl " "/etc/xray/config.json" | cut -d ' ' -f 2); do
    exp=$(grep -E "^#vl $user " "/etc/xray/config.json" | cut -d ' ' -f 3)
    if [[ "$(date +%Y-%m-%d)" > "$exp" ]]; then
      sed -i "/^#vl $user /,/},{/d" /etc/xray/config.json
      echo "Deleted Vless account: $user, Expired on $exp"
    fi
  done
}

# Function to delete Trojan accounts
function del-trojan(){
  clear
  NUMBER_OF_CLIENTS=$(grep -c -E "^#tr " "/etc/xray/config.json")
  if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo "No existing clients found for Trojan"
    return
  fi
  echo "Deleting Trojan accounts..."
  for user in $(grep -E "^#tr " "/etc/xray/config.json" | cut -d ' ' -f 2); do
    exp=$(grep -E "^#tr $user " "/etc/xray/config.json" | cut -d ' ' -f 3)
    if [[ "$(date +%Y-%m-%d)" > "$exp" ]]; then
      sed -i "/^#tr $user /,/},{/d" /etc/xray/config.json
      echo "Deleted Trojan account: $user, Expired on $exp"
    fi
  done
}

# Running all functions
del-vmess
del-vless
del-trojan

# Restart Xray service after deletion
systemctl restart xray
EOF

# Make the script executable
chmod +x /usr/local/bin/xray_cleanup.sh

# Create cron job to run this script every day at midnight
echo "Setting up cron job to run xray_cleanup.sh every day at midnight..."
(crontab -l 2>/dev/null; echo "0 0 * * * /usr/local/bin/xray_cleanup.sh > /dev/null 2>&1") | crontab -

# Status message
echo "Cleanup script and cron job have been installed successfully."
echo "The script will run automatically every day at midnight to delete expired accounts."
