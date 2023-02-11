{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in
{
  imports = [
    "/home/${username}/.config/nixpkgs/modules/home/git.nix"
    "/home/${username}/.config/nixpkgs/modules/home/zsh.nix"
    "/home/${username}/.config/nixpkgs/modules/home/neovim.nix"
    "/home/${username}/.config/nixpkgs/modules/home/zathura.nix"
  ];

  modules = {
    git = {
      enable = true;
      user = "Martin Gondermann";
      email = "magicmonty@pagansoft.de";
    };

    neovim.enable = true;
    zathura.enable = true;

    zsh = {
      enable = true;
      yayAliases = true;
      tmux = {
        enable = true;
        autostart = true;
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
