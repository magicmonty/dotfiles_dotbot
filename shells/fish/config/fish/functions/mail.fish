function mail
  vdirsyncer sync
  mates index
  if count $argv > /dev/null
    mutt (mates email-query | peco --query $argv)
  else
    mutt (mates email-query | peco)
  end
end
