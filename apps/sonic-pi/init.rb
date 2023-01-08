# Sonic Pi init file
# Code in here will be evaluated on launch.

require '~/.sonic-pi/string_ext'

load_snippets '~/.sonic-pi/snippets', quiet: true
$samples = '~/.sonic-pi/samples'
load_samples $samples

set :root, :A
set :octave, 4
set :tonic, :minor
set :progression, :i

$kodelife_port = 'midi_through_port-0'

$midi_port = 'usb_uno_midi_interface_usb_uno_midi_interface_midi_1_20_0'

$volca_port = 'usb_uno_midi_interface_midi_1'
$volca_fm_channel = 2
$volca_bass_channel = 13

$circuit_port = 'circuit_midi_1'
$circuit_synth1_channel = 1
$circuit_synth2_channel = 2
$circuit_drum_channel = 10

$hermod_port = 'hermod_midi_1'
$hermod_active_track_channel = 15
$hermod_drum_tracks_channel = 10
$hermod_track_1_channel = 1
$hermod_track_2_channel = $hermod_drum_tracks_channel
$hermod_track_3_channel = 3
$hermod_track_4_channel = $hermod_drum_tracks_channel
$hermod_track_5_channel = $hermod_drum_tracks_channel
$hermod_track_6_channel = $hermod_drum_tracks_channel
$hermod_track_7_channel = 7
$hermod_track_8_channel = 8

def cur_root
  note get(:root), octave: get(:octave)
end

def cur_scale_bare(num_octaves: 1)
  scale get(:tonic), num_octaves: num_octaves
end

def cur_scale(num_octaves: 1)
  scale cur_root, get(:tonic), num_octaves: num_octaves
end

def cur_chord(number_of_notes: 4)
  chord_degree get(:progression), cur_root, get(:tonic), number_of_notes
end

def arp(arp_type: :up)
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
    major: {
      i: %i[ii iv vi],
      ii: [:v],
      iv: [:v],
      v: [:i],
      vi: [:iv]
    },
    minor: {
      i: %i[ii iv vi],
      ii: [:v],
      iii: [:vii],
      iv: %i[vii v],
      v: [:i],
      vi: %i[iii vii],
      vii: [:i]
    }
  }

def progress(chain)
  return unless chain

  prog = get(:progression)
  set :progression, chain[prog].choose if chain.has_key? prog
end

def progress_markov
  return unless $markov.has_key?(get(:tonic))

  progress $markov[get(:tonic)]
end

def cosr(center, range, cycle)
  Math.cos(vt * 1 / cycle) * range + center
end

def sinr(center, range, cycle)
  Math.sin(vt * 1 / cycle) * range + center
end

def fadeout(max: 1, step_size: 0.01)
  ramp(range(max, 0, step_size: step_size, inclusive: true)).flatten
end

def fadein(max: 1, step_size: 0.01)
  ramp(range(0, max, step_size: step_size, inclusive: true)).flatten
end

def l_spread(num_accents, size)
  (spread num_accents, size)
    .chunk_while { |_i, j| !j }
    .map { |ary| ary.map { |a| a ? ary.length : 0 } }
    .flatten
    .map { |i| [i != 0, i] }
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

def make_ring(length, &block)
  Array.new(length).fill(&block).ring
end

def as_bools(value)
  value.chars.map { |v| %w[1 x].include?(v) }.ring
end

def mute
  set_mixer_control! amp: 0.0
end

def unmute
  set_mixer_control! amp: 1.0
end

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
  if calcLengths.length == 0
    0
  elsif calcLengths.length == 1 || calcLengths.uniq.length == 1
    calcLengths[0]
  else
    max = calcLengths.max
    calcLengths = calcLengths.map.with_index { |x, i| x < max ? x + lengths[i] : x }
    shared_length lengths, calcLengths
  end
end

def turing_key(name)
  (name.to_s + '_turingbuffer').to_sym
end

def turing_new!(name, size = 8, prob = 0)
  key = turing_key name
  buffer = get(key)
  if !buffer
    prng = Random.new
    buffer = [Array.new(size) { |_i| prng.rand > 0.5 },
              size,
              prob]
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
  if !buffer
    turing_new! name
  else
    prng = Random.new
    prob = buffer[2]

    oldbools = buffer[0]
    head = oldbools.first

    head = if prob == 0
             oldbools.first
           elsif prob == 100
             one_in 2
           else
             prng.rand(100) <= prob ? !head : head
           end

    newbools = oldbools.drop(1).push head
    newbuffer = [newbools, buffer[1], prob]
    set key, newbuffer
  end
end

def turing_size!(name, size)
  key = turing_key name
  buffer = get(key)
  if !buffer
    turing_new! name, size
  elsif buffer[1] > size
    newbuffer = [buffer[0], size, buffer[2]]
    set key, newbuffer
  elsif buffer[1] < size
    prng = Random.new
    newbools = Array.new(size - buffer[1]) { |_i| prng.rand > 0.5 }
    newbuffer = [buffer[0] + newbools, size, buffer[2]]
    set key, newbuffer
  end
end

def turing_prob!(name, prob)
  key = turing_key name
  buffer = get(key)
  if !buffer
    turing_new! name, 8, prob
  else
    newbuffer = [buffer[0], buffer[1], [100.0, prob].min]
    set key, newbuffer
  end
end

def turing_probf!(name, prob)
  turing_prob! name, ([prob, 1.0].min * 100.0)
end

def turing_bools(name)
  key = turing_key name
  buffer = get(key)
  unless buffer
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

def vscale(value, min = 0, max = 1, to_min = 0, to_max = 100)
  ((to_max.to_f - to_min.to_f) / (max.to_f - min.to_f)) * value.to_f + to_min.to_f
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

# Hermod controls
def start_hermod
  midi_start port = $hermod_port
end

def stop_hermod
  midi_stop port = $hermod_port
end

# Hermod Channel 1
def hermod1(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_1_channel })
  midi(*params, **opts)
end

def hermod1_trig
  hermod1 :C4, sustain: 0.1
end

def hermod1_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_1_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 2
def hermod2(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_2_channel })
  midi(*params, **opts)
end

def hermod2_trig
  hermod2 :C4, sustain: 0.1
end

def hermod2_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_2_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 3
def hermod3(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_3_channel })
  midi(*params, **opts)
end

def hermod3_trig
  hermod3 :C4, sustain: 0.1
end

def hermod3_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_3_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 4
def hermod4(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_4_channel })
  midi(*params, **opts)
end

def hermod4_trig
  hermod4 :C4, sustain: 0.1
end

def hermod4_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_4_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 5
def hermod5(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_5_channel })
  midi(*params, **opts)
end

def hermod5_trig
  hermod5 :C4, sustain: 0.1
end

def hermod5_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_5_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 6
def hermod6(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_6_channel })
  midi(*params, **opts)
end

def hermod6_trig
  hermod6 :C4, sustain: 0.1
end

def hermod6_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_6_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 7
def hermod7(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_7_channel })
  midi(*params, **opts)
end

def hermod7_trig
  hermod7 :C4, sustain: 0.1
end

def hermod7_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_7_channel })
  midi_cc 1, *params, **opts
end

# Hermod Channel 8
def hermod8(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_8_channel })
  midi(*params, **opts)
end

def hermod8_trig
  hermod8 :C4, sustain: 0.1
end

def hermod8_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_track_8_channel })
  midi_cc 1, *params, **opts
end

# Hermod Drum Channels
def hermod10(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $hermod_port, channel: $hermod_drum_tracks_channel })
  midi(*params, **opts)
end

def hermod10_bd
  hermod10 60, sustain: 0.1
end

def hermod10_sn
  hermod10 62, sustain: 0.1
end

def hermod10_chh
  hermod10 64, sustain: 0.1
end

def hermod10_ohh
  hermod10 65, sustain: 0.1
end

# Volca bass controls

def start_volca_bass
  midi_start port = $volca_port, channel: $volca_bass_channel
end

def stop_volca_bass
  midi_stop port = $volca_port, channel: $volca_bass_channel
end

def volca_bass(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $volca_port, channel: $volca_bass_channel })
  midi(*params, **opts)
end

def volca_bass_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $volca_port, channel: $volca_bass_channel })
  midi_cc(*params, **opts)
end

# Volca FM controls

def start_volca_fm
  midi_start port = $volca_port, channel: $volca_fm_channel
end

def stop_volca_fm
  midi_stop port = $volca_port, channel: $volca_fm_channel
end

def volca_fm(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $volca_port, channel: $volca_fm_channel })
  midi(*params, **opts)
end

def volca_fm_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $volca_port, channel: $volca_fm_channel })
  midi_cc(*params, **opts)
end

# Circuit controls

def start_circuit
  midi_start port = $circuit_port
end

def stop_circuit
  midi_stop port = $circuit_port
end

def circuit_synth1(_note, sustain: 1.0, vel: 128)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $circuit_port, channel: $circuit_synth1_channel })
  midi(*params, **opts)
end

def circuit_synth2(_note, sustain: 1.0, vel: 128)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $circuit_port, channel: $circuit_synth2_channel })
  midi(*params, **opts)
end

def circuit_cc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts = opts.merge({ port: $circuit_port })
  midi_cc(*params, **opts)
end

#- str_scale
define :str_scale do |str, min: 0, max: 1|
  str.chars.filter_map  do |s|
    if (s == '|') or (s == ' ')
      # Bar line, do nothing
    elsif s == '-'
      min
    elsif (s == 'x') or (s == 'X')
      max
    else
      min + (max - min) * Integer(s) / 10.0
    end
  end.ring
end

#- str_select
define :str_select do |str, values|
  str.chars.filter_map do |s|
    if (s == '|') or s == ' '
      # Bar line, do nothing
    elsif s == '-'
      values[0]
    else
      values[Integer(s)]
    end
  end.ring
end
