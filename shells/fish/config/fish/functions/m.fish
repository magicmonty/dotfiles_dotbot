function m -d "start mutt"
  if count $argv > /dev/null
    set accountname $argv[1]
    set --erase argv[1]
  else
    set accountname all
  end

  mutt -n -e "source ~/.mutt/accounts/$accountname" $argv
end
