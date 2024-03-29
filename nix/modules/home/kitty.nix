{ config, lib, pkgs, ... }:

with lib;

let
  toKittyConfig = generators.toKeyValue {
    mkKeyValue = key: value:
      let
        value' =
          (if isBool value then lib.hm.booleans.yesNo else toString) value;
      in
      "${key} ${value'}";
  };

  toKittyKeyBindings = generators.toKeyValue {
    mkKeyValue = key: command: "map ${key} ${command}";
  };

  keybindings = {
    "shift+insert" = "paste_from_clipboard";
  };

  font = {
    name = "JetBrainsMono NF";
    size = 14;
  };

  settings = {
    adjust_line_height = "100%";
    background_opacity = 0.8;
    copy_on_select = true;
    cursor_blink_interval = 0;
    window_padding_width = 10;
    hide_window_decorations = true;
    remember_window_size = false;
    initial_window_width = 1000;
    initial_window_height = 650;
    enable_audio_bell = false;
  };

  theme = {
    name = "nightfox";
    colors = {
      # Theme (NightFox)
      #
      background = "#192330";
      foreground = "#cdcecf";
      selection_background = "#283648";
      selection_foreground = "#cdcecf";
      url_color = "#81b29a";
      cursor = "#cdcecf";
      # Tabs
      active_tab_background = "#719cd6";
      active_tab_foreground = "#131A24";
      inactive_tab_background = "#283648";
      inactive_tab_foreground = "#526175";
      # normal
      color0 = "#393b44";
      color1 = "#c94f6d";
      color2 = "#81b29a";
      color3 = "#dbc074";
      color4 = "#719cd6";
      color5 = "#9d79d6";
      color6 = "#63cdcf";
      color7 = "#f2f2f2";
      # bright
      color8 = "#475072";
      color9 = "#d6616b";
      color10 = "#58cd8b";
      color11 = "#ffe37e";
      color12 = "#84cee4";
      color13 = "#b8a1e3";
      color14 = "#59f0ff";
      color15 = "#f2f2f2";
      # extended colors
      color16 = "#f4a261";
      color17 = "#d67ad2";
    };
  };
in
{
  options.modules.kitty = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.kitty.enable {
    xdg.configFile."kitty/kitty.conf" = {
      text = ''
        # Generated by Home Manager
        # see https://sw.kovidgoyal.net/kitty/conf.html

        include ${theme.name}.conf

        font_family ${font.name}
        bold_font ${font.name}
        italic_font ${font.name}
        bold_italic_font ${font.name}
        font_size ${toString font.size}

      '' + concatStringsSep "\n" ([
        (toKittyConfig settings)
        (toKittyKeyBindings keybindings)
      ]);
    } // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      onChange = ''
        ${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true
      '';
    };

    xdg.configFile."kitty/${theme.name}.conf" = {
      text = ''
        # Generated by Home Manager
        # see https://sw.kovidgoyal.net/kitty/conf.html

        # Theme ${theme.name}

      '' + concatStringsSep "\n" ([
        (toKittyConfig theme.colors)
      ]);
    } // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      onChange = ''
        ${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true
      '';
    };


  };
}
