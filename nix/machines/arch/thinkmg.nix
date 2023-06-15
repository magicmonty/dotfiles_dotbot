{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in
{
  imports = [
    "${homedir}/.dotfiles/nix/modules/home/git.nix"
    "${homedir}/.dotfiles/nix/modules/home/zsh.nix"
    "${homedir}/.dotfiles/nix/modules/home/neovim_light.nix"
    "${homedir}/.dotfiles/nix/modules/home/zathura.nix"
    "${homedir}/.dotfiles/nix/modules/home/kitty.nix"
    "${homedir}/.dotfiles/nix/modules/home/hyprland.nix"
  ];

  modules = {
    git = {
      enable = true;
      user = "Martin Gondermann";
      email = "magicmonty@pagansoft.de";
    };

    neovim.enable = true;
    zathura.enable = true;
    kitty.enable = true;

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

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "$HOME/bin"
    ];
  };
}
