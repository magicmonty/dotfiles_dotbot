#key: metropolism
#point_line:7
#point_index:21
# --
seq = cur_scale num_octaves: 1
steps = 8
pulse_counts = ring(1)
types = ring(:repeat)
dur = 0.125

with_fx :level, amp: 0 do
  norm_seq = seq.take steps
  norm_pulses = pulse_counts.take steps
  norm_types = types.take steps
  norm_slides = slides.take steps
  steps.times do
    idx = tick
    current_note = norm_seq[idx]
    pulse_count = norm_pulses[idx]
    type = norm_types[idx]
    case type
    when :repeat
      pulse_count.times do
        m current_note, sustain: dur * 0.75
        sleep dur
      end
    when :hold
      m current_note, sustain: pulse_count * dur
      sleep pulse_count * dur
    when :tick
      m current_note, sustain: dur
      sleep (pulse_count * dur)
    when :sleep
      sleep pulse_count * dur
    end
  end
end
