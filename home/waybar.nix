{ config, pkgs, ... }:

{
  programs.waybar = {
    enable  = true;
    package = pkgs.waybar;

    settings = [{
      layer        = "top";
      position     = "top";
      height       = 40;
      margin-top   = 8;
      margin-left  = 12;
      margin-right = 12;
      spacing      = 4;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "cpu"
        "memory"
        "battery"
        "network"
        "pulseaudio"
        "custom/ip"
      ];

      "hyprland/workspaces" = {
        format         = "{id}";
        on-click       = "activate";
        sort-by-number = true;
        active-only    = false;
      };

      "clock" = {
        format         = "{:%H:%M  %A  %d/%m/%y}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        calendar = {
          mode      = "month";
          on-scroll = 1;
          format = {
            months   = "<span color='#c0caf5'><b>{}</b></span>";
            days     = "<span color='#a9b1d6'>{}</span>";
            weeks    = "<span color='#565f89'><b>W{}</b></span>";
            weekdays = "<span color='#7dcfff'><b>{}</b></span>";
            today    = "<span color='#7dcfff'><b><u>{}</u></b></span>";
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
        format-icons    = [ "󰁺" "󰁼" "󰁾" "󰁿" "󰁹" ];
        states = {
          warning  = 30;
          critical = 15;
        };
        tooltip = false;
      };

      "network" = {
        format-wifi         = "󰤨 {signalStrength}%";
        format-ethernet     = "󰈀 eth";
        format-disconnected = "󰤭 off";
        tooltip-format-wifi = "{essid} — {signalStrength}%\n{ipaddr}";
        tooltip             = true;
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

      "custom/ip" = {
        exec     = "hostname -I | awk '{print $1}'";
        interval = 30;
        format   = "󰩟 {}";
        tooltip  = false;
      };
    }];

    style = ''
      /* ══════════════════════════════════════════════
         Waybar — Tokyo Night / Cyberspace
         Inspirado en la estética terminal cyberpunk
         ══════════════════════════════════════════════ */

      * {
        border:        none;
        border-radius: 0;
        font-family:   "JetBrains Mono Nerd Font", monospace;
        font-size:     12px;
        min-height:    0;
        margin:        0;
        padding:       0;
      }

      window#waybar {
        background: transparent;
        color:      #c0caf5;
      }

      /* ── Píldoras ── */
      .modules-left,
      .modules-center,
      .modules-right {
        background:    rgba(13, 14, 23, 0.92);
        border:        1px solid rgba(125, 207, 255, 0.15);
        border-radius: 10px;
        padding:       0 8px;
      }

      /* ── Workspaces ── */
      #workspaces {
        padding: 0 2px;
      }

      #workspaces button {
        background:    transparent;
        color:         #565f89;
        border-radius: 6px;
        padding:       2px 7px;
        min-width:     24px;
        font-size:     11px;
        font-weight:   500;
        transition:    all 0.15s ease;
        border:        none;
        box-shadow:    none;
        margin:        4px 1px;
      }

      #workspaces button:hover {
        background: rgba(125, 207, 255, 0.08);
        color:      #a9b1d6;
      }

      #workspaces button.active {
        background:  rgba(125, 207, 255, 0.15);
        color:       #7dcfff;
        font-weight: 700;
        border:      1px solid rgba(125, 207, 255, 0.35);
        box-shadow:  0 0 8px rgba(125, 207, 255, 0.2);
      }

      #workspaces button.occupied {
        color: #a9b1d6;
      }

      #workspaces button.urgent {
        background: rgba(247, 118, 142, 0.2);
        color:      #f7768e;
        border:     1px solid rgba(247, 118, 142, 0.4);
      }

      /* ── Reloj ── */
      #clock {
        font-size:      12px;
        font-weight:    500;
        color:          #c0caf5;
        letter-spacing: 0.5px;
        padding:        0 14px;
      }

      #clock:hover {
        color: #7dcfff;
      }

      /* ── Módulos tray ── */
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #custom-ip {
        padding:    3px 9px;
        transition: all 0.15s ease;
      }

      #cpu:hover,
      #memory:hover,
      #battery:hover,
      #network:hover,
      #pulseaudio:hover,
      #custom-ip:hover {
        background:    rgba(125, 207, 255, 0.08);
        border-radius: 6px;
        color:         #7dcfff;
      }

      #cpu         { color: #7aa2f7; }
      #memory      { color: #bb9af7; }
      #battery     { color: #9ece6a; }
      #network     { color: #7dcfff; }
      #pulseaudio  { color: #73daca; }
      #custom-ip   { color: #e0af68; }

      #battery.warning  { color: #e0af68; }
      #battery.critical {
        color:     #f7768e;
        animation: blink 1s step-end infinite;
      }

      #pulseaudio.muted   { color: #565f89; }
      #network.disconnected { color: #565f89; }

      @keyframes blink {
        50% { opacity: 0.4; }
      }

      /* ── Tooltip / Calendario ── */
      tooltip {
        background:    rgba(13, 14, 23, 0.98);
        border:        1px solid rgba(125, 207, 255, 0.20);
        border-radius: 10px;
        color:         #c0caf5;
        box-shadow:    0 4px 20px rgba(0, 0, 0, 0.5);
        padding:       10px;
      }

      tooltip label {
        color:       #c0caf5;
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size:   12px;
      }

      calendar {
        background:  transparent;
        color:       #a9b1d6;
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size:   12px;
        padding:     4px;
      }

      calendar:selected {
        background:    rgba(125, 207, 255, 0.20);
        color:         #7dcfff;
        border-radius: 4px;
      }

      calendar.highlight {
        color:       #7dcfff;
        font-weight: bold;
      }

      calendar header {
        color:       #c0caf5;
        font-weight: 600;
        font-size:   13px;
        padding:     4px 0 8px;
      }

      calendar.button {
        background: transparent;
        color:      #565f89;
        padding:    2px 6px;
      }

      calendar.button:hover {
        background: rgba(125, 207, 255, 0.08);
        color:      #7dcfff;
      }
    '';
  };
}
