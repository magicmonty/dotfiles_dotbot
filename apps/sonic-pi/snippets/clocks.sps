#key: clocks
#point_line:13
#point_index:0
# --
live_loop :clock1 do
  sleep 1
end

live_loop :clock4 do
  sync :clock1
  sleep 4
end

live_loop :clock8 do
  sync :clock4
  sleep 8
end

