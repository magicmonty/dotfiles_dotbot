{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.neovim = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.neovim.enable {
    home.packages = with pkgs; [
      stylua
      nodejs
      ruby
      python3
      tree-sitter
      vimPlugins.nvim-treesitter
      cargo
      gcc
    ];

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    home.sessionVariables = {
      FZF_DEFAULT_COMMAND = "rg --files | sort -u";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.file.".config/nvim" = {
      source = ./neovim;
      recursive = true;
    };

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
