function pf --description "Fuzzy-open files in Vim with preview"
    set -l picks (fd -H -tf . | fzf -m --select-1 --exit-0 \
        --preview 'bat --style=numbers --color=always --line-range :200 {}' \
        --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up')

    if test (count $picks) -gt 0
        vim $picks
    end
end
