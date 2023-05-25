{ config, lib, pkgs, ... }:

with lib;

let
  tmuxModule = types.submodule {
    options = {
      enable = mkEnableOption "tmux";
      autostart = mkOption { type = types.bool; default = false; };
    };
  };

in
{
  options.modules.zsh = {
    tmux = mkOption { type = tmuxModule; default = { }; };
  };

  imports = [
    ./starship.nix
    ./shell_tools.nix
  ];

  config = mkIf config.modules.zsh.tmux.enable (mkMerge [
    {
      home.packages = [ pkgs.diceware ];
      home.file.".config/tmux/nightfox.conf".source = ./tmux/nightfox.conf;

      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 1;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        aggressiveResize = true;
        resizeAmount = 5;
        prefix = "C-Space";
        shortcut = "Space";
        terminal = "tmux-256color";
        secureSocket = true;
        plugins = with pkgs; [
          tmuxPlugins.yank
          {
            plugin = tmuxPlugins.vim-tmux-navigator;
          }
        ];
        extraConfig = ''
          # Look good
          # set -ga terminal-overrides ",xterm-256color*:Tc"
          set -sa terminal-features ",xterm-kitty:RGB"
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

          # emacs key bindings in tmux command prompt (prefix + :) are better than vi keys even for vim users
          set -g status-keys emacs

          # Allow automatic renaming of windows
          set -g allow-rename on

          # Renumber windows when one is removed
          set -g renumber-windows on

          # Enable the mouse for scrolling
          bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
          bind -n WheelDownPane select-pane -t= \; send-keys -M

          # Allow tmux to set the title bar
          set -g set-titles on

          # How long to display the pane number on PREFIX-q
          set -g display-panes-time 3000 # 3s

          # How long to wait for repeated keys bound with bind -r
          set -g repeat-time 2000 # 2s

          # A bell in another window should cause a bell in the current window
          set -g bell-action any

          # Don't show distracting notifications
          set -g visual-bell off
          set -g visual-activity off

          # focus events enabled for terminals that support them
          set -g focus-events on

          # detach from tmux when killing a session
          set -g detach-on-destroy on
          # set -g remain-on-exit on
          # set -g pane-died 'if -F "#{&&:#{==:#{session_windows},1},#{==:#{window_panes},1}}" "killp; detach" "killp"'
          # set -g detach-on-destroy off

          # tmux messages are displayed for 4 seconds
          set -g display-time 4000

          # Enable C-Up/Down in vim
          setw -g xterm-keys on
          unbind-key C-Up
          unbind-key C-Down

          # Move around panes like in vim
          bind-key -r h select-pane -L
          bind-key -r j select-pane -D
          bind-key -r k select-pane -U
          bind-key -r l select-pane -R

          # Switch between previous and next window with repeats
          bind -r n next-window
          bind -r p previous-window
          bind -r C-n next-window
          bind -r C-p previous-window

          # Switch between the last used window and the current one
          bind Space last-window

          # use # for vertical and - for horizontal splitting of the current window
          # Also sets the starting path of the new pane to the path of the current pane
          bind '#' split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"

          # open lazygit in new window
          bind g new-window -c "#{pane_current_path}" lazygit

          # Set path for newly created windows too
          bind c new-window -c "#{pane_current_path}"

          # break out current pane into it's own window
          bind + break-pane

          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # Enter copy mode with "PREFIX+C-Space"
          unbind [
          bind C-Space copy-mode

          # Setup 'v' to begin selection as in Vim
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi y send-keys -X copy-pipe "reattach-to-user-namespace pbgopy copy"

          # Update default binding of `Enter` to also use copy-pipe
          unbind -T copy-mode-vi Enter
          bind-key -T copy-mode-vi Enter send-keys -X copy-pipe "reattach-to-user-namespace pbgopy copy"

          # split panes evenly
          bind e select-layout even-horizontal

          ################################################################
          #### Status bar
          ################################################################

          bind s set -g status

          ################################################################
          #### COLOUR (Nightfox)
          ################################################################
          source-file ~/.config/tmux/nightfox.conf
        '';
      };
    }

    (mkIf config.modules.zsh.enable {
      programs.zsh = {
        initExtra = (mkMerge [
          ''
            # tmux
            if [[ -z "$TMUX" ]]; then
              alias tmux="tmux_start"
            fi

            function tmux_start () {

              MUX=${pkgs.tmux}/bin/tmux
              TMUX_SESSIONS=$(echo -e "New Session\n$($MUX ls -F '#{session_name}' 2>/dev/null)" | sed '/^$/d')
              NO_SESSIONS=$(echo "$TMUX_SESSIONS" | wc -l)

              if [ "$NO_SESSIONS" -eq 1 ]; then
                $MUX new-session -s $(diceware -n 2 --no-caps -d -)
                # exit
              else
                TMUX_SESSION=$(echo $TMUX_SESSIONS | gum filter --placeholder "Select session")

                if [ "$TMUX_SESSION" = "New Session" ]; then
                  $MUX new-session -s $(diceware -n 2 --no-caps -d -)
                  # exit
                elif [ "x$TMUX_SESSION" != "x" ]; then
                  $MUX attach $MUX_SESSION
                  # exit
                fi
              fi
            }
          ''

          (mkIf config.modules.zsh.tmux.autostart ''
            if ! [[ -o login ]]; then
              if [[ -z "$TMUX" ]]; then
                tmux_start
              fi
            fi;
          '')
        ]);
      };
    })
  ]);
}

