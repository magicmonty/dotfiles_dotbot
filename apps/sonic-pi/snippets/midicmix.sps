#key: midicmix
#point_line:2
#point_index:16
# --
live_loop :mixer do
  # Synth 1
  midi_cc 12, 54, channel: 16, port: $port
  # Synth 2
  midi_cc 14, 90, channel: 16, port: $port
  # Drum 1
  midi_cc 12, 80, channel: 10, port: $port
  # Drum 2
  midi_cc 23, 114, channel: 10, port: $port
  # Drum 3
  midi_cc 45, 100, channel: 10, port: $port
  # Drum 4
  midi_cc 53, 107, channel: 10, port: $port
  sleep 0.5
end
