function ssh_testbench
    ssh -t exigent@$exigent_testbench_ip "zellij attach"
end
