local installed, wt = pcall(require, 'wezterm')
if not installed then
  return
end
local act = wt.action
local nf = wt.nerdfonts

local function bg(color)
  return { Background = { Color = color } }
end

local function fg(color)
  return { Foreground = { Color = color } }
end

local function txt(text)
  return { Text = text }
end

local function left_arrow()
  return txt(nf.pl_right_hard_divider)
end

local function right_arrow()
  return txt(nf.pl_left_hard_divider)
end

wt.on('update-right-status', function(window, pane)
  -- window:set_right_status(window:active_workspace())

  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find('/')
    local cwd = ''
    local hostname = ''
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find('[.]')
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash)
      cwd = string.gsub(cwd, '/home/mgondermann', '~')

      table.insert(cells, cwd)
      table.insert(cells, hostname)
    end
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#6085b6',
    '#719cd6',
    '#86abcd',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#cdcecf'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  table.insert(elements, fg(colors[1]))
  table.insert(elements, bg('#192330'))
  table.insert(elements, left_arrow())

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, fg(text_fg))
    table.insert(elements, bg(colors[cell_no]))
    table.insert(elements, txt(' ' .. text .. ' '))
    if not is_last then
      table.insert(elements, fg(colors[cell_no + 1]))
      table.insert(elements, left_arrow())
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wt.format(elements))
end)

function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end

  return tab_info.active_pane.title
end

wt.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local edge_backgound = '#192330'
  local background = '#29394f'
  local foreground = '#cdcecf'

  if tab.is_active then
    background = '#6085b6'
  elseif hover then
    background = '#39506d'
  end

  local edge_foreground = background

  local title = tab_title(tab)

  if not tab.is_active then
    if tab.tab_index < 9 then
      title = (tab.tab_index + 1) .. ': ' .. title
    end
  end

  title = wt.truncate_right(title, max_width - 2)

  return {
    bg(edge_backgound),
    fg(edge_foreground),
    left_arrow(),
    bg(background),
    fg(foreground),
    txt(' ' .. title .. ' '),
    bg(edge_backgound),
    fg(edge_foreground),
    right_arrow(),
  }
end)

local keys = {
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
  { key = '*', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '=', mods = 'CTRL|SHIFT', action = act.ResetFontSize },
  { key = '#', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = '-', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection('Left') },
  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection('Down') },
  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection('Up') },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
  { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection('Right') },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'd', mods = 'LEADER', action = act.DetachDomain('CurrentPaneDomain') },
  { key = 't', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'c', mods = 'LEADER', action = act.SwitchToWorkspace },
  { key = 'n', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },
  {
    key = 'g',
    mods = 'CTRL',
    action = act.SpawnCommandInNewTab({
      label = 'Git',
      domain = 'CurrentPaneDomain',
      args = { 'lazygit' },
    }),
  },
  { key = '.', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = ',', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'X', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'resize_pane',
      one_shot = false,
    }),
  },
  { key = '0', mods = 'LEADER', action = act.PaneSelect({ mode = 'SwapWithActive' }) },
  { key = 'F1', action = act.ShowTabNavigator },
  { key = 'F2', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },
}

local resize_pane = {
  { key = 'LeftArrow', action = act.AdjustPaneSize({ 'Left', 1 }) },
  { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
  { key = 'DownArrow', action = act.AdjustPaneSize({ 'Down', 1 }) },
  { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
  { key = 'UpArrow', action = act.AdjustPaneSize({ 'Up', 1 }) },
  { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
  { key = 'RightArrow', action = act.AdjustPaneSize({ 'Right', 1 }) },
  { key = 'r', action = act.AdjustPaneSize({ 'Right', 1 }) },
  { key = 'Escape', action = 'PopKeyTable' },
}

for i = 1, 8 do
  table.insert(keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

return {
  color_scheme = 'nightfox',
  font = wt.font('JetBrainsMono Nerd Font'),
  font_size = 14.0,
  window_background_opacity = 0.7,
  hide_tab_bar_if_only_one_tab = false,
  bold_brightens_ansi_colors = 'BrightAndBold',
  unix_domains = { { name = 'unix' } },
  default_gui_startup_args = { 'connect', 'unix' },
  force_reverse_video_cursor = false,
  adjust_window_size_when_changing_font_size = false,
  audible_bell = 'Disabled',
  exit_behavior = 'Close',
  use_dead_keys = false,
  window_close_confirmation = 'NeverPrompt',
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  disable_default_key_bindings = true,
  leader = { key = 'Space', mods = 'CTRL' },
  keys = keys,
  key_tables = {
    resize_pane = resize_pane,
  },
  use_fancy_tab_bar = true,
  window_frame = {
    font = wt.font('JetBrainsMono Nerd Font'),
    font_size = 14.0,
    active_titlebar_bg = '#192330',
    inactive_titlebar_bg = '#192330',
  },
  show_new_tab_button_in_tab_bar = false,
}
