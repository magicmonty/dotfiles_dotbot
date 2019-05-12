#key: midicf
#point_line:2
#point_index:21
# --
live_loop :global_filter do
  # Global Filter
  midi_cc 74, val: 65, channel: 16, port: $port
  # Resonance
  midi_cc 71, val: 30, channel: 16, port: $port
  sleep 0.25
end
