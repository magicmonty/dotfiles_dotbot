set DEFAULT_USER martingondermann

if [ -e "$TMUX" ]
  set -gx TERM xterm-256color
else
  set -gx TERM screen-256color
end

set fish_key_bindings fish_vi_key_bindings

set -gx BROWSER /usr/bin/qutebrowser
set -gx EDITOR /usr/bin/vim
set -gx RTV_BROWSER /usr/bin/qutebrowser
set -gx RTV_EDITOR /usr/bin/vim
set -gx TERMINAL /usr/bin/termite
set -gx BYOBU_CHARMAP UTF-8
source ~/.config/fish/abbr.fish
source ~/.config/fish/autoenv.fish

if [ -e ~/.cargo/bin/ ]
  set -gx PATH ~/.cargo/bin $PATH
  set -gx MATES_DIR ~/.contacts/pagansoft
end

if [ -e /opt/dotnet ]
  set -gx DOTNET_ROOT /opt/dotnet/
end

if [ -e ~/.dotnet/tools ]
  set -gx PATH ~/.dotnet/tools $PATH
end

if [ -e ~/bin/ ]
  set -gx PATH ~/bin $PATH
end

set -g theme_nerd_fonts yes
set -g theme_color_scheme gruvbox
set -g theme_display_ruby no
set -g theme_display_vi yes
set -g theme_show_exit_status yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_untracked yes
set -g fish_prompt_pwd_dir_length 0
set -g theme_newline_cursor no
set -g default_user martingondermann

set -g DOTNET_CLI_TELEMETRY_OPTOUT 1

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
source ~/.config/fish/shortcuts.fish
