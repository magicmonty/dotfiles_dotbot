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
  ];

  modules.git.enable = true;
  modules.zsh.enable = true;
  modules.zsh.yayAliases = true;
  modules.neovim.enable = true;

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
