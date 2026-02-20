{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer    = "top";
      position = "top";
      height   = 36;
      spacing  = 0;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "cpu"
        "memory"
        "disk"
        "network"
        "pulseaudio"
        "custom/power"
      ];

      "hyprland/workspaces" = {
        format         = "{id}";
        on-click       = "activate";
        sort-by-number = true;
        all-outputs    = true;
      };

      clock = {
        format         = "󰅐 {:%H:%M}";
        format-alt     = "󰃭 {:%A %d de %B}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      cpu = {
        format   = "󰻠 {usage}%";
        interval = 5;
      };

      memory = {
        format   = "󰍛 {percentage}%";
        interval = 5;
      };

      disk = {
        format   = "󰋊 {percentage_used}%";
        path     = "/";
        interval = 30;
      };

      network = {
        format-wifi         = "󰤨 {signalStrength}%";
        format-ethernet     = "󰈁 {ipaddr}";
        format-disconnected = "󰤭 ";
        tooltip-format      = "{ifname}: {ipaddr}/{cidr}";
        interval            = 10;
      };

      pulseaudio = {
        format       = "{icon} {volume}%";
        format-muted = "󰝟 ";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
      };

      "custom/power" = {
        format   = "⏻";
        on-click = "wlogout --buttons-per-row 2";
        tooltip  = false;
      };
    }];

    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(22, 22, 30, 0.88);
        border-bottom: 1px solid rgba(196, 167, 231, 0.15);
        color: ${c.text};
      }

      tooltip {
        background: ${c.mantle};
        border: 1px solid rgba(196, 167, 231, 0.2);
        border-radius: 8px;
        color: ${c.text};
      }

      #workspaces button {
        padding: 0 10px;
        margin: 4px 2px;
        border-radius: 6px;
        color: ${c.surface2};
        background: transparent;
        border: none;
        font-size: 13px;
        font-weight: 600;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: ${c.crust};
        background: ${c.malva};
      }

      #workspaces button:hover {
        color: ${c.text};
        background: rgba(196, 167, 231, 0.15);
      }

      #clock {
        color: ${c.text};
        font-weight: 600;
      }

      #cpu {
        color: ${c.teal};
      }

      #memory {
        color: ${c.malva};
      }

      #disk {
        color: ${c.peach};
      }

      #network {
        color: ${c.cyan};
      }

      #network.disconnected {
        color: ${c.red};
      }

      #pulseaudio {
        color: ${c.blue};
      }

      #pulseaudio.muted {
        color: ${c.surface2};
      }

      #custom-power {
        color: ${c.red};
        padding: 0 12px 0 8px;
        margin: 4px 0;
        font-size: 14px;
      }

      #custom-power:hover {
        color: ${c.fuchsia};
      }

      #cpu,
      #memory,
      #disk,
      #network,
      #pulseaudio,
      #clock {
        padding: 0 10px;
        margin: 4px 0;
      }
    '';
  };
}
