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

def fadeout (max: 1, step_size: 0.01)
  return (ramp (range max, 0, step_size: step_size, inclusive: true)).flatten
end

def fadein (max: 1, step_size: 0.01)
  return (ramp (range 0, max, step_size: step_size, inclusive: true)).flatten
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

def turing_key(name)
  (name.to_s + "_turingbuffer").to_sym
end

def turing_new!(name, size=8, prob=0)
  key = turing_key name
  buffer = get(key)
  if not buffer then
    prng = Random.new
    buffer = [ Array.new(size) { |i| prng.rand > 0.5 },
               size,
               prob ]
    set(key, buffer)
  elsif buffer[1] != size
    turing_size! name, size
  elsif buffer[2] != prob
    turing_prob! name, prob
  end
end

def turing!(name)
  key = turing_key name
  buffer = get(key)
  if not buffer then
    turing_new! name
  else
    prng = Random.new
    prob = buffer[2]

    oldbools = buffer[0]
    head = oldbools.first

    if prob == 0 then
     head = oldbools.first
    elsif prob == 100
      head = one_in 2
    else
      head = prng.rand(100) <= prob ? !head : head
    end

    newbools = oldbools.drop(1).push head
    newbuffer = [ newbools, buffer[1], prob ]
    set key, newbuffer
  end
end

def turing_size!(name, size)
  key = turing_key name
  buffer = get(key)
  if not buffer then
    turing_new! name, size
  elsif buffer[1] > size
    newbuffer = [ buffer[0], size, buffer[2] ]
    set key, newbuffer
  elsif buffer[1] < size
    prng = Random.new
    newbools = Array.new(size - buffer[1]) { |i| prng.rand > 0.5 }
    newbuffer = [ buffer[0] + newbools, size, buffer[2] ]
    set key, newbuffer
  end
end

def turing_prob!(name, prob)
  key = turing_key name
  buffer = get(key)
  if not buffer then
    turing_new! name, 8, prob
  else
    newbuffer = [ buffer[0], buffer[1], [100.0, prob].min ]
    set key, newbuffer
  end
end

def turing_probf!(name, prob)
  turing_prob! name, ([prob, 1.0].min * 100.0)
end

def turing_bools(name)
  key = turing_key name
  buffer = get(key)
  if not buffer then
    turing_new! name
    buffer = get(key)
  end

  buffer[0].take(buffer[1])
end

def turing_val(name)
  b = turing_bools(name).map { |b| b ? 1 : 0 }
  num = 0
  [b.length, 8].min.times do |i|
    num = num << 1 | b[i]
  end

  num
end

def turing_reset!(name)
  key = turing_key name
  set key, nil
end

def vscale(value, min=0, max=1, to_min=0, to_max=100)
  ((to_max.to_f-to_min.to_f)/(max.to_f-min.to_f))*value.to_f + to_min.to_f
end

def turing_midi_val(name, notes)
  v_quant(vscale(turing_val(name), 0, 255, notes.min, notes.max), notes)
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

def hermod1(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 1})
  midi *params, **opts
end
def hermod1_trig
  hermod1 :C4, sustain: 0.1
end
def hermod2(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 2})
  midi *params, **opts
end
def hermod2_trig
  hermod2 :C4, sustain: 0.1
end
def hermod3(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 3})
  midi *params, **opts
end
def hermod3_trig
  hermod3 :C4, sustain: 0.1
end
def hermod4(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 4})
  midi *params, **opts
end
def hermod4_trig
  hermod4 :C4, sustain: 0.1
end
def hermod5(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 5})
  midi *params, **opts
end
def hermod5_trig
  hermod5 :C4, sustain: 0.1
end
def hermod6(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 6})
  midi *params, **opts
end
def hermod6_trig
  hermod6 :C4, sustain: 0.1
end
def hermod7(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 7})
  midi *params, **opts
end
def hermod7_trig
  hermod7 :C4, sustain: 0.1
end
def hermod8(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 8})
  midi *params, **opts
end
def hermod8_trig
  hermod8 :C4, sustain: 0.1
end

def hermod1_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 1})
  midi_cc 1, *params, **opts
end
def hermod2_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 2})
  midi_cc 1, *params, **opts
end
def hermod3_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 3})
  midi_cc 1, *params, **opts
end
def hermod4_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 4})
  midi_cc 1, *params, **opts
end
def hermod5_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 5})
  midi_cc 1, *params, **opts
end
def hermod6_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 6})
  midi_cc 1, *params, **opts
end
def hermod7_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 7})
  midi_cc 1, *params, **opts
end
def hermod8_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({port: $hermod, channel: 8})
  midi_cc 1, *params, **opts
end

