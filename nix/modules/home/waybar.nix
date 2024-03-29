{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.waybar = {
    enable = mkOption { type = types.bool; default = false; };
    batterySymbol = mkOption { type = types.bool; default = true; };
    backlight = mkOption { type = types.bool; default = true; };
  };

  config = (mkIf config.modules.waybar.enable {
    home = {
      file.".config/waybar" = {
        source = ./hyprland/waybar;
        recursive = true;
      };

      file.".config/waybar/config.jsonc" =
      let waybar-config = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 0;

        modules-left = [
          "custom/weather"
          "wlr/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "tray"
          (optionalString config.modules.waybar.batterySymbol "battery")
          "custom/updates"
          (optionalString config.modules.waybar.backlight "backlight")
          "pulseaudio"
          "pulseaudio#microphone"
          "clock"
        ];

        "hyprland/window" = {
          format = "{}";
        };

        "wlr/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          on-click = "activate";
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
        };

        cpu = {
          interval = 10;
          format = "";
          max-length = 10;
          format-alt-click = "click-right";
          format-alt = " {usage}%";
          on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
        };

        memory = {
          interval = 30;
          format = "";
          format-alt-click = "click-right";
          format-alt = " {}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "Memory - {used:0.1f}GB used";
          on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
        };

        disk = {
          interval = 30;
          format = "󰋊";
          path = "/";
          format-alt-click = "click-right";
          format-alt = "󰋊 {percentage_used}%";
          tooltip = true;
          tooltip-format = "HDD - {used} used out of {total} on {path} ({percentage_used}%)";
          on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };

          format = "{icon}";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt-click = "click-right";
          format-alt = "{icon} {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };

        "custom/updates" = {
          exec = "(checkupdates ; yay -Qua) | wc -l";
          interval = 7200;
          format = "󰏔 {}";
        };

        "custom/weather" = {
          tooltip = true;
          format = "{}";
          interval = 30;
          exec = "~/.config/waybar/scripts/waybar-wttr.py";
          return-type = "json";
        };

        clock = {
          format = "{: %R   %d/%m}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          tooltip = false;
          format-muted = " Muted";
          on-click = "~/.config/waybar/scripts/volume --toggle";
          on-click-right = "pavucontrol";
          on-scroll-up = "~/.config/waybar/scripts/volume --inc";
          on-scroll-down = "~/.config/waybar/scripts/volume --dec";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "~/.config/waybar/scripts/volume --toggle-mic";
          on-click-right = "pavucontrol";
          on-scroll-up = "~/.config/waybar/scripts/volume --mic-inc";
          on-scroll-down = "~/.config/waybar/scripts/volume --mic-dec";
          scroll-step = 5;
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "~/.config/waybar/scripts/brightness --inc";
          on-scroll-down = "~/.config/waybar/scripts/brightness --dec";
        };
      };
      in
      {
        text = builtins.toJSON waybar-config;
      };
    };
  });
}
