#key: safari
#point_line:0
#point_index:25
# --
live_loop :safari, sync: :clock1 do
  sample :loop_safari, beat_stretch: 16, amp: 2
  sleep 16
end
