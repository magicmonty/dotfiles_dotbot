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
    enable = mkOption { type = types.bool; default = false; };
    yayAliases = mkOption { type = types.bool; default = false; };
    tmux = mkOption { type = tmuxModule; default = { }; };
  };

  config = mkIf config.modules.zsh.enable (mkMerge [
    {
      home.packages = with pkgs; [
        ranger
        gum
        ripgrep
      ];

      home.file.".config/starship.toml".source = ./zsh/starship.toml;

      programs = {
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        starship = {
          enable = true;
          enableZshIntegration = true;
        };

        exa = {
          enable = true;
          enableAliases = false;
        };

        bat = {
          enable = true;
          config = {
            theme = "base16-256";
            "italic-text" = "always";
          };
        };

        broot = {
          enable = true;
          enableZshIntegration = true;
          settings = { modal = true; };
        };

        zsh = {
          enable = true;

          autocd = true;
          enableCompletion = true;
          enableAutosuggestions = true;
          enableSyntaxHighlighting = true;
          historySubstringSearch.enable = true;


          history = {
            size = 1000;
            save = 500;
          };

          defaultKeymap = "emacs";

          sessionVariables = {
            NVIM_LISTEN_ADDRESS = "~/.cache/nvim/server.pipe";
          };

          shellAliases = {
            v = "nvim";
            ls = "exa --git";
            la = "exa --git -glah --color-scale";
            ll = "exa --git -glh --color-scale";
            l = "exa --git -lh --color-scale";
            "c." = "code .";
            lg = "lazygit";
            g = "git";
            gci = "git commit";
            gcim = "git commit --message";
            gcima = "git commit --all --message";
            gs = "git status";
            gst = "git status";
            gstu = "git status --untracked-files=no";
            amend = "git commit --amend --no-edit";
            reword = "git commit --amend --message";
            gu = "git reset HEAD~1";
            grh = "git reset --hard";
            ga = "git add";
            gaa = "git add --all";
            unstage = "git reset HEAD";
            gco = "git checkout";
            gb = "git branch --sort=-committerdate | fzf --header \"Checkout Recent Branch\" --preview \"git diff --color=always {1} | delta\" --pointer=\"\" | xargs git checkout";
            gbr = "git branch";
            gbrs = "git branch --all -verbose";
            gp = "git push";
            gpush = "git push";
            gpull = "git pull";
            gpf = "git push --force-with-lease";
            grv = "git remote --verbose";
            gd = "git diff";
            gdc = "git diff --staged";
            gshow = "git diff --staged";
            gdt = "git difftool";
            gmt = "git mergetool";
            unresolve = "git checkout --conflict=merge";
            gll = "git log";
            gl = "git log --oneline --max-count=15";
            gld = "git log --oneline --max-count=15 --decorate";
            ggl = "git log --graph --oneline --decorate --branches --all";
            hsit = "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
            wdw = "git wdw";
            most-changed = "git log --format=%n --name-only | grep -v '^$' | sort | uniq -c |--numeric-sort --reverse | head -n 50";
            gcleanf = "git cleanf -xdf";
            gv = "nvim -c \"GV\" -c \"tabonly\"";
            gitv = "nvim -c \"GV\" -c \"tabonly\"";
            gls = "git log --graph --oneline --decorate --all --color=always | fzf --ansi +s --preview='git show --color=always {2}' --bind='ctrl-d:preview-page-down' --bind='ctrl-u:preview-page-up' --bind='enter:execute:git show --color=always {2} | less -R' --bind='ctrl-x:execute:git checkout {2} .'";
            zz = "z -"; # Toggle last directory via zoxide
          };

          initExtraFirst = ''
            if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi
          '';

          initExtraBeforeCompInit = ''
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
            zstyle ':completion:*' rehash true                              # automatically find new executables in path
            # Speed up completions
            zstyle ':completion:*' accept-exact '*(N)'
            zstyle ':completion:*' use-cache on
            zstyle ':completion:*' cache-path ~/.zsh/cache
          '';

          initExtra = (mkMerge [
            ''
              ## Options section
              setopt correct                                                  # Auto correct mistakes
              setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
              setopt nocaseglob                                               # Case insensitive globbing
              setopt rcexpandparam                                            # Array expension with parameters
              setopt nocheckjobs                                              # Don't warn about running processes when exiting
              setopt numericglobsort                                          # Sort filenames numerically when it makes sense
              setopt nobeep                                                   # No beep
              setopt appendhistory                                            # Immediately append history instead of overwriting
              setopt histignorealldups                                        # If a new command is a duplicate, remove the older one

              # Don't consider certain characters part of the word
              WORDCHARS=''${WORDCHARS//\/[&.;]}

              if [ -e $HOME/.defaultapps ]; then
                source $HOME/.defaultapps
              fi
            ''

            (mkIf config.modules.zsh.yayAliases ''
              if command -v yay &> /dev/null; then
                # yay aliases
                pclean() {
                  sudo pacman -Sc
                  yay -Sc
                  yay -Rns $(yay -Qtdq) 2>/dev/null
                  paccache -r
                }

                pupd() {
                  notify-send -a 'Package Update' 'Upgrade started'
                  yay -Syyuv --noconfirm --noeditmenu && notify-send -a 'Package Update' 'Update completed' || notify-send -a 'Package Update' -u critical 'Update failed'
                  pkill -RTMIN+13 i3blocks
                }
                alias pinst='yay --noeditmenu --nodiffmenu --nocleanmenu --answerclean --sudoloop --needed -S'
                alias psearch='yay -Ss'
                alias puninst='yay -R'
              fi
            '')

            ''
              # Add Windows Path, if run in WSL
              if uname -r | grep -q 'microsoft'; then
                export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows/SysWOW64/:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
              fi
            ''
          ]);
        };
      };
    }

    (mkIf config.modules.zsh.tmux.enable {
      home.packages = [ pkgs.diceware ];
      home.file.".config/tmux/nightfox.conf".source = ./tmux/nightfox.conf;

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
                exit
              else
                TMUX_SESSION=$(echo $TMUX_SESSIONS | gum filter --placeholder "Select session")

                if [ "$TMUX_SESSION" = "New Session" ]; then
                  $MUX new-session -s $(diceware -n 2 --no-caps -d -)
                elif [ "x$TMUX_SESSION" != "x" ]; then
                  $MUX attach $MUX_SESSION
                fi
              fi
            }
          ''

          (mkIf config.modules.zsh.tmux.autostart ''
            if [[ -z "$TMUX" ]]; then
              tmux_start
            fi
          '')
        ]);
      };

      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 0;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        aggressiveResize = true;
        resizeAmount = 5;
        prefix = "C-Space";
        shortcut = "Space";
        terminal = "tmux-256color";
        secureSocket = true;
        extraConfig = ''
          # Look good
          set -ga terminal-overrides ",xterm-256color*:Tc"
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

          # don't detach from tmux when killing a session
          set -g detach-on-destroy off

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

          # Smart pane switching with awareness of vim splits
          is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
          bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
          bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
          bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
          bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

          # Switch between previous and next window with repeats
          bind -r n next-window
          bind -r p previous-window
          bind C-n next-window
          bind C-p previous-window

          # Switch between the last used window and the current one
          bind Space last-window

          # use # for vertical and - for horizontal splitting of the current window
          # Also sets the starting path of the new pane to the path of the current pane
          bind '#' split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"

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
          # set -g status-justify center

          set -g status-right-length 30
          set -g status-interval 3
          set -g status-left-length 48
          set -g status-right "#[fg=blue]#S#[fg=default]__#[fg=yellow]%d %b %Y_%H:%M "

          ################################################################
          #### COLOUR (Nightfox)
          ################################################################
          source-file ~/.config/tmux/nightfox.conf
        '';
      };
    })

  ]);
}

