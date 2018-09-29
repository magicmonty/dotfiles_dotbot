#key: smp
#point_line:0
#point_index:7
# --
with_fx(:reverb, room: 0.8, mix: 0.7, damp: 0.5) do
  live_audio :volcas, input: 1, amp: 1.5
end

live_audio :modular, input: 2, amp: 1.5
