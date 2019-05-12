# Sonic Pi init file
# Code in here will be evaluated on launch.

require "~/.sonic-pi/string_ext.rb"

load_snippets "~/.sonic-pi/snippets", quiet: true
$samples = "~/.sonic-pi/samples"
load_samples $samples

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
  return (Math.cos(vt * 1/cycle)) * range + center
end

def sinr(center, range, cycle)
  return (Math.sin(vt * 1/cycle)) * range + center
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

def as_bools(s)
  s.scan(/\w/).map { |v| v == "1" }.ring
end

def mute
  set_mixer_control! amp: 0.0
end

def unmute
  set_mixer_control! amp: 1.0
end

$volca_port = "usb_uno_midi_interface_midi_1"
$circuit_port = "circuit_midi_1"
$hermod = "hermod_midi_1"

def volca_fm(note, sustain: 0.25)
  midi note, sustain: sustain, port: $volca_port, channel: 1
end

def volca_fm_vel(vel)
  midi_cc 41, vel, port: $volca_port, channel: 1
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

def m(note, sustain: 0.25, vel:128)
  midi note, sustain: sustain, vel: vel, port: $volca_port, channel: 3
end

def mcc(value)
  midi_cc 128, value, port: $volca_port, channel: 3
end

$kodelife_port = "midi_through_port-0"

def vis(ctrl, value)
  midi_cc ctrl, val_f: value, channel: 16, port: $kodelife_port
end

def vis_electric(value)
  vis 21, value
end

def vis_ether(value)
  vis 22, value
end

def vis_func(value)
  vis 23, value
end

def sample_(*args, &blk)
  sample(*args.prepend($samples), &blk)
end

# given a list of cycles calculate a common cycle
# length so that all cycles complete fully
# e.g common_cycle [4, 8, 3] => 24
def common_cycle(lengths, *args)
  calcLengths = args.length == 1 ? args[0] : lengths
  if calcLengths.length == 0 then
    0
  elsif calcLengths.length == 1 || calcLengths.uniq.length == 1 then
    calcLengths[0]
  else
    max = calcLengths.max
    calcLengths = calcLengths.map.with_index { |x, i| x < max ? x + lengths[i] : x }
    shared_length lengths, calcLengths
  end
end

def turing(name, size=8, prob=0)
  prng = Random.new
  key = (name.to_s + "_turingbuffer").to_sym
  buffer = get(key)
  if not buffer then
    buffer = Array.new(size) { |i| prng.rand }
  elsif buffer.length > size
    buffer = buffer.take size
  elsif buffer.length < size
    newbuffer = Array.new(size - buffer.length) { |i| prng.rand }
    buffer = buffer + newbuffer
  else
    head = buffer.first
    if one_in (prob == 0 ? 0 : 1 / prob) then
      head = prng.rand
    end

    buffer = buffer.drop(1).push head
  end

  set(key, buffer)
  buffer
end

def turing_look(name)
  prng = Random.new
  key = (name.to_s + "_turingbuffer").to_sym
  buffer = get(key)
  if not buffer then
    buffer = Array.new(8) { |i| prng.rand }
  end

  set(key, buffer)
  buffer
end

def reset_turing(name)
  key = (name.to_s + "_turingbuffer").to_sym
  set key, nil
end

def vscale(value, min=0, max=1, to_min=0, to_max=100)
  ((to_max.to_f-to_min.to_f)/(max.to_f-min.to_f))*value.to_f + to_min.to_f
end

def to_scl(value, notes)
  v_quant(vscale(value, 0, 1, notes.min, notes.max), notes)
end

def notify(msg)
  job = fork do
    exec('notify-send -t 15000 -h string:x-canonical-private-synchronous:sonic-pi-notification "Sonic Pi" "' + msg + '"')
  end
  Process.detach job
end

