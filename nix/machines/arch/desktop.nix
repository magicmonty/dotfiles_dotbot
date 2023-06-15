{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in
{
  imports = [
    "/home/${username}/.dotfiles/nix/modules/home/git.nix"
    "/home/${username}/.dotfiles/nix/modules/home/zsh.nix"
    "/home/${username}/.dotfiles/nix/modules/home/zathura.nix"
  ];

  modules = {
    git = {
      enable = true;
      user = "Martin Gondermann";
      email = "magicmonty@pagansoft.de";
    };

    zsh = {
      enable = true;
      yayAliases = true;
      tmux = {
        enable = true;
        autostart = false;
      };
    };
  };

  programs.home-manager.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";

    file.".config/nixpkgs/config.nix" = {
      text = ''
        { allowUnfree = true; }
      '';
    };

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "$HOME/bin"
    ];
  };
}
