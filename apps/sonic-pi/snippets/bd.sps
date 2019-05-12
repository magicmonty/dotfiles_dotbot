#key: bd
#point_line:2
#point_index:28
# --
live_loop :drums, sync: :clock1 do
  tick
  sample :bd_haus if spread(4, 16).look
  sleep 0.25
end
