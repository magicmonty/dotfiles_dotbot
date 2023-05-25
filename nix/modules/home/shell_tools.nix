{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ranger
    gum
    ripgrep
    ncdu
    pbgopy
    clipboard-jh
    dcfldd
  ];

  home.file.".config/ncdu/config".source = ./zsh/ncdu.config;

  programs = {
    zoxide = {
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
  };
}
