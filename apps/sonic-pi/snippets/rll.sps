#key: rll
#point_line:1
#point_index:12
# --
with_fx(:reverb, room: 0.8, mix: 0.7) do
  live_loop : ,sync: :clock1 do

    sleep 0.25
  end
end
