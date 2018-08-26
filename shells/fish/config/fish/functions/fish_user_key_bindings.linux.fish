function fish_user_key_bindings
    bind \cl 'clear; commandline -f repaint'
    bind \cu backward-kill-line
    bind \cr search_history
    bind -M insert \cr search_history
    bind -M insert \co edit_config_fish
    bind \co edit_config_fish
    bind -M insert \ett peco_todoist_item
    bind -M insert \etp peco_todoist_project
    bind -M insert \etp peco_todoist_labels
    bind -M insert \etc peco_todoist_close
    bind -M insert \etd peco_todoist_delete
end
