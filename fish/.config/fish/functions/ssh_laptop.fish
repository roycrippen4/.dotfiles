function ssh_laptop
    ssh -t exigent@$exigent_laptop_ip "zellij attach"
end
