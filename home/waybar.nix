{ config, pkgs, ... }:

{
  programs.waybar = {
    enable  = true;
    package = pkgs.waybar;

    settings = [{
      layer          = "top";
      position       = "top";
      height         = 44;
      margin-top     = 8;
      margin-left    = 12;
      margin-right   = 12;
      spacing        = 6;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "cpu"
        "memory"
        "battery"
        "pulseaudio"
        "network"
      ];

      "hyprland/workspaces" = {
        format         = "{id}";
        on-click       = "activate";
        sort-by-number = true;
        active-only    = false;
      };

      "clock" = {
        format         = "{:%H:%M}";
        format-alt     = "{:%H:%M  %a %d %b}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        calendar = {
          mode      = "month";
          on-scroll = 1;
          format = {
            months   = "<span color='#e0e4ff'><b>{}</b></span>";
            days     = "<span color='#c0caf5'>{}</span>";
            weeks    = "<span color='#565f89'><b>W{}</b></span>";
            weekdays = "<span color='#c4a7e7'><b>{}</b></span>";
            today    = "<span color='#c4a7e7'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up   = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      "cpu" = {
        format   = "󰻠 {usage}%";
        interval = 3;
        tooltip  = false;
      };

      "memory" = {
        format   = "󰍛 {used:0.1f}G";
        interval = 5;
        tooltip  = false;
      };

      "battery" = {
        format          = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged  = "󰚥 {capacity}%";
        format-icons    = [ "󰁺" "󰁼" "󰁾" "󰁹" "󰁹" ];
        states = {
          warning  = 30;
          critical = 15;
        };
        tooltip = false;
      };

      "pulseaudio" = {
        format       = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
        tooltip  = false;
      };

      "network" = {
        format-wifi         = "󰤨 {signalStrength}%";
        format-ethernet     = "󰈀";
        format-disconnected = "󰤭";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip             = true;
      };
    }];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono Nerd Font", "Outfit", monospace;
        font-size: 12px;
        min-height: 0;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background: transparent;
        color: #c0caf5;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(26, 27, 38, 0.88);
        border: 1px solid rgba(196, 167, 231, 0.25);
        border-radius: 14px;
        padding: 0 6px;
      }

      #workspaces {
        padding: 0 2px;
      }

      #workspaces button {
        background: transparent;
        color: #565f89;
        border-radius: 8px;
        padding: 0 6px;
        min-width: 28px;
        min-height: 28px;
        font-size: 11px;
        font-weight: 500;
        transition: all 0.2s ease;
        border: none;
        box-shadow: none;
      }

      #workspaces button:hover {
        background: rgba(196, 167, 231, 0.10);
        color: #c0caf5;
      }

      #workspaces button.active {
        background: #c4a7e7;
        color: #1a1b26;
        font-weight: 700;
        box-shadow: 0 0 10px rgba(196, 167, 231, 0.45);
      }

      #workspaces button.occupied {
        color: rgba(192, 202, 245, 0.7);
      }

      #workspaces button.urgent {
        background: #ed8796;
        color: #1a1b26;
      }

      #clock {
        font-family: "Outfit", sans-serif;
        font-size: 13px;
        font-weight: 500;
        color: #e0e4ff;
        letter-spacing: 1px;
        padding: 0 14px;
        transition: color 0.2s ease;
      }

      #clock:hover {
        color: #c4a7e7;
      }

      #cpu,
      #memory,
      #battery,
      #pulseaudio,
      #network {
        padding: 4px 10px;
        color: #c0caf5;
        transition: background 0.2s ease;
      }

      #cpu:hover,
      #memory:hover,
      #battery:hover,
      #pulseaudio:hover,
      #network:hover {
        background: rgba(196, 167, 231, 0.10);
        border-radius: 8px;
      }

      #cpu    { color: #8aadf4; }
      #memory { color: #c4a7e7; }

      #battery          { color: #a6da95; }
      #battery.warning  { color: #e0af68; }
      #battery.critical {
        color: #ed8796;
        animation: blink 1s step-end infinite;
      }

      @keyframes blink {
        50% { opacity: 0.5; }
      }

      #pulseaudio         { color: #8bd5ca; }
      #pulseaudio.muted   { color: #565f89; }

      #network              { color: #f0c6c6; }
      #network.disconnected { color: #565f89; }

      tooltip {
        background: rgba(26, 27, 38, 0.96);
        border: 1px solid rgba(196, 167, 231, 0.25);
        border-radius: 14px;
        color: #c0caf5;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        padding: 8px;
      }

      tooltip label {
        color: #c0caf5;
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 12px;
      }

      calendar {
        background: transparent;
        color: #c0caf5;
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 12px;
        border-radius: 8px;
        padding: 4px;
      }

      calendar:selected {
        background: #c4a7e7;
        color: #1a1b26;
        border-radius: 6px;
      }

      calendar.highlight {
        color: #c4a7e7;
        font-weight: bold;
      }

      calendar header {
        color: #e0e4ff;
        font-size: 13px;
        padding: 4px 0 8px;
      }

      calendar.button {
        background: transparent;
        color: #565f89;
        padding: 2px 6px;
      }

      calendar.button:hover {
        background: rgba(196, 167, 231, 0.10);
        color: #c4a7e7;
      }
    '';
  };
}
