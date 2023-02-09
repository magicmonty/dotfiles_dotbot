{ config, lib, pkgs, username, ... }:

{
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

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
