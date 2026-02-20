{ config, pkgs, ... }:

let
  monitorScript = pkgs.writeShellScriptBin "monitor-switch" ''
    OPTIONS="  Solo portátil\n  Externos (portátil cerrado)\n  Todo activo"

    CHOICE=$(echo -e "$OPTIONS" | ${pkgs.rofi}/bin/rofi -dmenu -p "Monitor" -theme-str '
      window { width: 300px; }
      listview { lines: 3; }
    ')

    case "$CHOICE" in
      *"Solo portátil"*)
        hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
        hyprctl keyword monitor "HDMI-A-1, disable"
        hyprctl keyword monitor "DP-1, disable"
        ;;
      *"Externos"*)
        hyprctl keyword monitor "eDP-1, disable"
        hyprctl keyword monitor "HDMI-A-1, 1920x1080@60, 0x0, 1"
        hyprctl keyword monitor "DP-1, 1920x1080@60, 1920x0, 1"
        ;;
      *"Todo activo"*)
        hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
        hyprctl keyword monitor "HDMI-A-1, 1920x1080@60, 1920x0, 1"
        hyprctl keyword monitor "DP-1, 1920x1080@60, 3840x0, 1"
        ;;
    esac
  '';

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod"         = "SUPER";
      "$terminal"    = "kitty";
      "$menu"        = "rofi -show drun";
      "$browser"     = "firefox";
      "$fileManager" = "thunar";

      monitor = [
        "eDP-1, 1920x1080@60, 0x0, 1"
        "HDMI-A-1, 1920x1080@60, 0x0, 1"
        "DP-1, 1920x1080@60, 1920x0, 1"
        ", preferred, auto, 1"
      ];

      general = {
        gaps_in  = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border"   = "rgba(c4a7e7ff) rgba(8aadf4ff) 45deg";
        "col.inactive_border" = "rgba(6e738daa)";
        layout = "dwindle";
      };

      decoration = {
        rounding         = 12;
        active_opacity   = 0.95;
        inactive_opacity = 0.85;
        blur = {
          enabled           = true;
          size              = 8;
          passes            = 3;
          new_optimizations = true;
          ignore_opacity    = true;
          xray              = false;
        };
        shadow = {
          enabled      = true;
          range        = 20;
          render_power = 3;
          color        = "rgba(1a1a2eee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.4, 0.8, 0.2, 1.2"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, smoothIn, slide"
          "border, 1, 10, default"
          "fade, 1, 5, smoothIn"
          "fadeDim, 1, 5, smoothIn"
          "workspaces, 1, 6, overshot, slidevert"
        ];
      };

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
        smart_split    = true;
      };

      input = {
        kb_layout    = "es";
        follow_mouse = 1;
        sensitivity  = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      misc = {
        disable_hyprland_logo    = true;
        disable_splash_rendering = true;
        animate_manual_resizes   = true;
      };

      windowrulev2 = [
        "float,    class:^(cmatrix-desktop)$"
        "nofocus,  class:^(cmatrix-desktop)$"
        "noborder, class:^(cmatrix-desktop)$"
        "noshadow, class:^(cmatrix-desktop)$"
        "pin,      class:^(cmatrix-desktop)$"
        "move 20 66,       class:^(cmatrix-desktop)$"
        "size 340 460,     class:^(cmatrix-desktop)$"
        "opacity 0.55 0.55,class:^(cmatrix-desktop)$"
      ];

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod SHIFT, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, B, exec, $browser"
        "$mod, Space, exec, $menu"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, M, exec, ${monitorScript}/bin/monitor-switch"
        "$mod, N, exec, swaync-client -t -sw"
        "$mod, X, exec, wlogout"

        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        ", Print,      exec, grim -g \"$(slurp)\" - | satty -f -"
        "SHIFT, Print, exec, grim - | satty -f -"

        "$mod, L, exec, hyprlock"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "swww-daemon && sleep 1 && swww img ~/wallpapers/default.jpg"
        "swaync"
        "waybar"
        "eww daemon && eww open escritorio"
        "kitty --class cmatrix-desktop --override font_size=9 -e cmatrix -s -C cyan -u 4"
      ];
    };
  };

  home.packages = with pkgs; [
    swww
    grim
    slurp
    satty
    swaynotificationcenter
    hyprlock
    wlogout
    rofi
    pavucontrol
    cava
    fastfetch
    btop
    cmatrix
    yazi
    matugen
    jq
    socat
  ];
}
