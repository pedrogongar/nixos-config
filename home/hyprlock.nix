{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };

      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 4;
        blur_size = 8;
        brightness = 0.6;
      }];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(192, 202, 245, 1.0)";
          font_size = 72;
          font_family = "Outfit Light";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] date '+%A %d de %B'";
          color = "rgba(86, 95, 137, 1.0)";
          font_size = 14;
          font_family = "Outfit";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [{
        monitor = "";
        size = "280, 48";
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.3;
        dots_center = true;
        outer_color = "rgba(196, 167, 231, 0.3)";
        inner_color = "rgba(26, 27, 38, 0.75)";
        font_color = "rgba(192, 202, 245, 1.0)";
        fade_on_empty = true;
        placeholder_text = "";
        hide_input = false;
        rounding = 14;
        check_color = "rgba(166, 218, 149, 0.5)";
        fail_color = "rgba(237, 135, 150, 0.5)";
        fail_text = "";
        position = "0, -30";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
