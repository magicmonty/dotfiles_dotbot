function gitv -d "Show git log using GV in vim"
  command vim -c "GV" -c "tabonly"
end

abbr -a gv gitv
