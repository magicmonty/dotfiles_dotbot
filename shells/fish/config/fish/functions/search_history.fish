function search_history
  set cmd (commandline)

  set peco_flags --layout=bottom-up
  if [ (count $cmd) -gt 0 ]
    set peco_flags $peco_flags --query "$cmd"
  end

  history | peco $peco_flags | read from_peco

  if [ $from_peco ]
    commandline $from_peco
  else
    commandline $cmd
  end
end
