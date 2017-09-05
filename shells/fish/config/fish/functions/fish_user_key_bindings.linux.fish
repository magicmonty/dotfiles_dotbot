function fish_user_key_bindings
    bind \cl 'clear; commandline -f repaint'
    bind \cu backward-kill-line
    bind \cr search_history
    bind -M insert \cr search_history
    bind -M insert \co edit_config_fish
    bind \co edit_config_fish
end
