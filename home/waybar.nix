{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  volumenScript = pkgs.writeShellScriptBin "waybar-volumen" ''
    obtener_volumen() {
      vol=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
      if echo "$vol" | grep -q "MUTED"; then
        echo "󰝟 mute"
      else
        pct=$(echo "$vol" | ${pkgs.gawk}/bin/awk '{printf "%.0f", $2 * 100}')
        echo "󰕾 $pct%"
      fi
    }

    while true; do
      obtener_volumen
      sleep 0.3
    done
  '';

  redScript = pkgs.writeShellScriptBin "waybar-red" ''
    wifi_estado=$(${pkgs.networkmanager}/bin/nmcli -t -f TYPE,STATE device 2>/dev/null | grep "^wifi:" | cut -d: -f2)
    eth_estado=$(${pkgs.networkmanager}/bin/nmcli -t -f TYPE,STATE device 2>/dev/null | grep "^ethernet:" | cut -d: -f2)

    if [ "$wifi_estado" = "connected" ]; then
      red="󰤨"
    elif [ "$eth_estado" = "connected" ]; then
      red="󰈁"
    else
      red="󰤭"
    fi

    bt="󰂲"
    if command -v bluetoothctl >/dev/null 2>&1; then
      bt_power=$(bluetoothctl show 2>/dev/null | grep "Powered:" | ${pkgs.gawk}/bin/awk '{print $2}')
      if [ "$bt_power" = "yes" ]; then
        bt="󰂯"
        dispositivos=$(echo -e 'devices\nquit' | bluetoothctl 2>/dev/null | grep "^Device" | ${pkgs.gawk}/bin/awk '{print $2}')
        for mac in $dispositivos; do
          if echo -e "info $mac\nquit" | bluetoothctl 2>/dev/null | grep -q "Connected: yes"; then
            bt="󰂱"
            break
          fi
        done
      fi
    fi

    echo "$red $bt"
  '';

  microfonoScript = pkgs.writeShellScriptBin "waybar-microfono" ''
    obtener_micro() {
      vol=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
      if echo "$vol" | grep -q "MUTED"; then
        echo "󰍭"
      else
        echo "󰍬"
      fi
    }

    while true; do
      obtener_micro
      sleep 0.5
    done
  '';

  # ── Colores (se definen una vez, se reutilizan en defaults + CSS inicial) ──
  waybarColors = ''
    @define-color wb_base ${c.base};
    @define-color wb_oro ${c.oro};
    @define-color wb_ambar ${c.ambar};
    @define-color wb_text ${c.text};
    @define-color wb_oliva ${c.oliva};
    @define-color wb_rojo ${c.rojo};
  '';

  # ── Estructura CSS (sin colores hardcodeados, usa @wb_* ) ────────────
  waybarBase = ''
    * {
      font-family: "JetBrains Mono Nerd Font", monospace;
      font-size: 11px;
      font-weight: bold;
      min-height: 0;
      border: none;
      background: transparent;
      margin: 0;
      padding: 0;
    }

    window#waybar {
      background: @wb_base;
      color: @wb_oro;
    }

    tooltip {
      color: @wb_text;
      background: alpha(@wb_base, 0.8);
      border-radius: 12px;
    }

    #custom-nixos,
    #clock,
    #workspaces,
    #window,
    #battery,
    #custom-volumen,
    #custom-microfono,
    #custom-red,
    #custom-wallpaper {
      background: transparent;
      padding: 3px 12px;
      margin: 0;
      color: @wb_ambar;
    }

    #custom-nixos {
      font-size: 20px;
      color: @wb_oro;
    }

    #window {
      color: alpha(@wb_text, 0.7);
      font-weight: 600;
    }

    #workspaces {
      padding: 3px 6px;
    }

    #workspaces button {
      background: transparent;
      color: alpha(@wb_text, 0.7);
      padding: 2px 6px;
      margin: 0 1px;
      border-radius: 8px;
      transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    #workspaces button.active {
      background: alpha(@wb_oro, 0.75);
      color: @wb_base;
      padding: 2px 16px;
      border-radius: 16px;
    }

    #workspaces button.visible {
      color: alpha(@wb_text, 0.7);
      transition: all 0.3s ease;
    }

    #workspaces button:hover {
      background: alpha(@wb_oro, 0.4);
      color: @wb_text;
    }

    #battery.charging {
      color: @wb_oliva;
    }

    #battery.warning:not(.charging) {
      color: @wb_ambar;
    }

    #battery.critical:not(.charging) {
      color: @wb_rojo;
    }
  '';

in
{
  # CSS inicial = colores Serpiente + base (force=true permite sobreescritura por scripts)
  xdg.configFile."waybar/style.css" = {
    text = waybarColors + waybarBase;
    force = true;
  };
  xdg.configFile."waybar/style-base.css".text = waybarBase;

  programs.waybar = {
    enable = true;
    settings = [{
      layer    = "top";
      position = "top";
      height   = 28;
      margin-top    = 0;
      margin-left   = 0;
      margin-right  = 0;
      spacing  = 6;

      modules-left   = [ "custom/nixos" "clock" "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right  = [
        "custom/wallpaper"
        "battery"
        "custom/volumen"
        "custom/microfono"
        "custom/red"
      ];

      "custom/nixos" = {
        format         = "󱄅";
        on-click       = "rofi -show drun";
        on-click-right = "wlogout --buttons-per-row 2";
        tooltip        = false;
      };

      clock = {
        format         = "󰥔 {:%I:%M %p}";
        format-alt     = "󰃭 {:%A %d de %B}";
        tooltip-format = "<tt>{calendar}</tt>";
        interval       = 60;
      };

      "hyprland/workspaces" = {
        format         = "{name}";
        on-click       = "activate";
        sort-by-number = true;
        all-outputs    = true;
      };

      "hyprland/window" = {
        format     = "{title}";
        max-length = 50;
        rewrite = {
          "(.*) — Mozilla Firefox" = "Firefox — $1";
          "(.*) - kitty"           = "kitty — $1";
        };
      };

      battery = {
        format           = "󰁹 {capacity}%";
        format-charging  = "󰂄 {capacity}%";
        format-plugged   = "󰚥 {capacity}%";
        format-full      = "󰁹 {capacity}%";
        format-icons     = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        states = {
          warning  = 30;
          critical = 15;
        };
        tooltip  = false;
        interval = 30;
      };

      "custom/volumen" = {
        exec           = "${volumenScript}/bin/waybar-volumen";
        on-click       = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-up   = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
        on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
        tooltip        = false;
      };

      "custom/microfono" = {
        exec     = "${microfonoScript}/bin/waybar-microfono";
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        tooltip  = false;
      };

      "custom/wallpaper" = {
        format   = "󰋩";
        on-click = "wallpaper-selector";
        tooltip  = false;
      };

      "custom/red" = {
        exec     = "${redScript}/bin/waybar-red";
        interval = 5;
        on-click = "nm-connection-editor";
        tooltip  = false;
      };
    }];

    # CSS gestionado via xdg.configFile (colores dinámicos + base)
  };
}
