function gls -d 'Fancy, searchable git log'
    # this is based on @DanielFGray's gist https://gist.github.com/DanielFGray/9bad3f7a8b3f782acabcfa54edb8e5f5
    git log --graph --oneline --decorate --all --color=always | fzf --ansi +s --preview='git show --color=always {2}' \
        --bind='ctrl-d:preview-page-down' \
        --bind='ctrl-u:preview-page-up' \
        --bind='enter:execute:git show --color=always {2} | less -R' \
        --bind='ctrl-x:execute:git checkout {2} .'
end
