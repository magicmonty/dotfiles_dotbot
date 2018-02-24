# Sonic Pi init file
# Code in here will be evaluated on launch.

load_snippets "~/.sonic-pi/snippets", quiet: true

set :root, :A
set :octave, 4
set :tonic, :minor
set :progression, :i

def cur_root
  note get(:root), octave: get(:octave)
end

def cur_scale_bare (num_octaves: 1)
  scale get(:tonic), num_octaves: num_octaves
end

def cur_scale (num_octaves: 1)
  scale cur_root, get(:tonic), num_octaves: num_octaves
end

def cur_chord (number_of_notes: 4)
  chord_degree get(:progression), cur_root, get(:tonic), number_of_notes
end

def arp (arp_type: :up)
  notes = cur_chord.take(3).ring
  case arp_type
  when :up
    notes
  when :down
    notes.reverse
  when :updown
    (notes.to_a + notes.drop(1).take(1)).ring
  when :pingpong
    (notes.to_a + notes.drop(1).take(1)).ring
  when :downup
    (notes.to_a.reverse + notes.drop(1).take(1)).ring
  when :alberti
    ring(notes[0], notes[2], notes[1], notes[2])
  when :random
    notes.shuffle
  end
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

def progress(chain)
  return unless chain
  prog = get(:progression)
  if chain.has_key? prog
    set :progression, chain[prog].choose
  end
end

def progress_markov
  return unless $markov.has_key?(get(:tonic))
  progress $markov[get(:tonic)]
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
