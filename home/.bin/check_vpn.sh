if ! nmcli con show --active | grep -q "$WORK_VPN"; then
  notify-send "VPN" "Activating work vpn..."
  nmcli con up "$WORK_VPN"
  sleep 5
fi
