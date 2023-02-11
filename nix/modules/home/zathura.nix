{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.zathura = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.zathura.enable {
    programs = {
      zathura = {
        enable = true;

        options = {
          statusbar-h-padding = 0;
          statusbar-v-padding = 0;
          page-padding = 1;
          synctex = true;
          synctex-editor-command = "nvr --remote-silent +%{line} %{input}";
        };

        mappings = {
          u = "scroll half-up";
          d = "scroll half-down";
          D = "toggle_page_mode";
          r = "reload";
          R = "rotate";
          K = "zoom in";
          J = "zoom out";
          p = "print";
          f = "toggle_fullscreen";
          "[fullscreen] f" = "toggle_fullscreen";
          "[fullscreen] 0" = "adjust_window best-fit";
          "[fullscreen] <S-0>" = "adjust_window width";
          "[fullscreen] K" = "zoom in";
          "[fullscreen] J" = "zoom out";
          "[fullscreen] D" = "toggle_page_mode";
        };
      };
    };
  };
}

