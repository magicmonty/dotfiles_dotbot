# Sonic Pi init file
# Code in here will be evaluated on launch.

load_snippets "~/.sonic-pi/snippets", quiet: true

$root = :A
$octave = 4
$tonic = :minor
$progression = :i

def cur_root
  note $root, octave: $octave
end

def cur_scale_bare (num_octaves: 1)
  scale $tonic, num_octaves: num_octaves
end

def cur_scale (num_octaves: 1)
  scale cur_root, $tonic, num_octaves: num_octaves
end

def cur_chord (number_of_notes: 4)
  chord_degree $progression, cur_root, $tonic, number_of_notes
end

$markov =
  {
    :major => {
      :i => [ :ii, :iv, :vi ],
      :ii => [ :v ],
      :iv => [ :v ],
      :v => [ :i ],
      :vi => [ :iv ]
    },
    :minor => {
      :i => [ :ii, :iv, :vi ],
      :ii => [ :v ],
      :iii => [ :vii ],
      :iv => [ :vii, :v ],
      :v => [ :i ],
      :vi => [ :iii, :vii ],
      :vii => [ :i ]
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
  .map { |ary| ary.map { |a| a ? ary.length : 0 } }
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
  (n - min) < (max - n) ? min : max
end

def make_ring(length)
  Array.new(length).fill { yield }.ring
end

def mute
  set_mixer_control! amp: 0.0
end

def unmute
  set_mixer_control! amp: 1.0
end

$volca_port = "usb-midi-gerät"
$circuit_port = "circuit"

def volca_fm(note, sustain: 0.25, vel: 50)
  midi_cc 41, vel, port: $volca_port, channel: 1
  midi note, sustain: sustain, port: $volca_port, channel: 1
end

def volca_bass(note, sustain: 0.25, vel: 128)
  midi note, sustain: sustain, vel: vel, port: $volca_port, channel: 2
end

def c1(note, sustain: 1.0, vel: 128)
  midi note, sustain: sustain, vel: vel, port: $circuit_port, channel: 1
end

def c2(note, sustain: 1.0, vel: 128)
  midi note, sustain: sustain, vel: vel, port: $circuit_port, channel: 2
end
