#key: boot
#point_line:16
#point_index:0
# --
$port = $circuit_port

set(:root, :G4)
set(:tonic, :dorian)

use_bpm 120
set_sched_ahead_time! 0.87
set_audio_latency! 5.33

live_audio :modular, amp: 1.5, stereo: true

live_loop :clocks, auto_cue: false do
  cue ("clock" + (tick % 8).to_s).to_sym
  sleep 1
end
