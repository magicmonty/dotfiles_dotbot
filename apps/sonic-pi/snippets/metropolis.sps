#key: metropolis
#point_line:7
#point_index:21
# --
seq = cur_scale num_octaves: 1
steps = 8
pulse_counts = ring(1)
types = ring(:repeat)
slides = bools(0)
dur = 0.125

with_fx :level, amp: 0 do
  norm_seq = seq.take steps
  norm_pulses = pulse_counts.take steps
  norm_types = types.take steps
  norm_slides = slides.take steps
  s = play norm_seq[0], amp: 0, sustain: dur * norm_pulses.to_a.sum, release: dur
  steps.times do
    idx = tick
    current_note = norm_seq[idx]
    pulse_count = norm_pulses[idx]
    type = norm_types[idx]
    is_slide = norm_slides[idx + 1]
    case type
    when :repeat
      pulse_count.times do
        control s, amp: 1, note: current_note
        sleep dur / 2
        control s, amp: 0
        sleep dur / 2
      end
    when :hold
      control s, amp: 1, note: current_note
      sleep pulse_count * dur
      control s, amp: 0
    when :tick
      control s, amp: 1, note: current_note
      sleep dur / 2
      control s, amp: 0
      sleep (pulse_count * dur) - (dur / 2)
    when :sleep
      control s, amp: 0
      sleep pulse_count * dur
    end

    if is_slide then
      control s, note_slide: dur / 2
    else
      control s, note_slide: 0
    end
  end
end
