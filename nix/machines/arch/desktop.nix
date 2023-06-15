{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in
{
  imports = [
    "${homedir}/.dotfiles/nix/modules/home/git.nix"
    "${homedir}/.dotfiles/nix/modules/home/zsh.nix"
    "${homedir}/.dotfiles/nix/modules/home/kitty.nix"
    "${homedir}/.dotfiles/nix/modules/home/neovim_light.nix"
    "${homedir}/.dotfiles/nix/modules/home/hyprland.nix"
  ];

  modules = {
    git = {
      enable = true;
      user = "Martin Gondermann";
      email = "magicmonty@pagansoft.de";
    };

    kitty.enable = true;
    neovim.enable = true;

    hyprland = {
      enable = true;
      entrypoint = ../../modules/home/hyprland/hypr/hyprland.thinkmg.conf;
    };

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

    file.".config/hypr/hyprland.conf" = {
        source = ../../modules/home/hypr/hyprland.desktop.conf;
    };

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "$HOME/bin"
    ];
  };
}
