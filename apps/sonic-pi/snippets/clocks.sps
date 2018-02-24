#key: clocks
#point_line:5
#point_index:0
# --
live_loop :clocks, auto_cue: false do
  cue ("clock" + (tick % 8).to_s).to_sym
  sleep 1
end
