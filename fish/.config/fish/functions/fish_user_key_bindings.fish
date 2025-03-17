function fish_user_key_bindings
    if not set -q NVIM
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert

        set -g fish_sequence_key_delay_ms 100
        bind -M insert \ch backward-char
        bind -M insert \cl forward-char
        bind -M insert ctrl-n down-or-search
        bind -M insert -m default j,k backward-char repaint-mode
    end
end
