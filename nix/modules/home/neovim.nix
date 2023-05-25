{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.neovim = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkMerge [
    (mkIf config.modules.neovim.enable {
      home.packages = with pkgs; [
        stylua
        tree-sitter
        unzip
        fd
        ripgrep
        python310
        python310Packages.pip
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

        extraPackages = with pkgs; [
          cargo
          gcc
          nodejs
          ruby
          python310
        ];

        extraLuaConfig = ''
          require("magicmonty")

          local status, ts_install = pcall(require, "nvim-treesitter.install")
          if status then
            ts_install.compilers = { "${pkgs.gcc}/bin/gcc" }
          end
        '';
      };
    })

    (mkIf config.modules.zsh.enable {
      programs.zsh.sessionVariables = {
        NVIM_LISTEN_ADDRESS = "~/.cache/nvim/server.pipe";
      };
    })
  ];
}
