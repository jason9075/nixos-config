#!/usr/bin/env bash

# Configuration
CONNECTION_NAME="Astra"
SECRET_ATTR_SERVICE_GROUP="astra-vpn-group"
SECRET_ATTR_SERVICE_USER="astra-vpn-user"

# Check if the VPN is already connected
if [ -n "$(pgrep vpnc)" ]; then
  if [ -n "$(nmcli connection show --active | grep "$CONNECTION_NAME")" ]; then
    notify-send "Disconnecting from Astra VPN"
    nmcli connection down "$CONNECTION_NAME"
    exit 0
  else
    notify-send "VPN is already connected (Other profile)"
    exit 1
  fi
fi

# Load Config
CONFIG_FILE="$HOME/.config/astra-vpn-secret"
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
else
    notify-send "Error: Config file not found" "Please create $CONFIG_FILE with variables: gateway, group_name, username"
    exit 1
fi

# Validate Config
missing_vars=""
[ -z "$gateway" ] && missing_vars="$missing_vars gateway"
[ -z "$group_name" ] && missing_vars="$missing_vars group_name"
[ -z "$username" ] && missing_vars="$missing_vars username"

if [ -n "$missing_vars" ]; then
    notify-send "Error: Missing config variables" "Add to $CONFIG_FILE: $missing_vars"
    exit 1
fi

# ---------------------------------------------------------
# Helper Function: Get Password (Keyring -> GUI -> Variable)
# ---------------------------------------------------------
get_password() {
    local label="$1"
    local service="$2"
    local user="$3"
    local existing_pass
    
    existing_pass=$(secret-tool lookup service "$service" username "$user")
    
    if [ -n "$existing_pass" ]; then
        echo "$existing_pass"
        return 0
    fi

    # Ask via GUI if not found
    local new_pass
    while [ -z "$new_pass" ]; do
        new_pass=$(zenity --password --title="$label" --text="Enter $label for $user:")
        if [ $? -ne 0 ]; then return 1; fi # User Cancelled
    done
    
    echo "$new_pass"
    return 2 # Indicates "Newly entered"
}

# ---------------------------------------------------------
# 1. Fetch Passwords
# ---------------------------------------------------------

# Group Password
group_passwd=$(get_password "Astra VPN Group Password" "$SECRET_ATTR_SERVICE_GROUP" "$username")
status_group=$?
if [ $status_group -eq 1 ]; then exit 1; fi

# User Password
user_passwd=$(get_password "Astra VPN User Password" "$SECRET_ATTR_SERVICE_USER" "$username")
status_user=$?
if [ $status_user -eq 1 ]; then exit 1; fi


# ---------------------------------------------------------
# 2. Setup Connection
# ---------------------------------------------------------

# Recreate connection
if [ -n "$(nmcli connection show | grep "$CONNECTION_NAME")" ]; then
    nmcli connection delete "$CONNECTION_NAME" >/dev/null 2>&1
fi

nmcli connection add con-name "$CONNECTION_NAME" type vpn vpn-type vpnc ifname -- \
    "autoconnect" "false" \
    "vpn.data" "IPSec ID=$group_name,
                IPSec gateway=$gateway,
                IPSec secret-flags=0,
                Local Port=0,
                NAT Traversal Mode=natt,
                Perfect Forward Secrecy=server,
                Vendor=cisco,
                Xauth password-flags=0,
                Xauth username=$username,
                ipsec-secret-type=save,
                xauth-password-type=save,
                Enable weak encryption=yes,
                Enable weak authentication=yes,
                Interface MTU=1350" \
     "vpn.secrets" "IPSec secret=$group_passwd, Xauth password=$user_passwd" \
     "ipv6.ip6-privacy" "0" >/dev/null


# ---------------------------------------------------------
# 3. Connect & Verify
# ---------------------------------------------------------
notify-send "Connecting to Astra VPN..."

if nmcli connection up "$CONNECTION_NAME"; then
    notify-send "VPN Connected" "Connection successful."

    # Success! Save passwords IF they were newly entered
    if [ $status_group -eq 2 ]; then
        printf "%s" "$group_passwd" | secret-tool store --label="Astra VPN Group Password" service "$SECRET_ATTR_SERVICE_GROUP" username "$username"
    fi
    if [ $status_user -eq 2 ]; then
        printf "%s" "$user_passwd" | secret-tool store --label="Astra VPN User Password" service "$SECRET_ATTR_SERVICE_USER" username "$username"
    fi

else
    notify-send "VPN Connection Failed" "Please check your network or passwords."
    
    # If connection failed and we used stored passwords, maybe they are wrong?
    # We could implement logic here to clear them, but for now let's just warn.
    if [ $status_group -eq 0 ] || [ $status_user -eq 0 ]; then
         notify-send "Hint" "If passwords changed, run: secret-tool clear service $SECRET_ATTR_SERVICE_USER"
    fi
    exit 1
fi
