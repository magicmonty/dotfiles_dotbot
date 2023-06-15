{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.hyprland = {
    enable = mkOption { type = types.bool; default = false; };
    entrypoint = mkOption { type = types.path; };
  };

  config = mkMerge [
    (mkIf config.modules.hyprland.enable {
      home = {
        file."bin/hlprop" = {
          source = ./hyprland/bindir/hlprop;
        };

        file.".config/hypr/hyprland.conf" = {
          source = config.modules.hyprland.entrypoint;
        };

        file.".config/mako" = {
          source = ./hyprland/mako;
          recursive = true;
        };

        file.".config/swayidle" = {
          source = ./hyprland/swayidle;
          recursive = true;
        };

        file.".config/swaylock" = {
          source = ./hyprland/swaylock;
          recursive = true;
        };

        file.".config/waybar" = {
          source = ./hyprland/waybar;
          recursive = true;
        };
        
        file.".config/wlogout" = {
          source = ./hyprland/wlogout;
          recursive = true;
        };
      };

    })
  ];
}
