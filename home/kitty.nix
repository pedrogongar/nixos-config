{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Fuente con ligaduras
      font_family = "FiraCode Nerd Font";
      bold_font = "FiraCode Nerd Font Bold";
      italic_font = "FiraCode Nerd Font Light";
      font_size = 12;
      adjust_line_height = "110%";
      disable_ligatures = "never";

      # Transparencia para blur de Hyprland
      background_opacity = "0.85";
      dynamic_background_opacity = true;

      # Ventana
      window_padding_width = 12;
      confirm_os_window_close = 0;
      hide_window_decorations = true;

      # Cursor
      cursor_shape = "beam";
      cursor_beam_thickness = "1.5";
      cursor_blink_interval = "0.5";

      # Sonido
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # Scrollback
      scrollback_lines = 10000;

      # URLs clicables
      detect_urls = true;
      url_style = "curly";

      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_min_tabs = 1;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";

      # Rendimiento
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
    };

    keybindings = {
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+alt+t" = "set_tab_title";

      # Splits
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+q" = "close_window";

      # Splits direccionales
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+l" = "neighboring_window right";
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+j" = "neighboring_window down";

      # Layout
      "ctrl+shift+space" = "next_layout";

      # Tamaño de fuente
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+0" = "change_font_size all 0";

      # Opacidad al vuelo
      "ctrl+shift+a>m" = "set_background_opacity +0.05";
      "ctrl+shift+a>l" = "set_background_opacity -0.05";
    };
  };
}
