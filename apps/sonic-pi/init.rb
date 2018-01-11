# Sonic Pi init file
# Code in here will be evaluated on launch.

def volca_fm(note, sustain: 0.25, vel: 50)
  midi_cc 41, vel, port: "usb_uno_midi_interface", channel: 1
  midi note, sustain: sustain, port: "usb_uno_midi_interface", channel: 1
end

def volca_bass(note, sustain: 0.25, vel: 128)
  midi note, sustain: sustain, vel: vel, port: "usb_uno_midi_interface", channel: 2
end

def c1(note, sustain: 1.0, vel: 128)
  midi note, sustain: sustain, vel: vel, port: "circuit", channel: 1
end

def c2(note, sustain: 1.0, vel: 128)
  midi note, sustain: sustain, vel: vel, port: "circuit", channel: 2
end

def cosr(center, range, cycle)
  return (Math.cos (vt*cycle))*range + center
end

def sinr(center, range, cycle)
  return (Math.sin (vt*cycle))*range + center
end

def fadeout (max: 1, step: 0.01)
  return (ramp (range max, 0, step: step, inclusive: true)).flatten
end

def fadein (max: 1, step: 0.01)
  return (ramp (range 0, max, step: step, inclusive: true)).flatten
end

def l_spread (num_accents, size)
  (spread num_accents, size)
  .chunk_while { |i,j| !j }
  .map { |ary| ary.map { |a| if a then ary.length else 0 end } }
  .flatten
  .map { |i| [ i != 0, i ] }
  .ring
end

def v_quant(n, values)
  values = values.to_a
  min = values.min
  max = values.max

  return n if n < min or n > max
  return n if values.include? n

  min = values.reject { |v| v > n }.last
  max = values.reject { |v| v < n }.first
  if (n - min) < (max -n) then
    return min
  else
    return max
  end
end

def mute
  set_mixer_control! amp: 0.0
end

def unmute
  set_mixer_control! amp: 1.0
end

$root = :a4
$scl = (scale :minor)
