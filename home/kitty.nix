{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family      = "FiraCode Nerd Font";
      bold_font        = "FiraCode Nerd Font Bold";
      italic_font      = "FiraCode Nerd Font Light";
      font_size        = 12;
      adjust_line_height = "110%";
      disable_ligatures  = "never";

      background_opacity = "0.92";

      window_padding_width      = 12;
      confirm_os_window_close   = 0;
      hide_window_decorations   = true;

      cursor_shape          = "beam";
      cursor_beam_thickness = "1.5";
      cursor_blink_interval = "0.5";

      enable_audio_bell    = false;
      visual_bell_duration = 0;

      scrollback_lines = 10000;

      detect_urls = true;
      url_style   = "curly";
      url_color   = c.arena;

      tab_bar_edge         = "top";
      tab_bar_style        = "powerline";
      tab_powerline_style  = "round";
      tab_bar_min_tabs     = 2;
      active_tab_font_style   = "bold";
      inactive_tab_font_style = "normal";
      active_tab_foreground   = c.base;
      active_tab_background   = c.oro;
      inactive_tab_foreground = c.surface2;
      inactive_tab_background = c.mantle;

      repaint_delay    = 10;
      input_delay      = 3;
      sync_to_monitor  = true;

      foreground          = c.text;
      background          = c.base;
      selection_foreground = c.text;
      selection_background = c.surface1;
      cursor              = c.oro;
      cursor_text_color   = c.base;

      color0  = c.mantle;
      color1  = c.rojo;
      color2  = c.oliva;
      color3  = c.oro;
      color4  = c.cobre;
      color5  = c.ambar;
      color6  = c.arena;
      color7  = c.subtext;
      color8  = c.surface2;
      color9  = c.rojo;
      color10 = c.oliva;
      color11 = c.oro;
      color12 = c.cobre;
      color13 = c.ambar;
      color14 = c.arena;
      color15 = c.text;
    };

    extraConfig = ''
      # Colores dinámicos (matugen) — sobreescriben los de arriba
      include ~/.cache/matugen/colors-kitty.conf
    '';

    keybindings = {
      "ctrl+shift+t"       = "new_tab";
      "ctrl+shift+w"       = "close_tab";
      "ctrl+shift+right"   = "next_tab";
      "ctrl+shift+left"    = "previous_tab";
      "ctrl+shift+."       = "move_tab_forward";
      "ctrl+shift+,"       = "move_tab_backward";
      "ctrl+shift+alt+t"   = "set_tab_title";

      "ctrl+shift+enter"   = "new_window";
      "ctrl+shift+]"       = "next_window";
      "ctrl+shift+["       = "previous_window";
      "ctrl+shift+q"       = "close_window";

      "ctrl+shift+h"       = "neighboring_window left";
      "ctrl+shift+l"       = "neighboring_window right";
      "ctrl+shift+k"       = "neighboring_window up";
      "ctrl+shift+j"       = "neighboring_window down";

      "ctrl+shift+space"   = "next_layout";

      "ctrl+shift+equal"   = "change_font_size all +1.0";
      "ctrl+shift+minus"   = "change_font_size all -1.0";
      "ctrl+shift+0"       = "change_font_size all 0";
    };
  };
}
