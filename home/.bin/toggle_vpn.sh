#!/usr/bin/env fish

set -l active (nmcli con show --active | grep "$WORK_VPN")

if test -n "$active"
    nmcli con down $WORK_VPN &>/dev/null
    if test $status -eq 0
        notify-send "Work vpn disabled"
    else
        notify-send "Failed to disable work vpn"
    end
else
    nmcli con up $WORK_VPN &>/dev/null

    if test $status -eq 0
        notify-send "Work vpn enabled"
    else
        notify-send "Failed to enable work vpn"
    end
end
