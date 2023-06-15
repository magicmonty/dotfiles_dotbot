{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.neovim = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkMerge [
    (mkIf config.modules.neovim.enable {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      home = {
        packages = with pkgs; [
          stylua
          unzip
          fd
          ripgrep
        ];

        sessionVariables = {
          FZF_DEFAULT_COMMAND = "rg --files | sort -u";
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        file.".config/nvim" = {
          source = ./neovim;
          recursive = true;
        };

        file.".config/nvim/init.lua" = {
          text = ''
            require('magicmonty')
          '';
        };
      };

    })

    (mkIf config.modules.zsh.enable {
      programs.zsh.sessionVariables = {
        NVIM_LISTEN_ADDRESS = "~/.cache/nvim/server.pipe";
      };
    })
  ];
}
