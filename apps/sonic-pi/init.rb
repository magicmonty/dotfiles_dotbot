# Sonic Pi init file
# Code in here will be evaluated on launch.

$root = :A
$octave = 4
$tonic = :minor
$progression = :I

def cur_root
  note $root, octave: $octave
end

def cur_scale_bare (num_octaves: 1)
  scale $tonic, num_octaves: num_octaves
end

def cur_scale (num_octaves: 1)
  scale cur_root, $tonic, num_octaves: num_octaves
end

$modes = { 
  :major => [ :major7, :minor7, :minor7, :major7, "7", :minor7 ],
  :minor => [ :minor7, "m7-5", :major7, :minor7, :minor7, :major7, "7" ]
}

$scales = {
  :C => [ :C, :D, :Eb, :F, :G, :Ab, :Bb ],
  :Db => [ :Dd, :Eb, :E, :Gb, :Ab, :A, :B ],
  :D => [ :D, :E, :F, :G, :A, :Bb, :C ],
  :Eb => [ :Eb, :F, :Gb, :Ab, :Bb, :B, :Db ],
  :E => [ :E, :Gb, :G, :A, :B, :C, :D ],
  :F => [ :F, :G, :Ab, :Bb, :C, :Db, :Eb ],
  :Gb => [ :Gb, :Ab, :A, :B, :Db, :D, :E ],
  :G => [ :G, :A, :Bb, :C, :D, :Eb, :F ],
  :Ab => [ :Ab, :Bb, :B, :Db, :Eb, :E, :Gb ],
  :A => [ :A, :B, :C, :D, :E, :F, :G ],
  :Bb => [ :Bb, :C, :Db, :Eb, :F, :Gb, :Ab ],
  :B => [ :B, :Db, :D, :E, :Gb, :G, :A ]
}

def get_progression_num (sym)
  case sym
  when :I, :i
    0
  when :II, :ii
    1
  when :III, :iii
    2
  when :IV, :iv
    3
  when :V, :v
    4
  when :VI, :vi
    5
  when :VII, :vii
    6
  else 
    (sym - 1) % 7
  end
end

def cur_progression (num: $progression)
  index = get_progression_num num
  if $modes.has_key?($tonic) && (index < $modes[$tonic].length)
    pitch_class = (note_info cur_root).pitch_class
    if $scales.has_key?(pitch_class)
      [$scales[pitch_class][index], $modes[$tonic][index]]
    else
      [$root, $tonic]
    end
  else
    [$root, $tonic]
  end
end

$markov =
  {
    :major => {
      :I => [ :II, :IV, :VI ],
      :II => [ :V ],
      :IV => [ :V ],
      :V => [ :I ],
      :VI => [ :IV ]
    },
    :minor => {
      :I => [ :II, :IV, :VI ],
      :II => [ :V ],
      :III => [ :VII ],
      :IV => [ :VII, :V ],
      :V => [ :I ],
      :VI => [ :III, :VII ],
      :VII => [ :I ]
    }
  }

def progress_markov
  if $markov.has_key?($tonic)
    chain = $markov[$tonic]
    if chain.has_key?($progression)
      $progression = chain[$progression].choose
    end
  end
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
