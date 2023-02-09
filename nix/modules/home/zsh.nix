{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.zsh = {
    enable = mkOption { type = types.bool; default = false; };
    enablePortals = mkOption { type = types.bool; default = true; };
    portalPath = mkOption { type = types.str; default = "$HOME/.portals"; };
  };

  config = mkIf config.modules.zsh.enable {
    home.packages = with pkgs; [
      zsh
      starship
      exa
      bat
      peco
      broot
      ranger
      zoxide
      zellij
    ];

    home.file.".config/starship.toml".source = ./zsh/starship.toml;
    home.file.".config/zellij/config.kdl".source = ./zellij/config.kdl;

    programs.zsh = {
      enable = true;

      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;

      cdpath = mkIf config.modules.zsh.enablePortals [ config.modules.zsh.portalPath ];

      initExtraFirst = ''
        if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi
      '';

      initExtra = (mkMerge [
        ''
                    # TODO: this isn't neccessarily wsl related anymore -- revise naming
                    # TODO: use PM2 instead of ad-hoc shellscripts
                    # Execute any custom wsl-service scripts
                    for file in /etc/profile.d/**/*.wsl-service(DN); . $file
                    for file in $HOME/.nix-profile/etc/profile.d/**/*.wsl-service(DN); . $file
          	  alias v=nvim
        ''
        ''
          alias cp="cp -i"                                                # Confirm before overwriting something
          alias df='df -h'                                                # Human-readable sizes
          alias free='free -m'                                            # Show sizes in MB
          alias gitu='git add . && git commit && git push'
          alias vi='nvim'
          alias v='nvim'
          alias ls='exa --git'
          alias la='exa --git -glah --color-scale'
          alias ll='exa --git -glh --color-scale'
          alias l='exa --git -lh --color-scale'
          alias c.='code .'
          alias e='emacsclient -nt'
          alias ec='emacsclient -nc'
          alias vimdiff='nvim -d'
        
          ## Git aliases
          alias lg='lazygit'
          alias g='git'
          alias gci='git commit'
          alias gcim='git commit --message'
          alias gcima='git commit --all --message'
          alias gs='git status'
          alias gst='git status'
          alias gstu='git status --untracked-files=no'
          alias amend='git commit --amend --no-edit'
          alias reword='git commit --amend --message'
          alias gu='git reset HEAD~1'
          alias grh='git reset --hard'
          alias ga='git add'
          alias gaa='git add --all'
          alias unstage='git reset HEAD'
          alias gco='git checkout'
          alias gb='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1} | delta" --pointer="" | xargs git checkout'
          alias gbr='git branch'
          alias gbrs='git branch --all -verbose'
          alias gp='git push'
          alias gpush='git push'
          alias gpull='git pull'
          alias gpf='git push --force-with-lease'
          alias grv='git remote --verbose'
          alias gd='git diff'
          alias gdc='git diff --staged'
          alias gshow='git diff --staged'
          alias gdt='git difftool'
          alias gmt='git mergetool'
          alias unresolve='git checkout --conflict=merge'
          alias gll='git log'
          alias gl='git log --oneline --max-count=15'
          alias gld='git log --oneline --max-count=15 --decorate'
          alias ggl='git log --graph --oneline --decorate --branches --all'
          alias hsit="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
          alias wdw='git wdw'
          alias most-changed="git log --format=%n --name-only | grep -v '^$' | sort | uniq -c |--numeric-sort --reverse | head -n 50"
          alias gcleanf='git cleanf -xdf'
          alias gv='nvim -c "GV" -c "tabonly"'
          alias gitv='nvim -c "GV" -c "tabonly"'
          alias gls="git log --graph --oneline --decorate --all --color=always | fzf --ansi +s --preview='git show --color=always {2}' --bind='ctrl-d:preview-page-down' --bind='ctrl-u:preview-page-up' --bind='enter:execute:git show --color=always {2} | less -R' --bind='ctrl-x:execute:git checkout {2} .'"
        
          # Zellij
          alias tmux=zellij
          alias mux=zellij
        
          alias zz="z -" # Toggle last directory

        ''
        (mkIf config.modules.zsh.enablePortals ''
          mkdir -p ${ config.modules.zsh.portalPath }
          zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories path-directories'
          zstyle ':completion:*' group-name ${"''"}
          zstyle ':completion:*:descriptions' format %B%U%d:%u%b
          eval "$(starship init zsh)"
        '')

        ''
          # Add Windows Path, if run in WSL
          if uname -r | grep -q 'microsoft'; then
            export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows/SysWOW64/:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
          fi
        ''

        ''
          eval "$(zoxide init zsh)"
        ''

        ''
          eval "$(zellij setup --generate-auto-start zsh)"
          function zr () { zellij run --name "$*" -- zsh -ic "$*";}
          function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
          function ze () { zellij edit "$*";}
          function zef () { zellij edit --floating "$*";}
        ''
      ]);
    };

  };
}

