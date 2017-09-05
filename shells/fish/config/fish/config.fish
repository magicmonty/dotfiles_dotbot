set DEFAULT_USER martingondermann

if [ -e "$TMUX" ]
  set -gx TERM xterm-256color
else
  set -gx TERM screen-256color
end

set fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim

source ~/.config/fish/abbr.fish
source ~/.config/fish/autoenv.fish

set -gx PATH $PATH ~/bin

set -g theme_nerd_fonts yes
set -g theme_color_scheme gruvbox
set -g theme_display_ruby no
set -g theme_display_vi yes
set -g theme_show_exit_status yes
set -g fish_prompt_pwd_dir_length 0
set -g theme_newline_cursor no
set -g default_user martingondermann

set -g DOTNET_CLI_TELEMETRY_OPTOUT 1
