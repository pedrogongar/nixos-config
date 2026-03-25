---
name: waybar-hyprland
description: >
  Configuración de Waybar para Hyprland: módulos, CSS theming, integración IPC,
  patrones comunes. Trigger: Cuando se edite waybar.nix, se configure la barra
  de estado, se añadan módulos, o se estilice Waybar con la paleta serpiente.
metadata:
  author: occulta
  version: "1.0"
---

# Waybar para Hyprland — Referencia

Documentación oficial: https://github.com/Alexays/Waybar/wiki

## Estructura en NixOS Home Manager

```nix
programs.waybar = {
  enable = true;
  settings = [{
    layer = "top";
    position = "top";
    height = 32;
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "clock" ];
    modules-right = [ "pulseaudio" "battery" "tray" ];

    # Configuración de cada módulo
    "hyprland/workspaces" = { ... };
    clock = { ... };
  }];
  style = ''
    /* CSS aquí */
  '';
};
```

## Módulos útiles para Hyprland

### hyprland/workspaces

```nix
"hyprland/workspaces" = {
  format = "{icon}";
  format-icons = {
    "1" = ""; "2" = ""; "3" = "";
    active = ""; default = "";
  };
  on-click = "activate";
  sort-by-number = true;
};
```

### clock

```nix
clock = {
  format = "{:%H:%M}";
  format-alt = "{:%A %d de %B, %Y — %H:%M:%S}";
  tooltip-format = "<tt>{calendar}</tt>";
  calendar = {
    format = { today = "<b><u>{}</u></b>"; };
  };
};
```

### pulseaudio

```nix
pulseaudio = {
  format = "{icon} {volume}%";
  format-muted = "󰝟 mudo";
  format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
  on-click = "pavucontrol";
  on-click-right = "pamixer -t";
};
```

### battery

```nix
battery = {
  interval = 30;
  states = { warning = 30; critical = 15; };
  format = "{icon} {capacity}%";
  format-charging = "󰂄 {capacity}%";
  format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
  tooltip-format = "{timeTo}\n{power}W";
};
```

### network (WiFi)

```nix
network = {
  interface = "wlan0";
  format-wifi = "󰤨 {signalStrength}%";
  format-disconnected = "󰤭";
  tooltip-format-wifi = "{essid}\n{ipaddr}/{cidr}\n{signaldBm}dBm";
  on-click = "kitty -e nmtui";
};
```

### bluetooth

```nix
bluetooth = {
  format = "󰂯";
  format-connected = "󰂱 {device_alias}";
  format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
  tooltip-format-connected = "{device_enumerate}";
  on-click = "blueman-manager";
};
```

### custom modules

```nix
"custom/nixos" = {
  format = "󱄅";
  on-click = "wlogout --buttons-per-row 2";
  tooltip = false;
};

"custom/mic" = {
  exec = "pamixer --default-source --get-volume";
  format = "󰍬 {}%";
  interval = 5;
  on-click = "pamixer --default-source -t";
};
```

### tray

```nix
tray = {
  icon-size = 16;
  spacing = 8;
};
```

## CSS — Estructura base con theme serpiente

```nix
let c = import ./colores.nix; in
''
  * {
    font-family: "JetBrainsMono Nerd Font", sans-serif;
    font-size: 13px;
    min-height: 0;
  }

  window#waybar {
    background-color: ${c.crust};
    color: ${c.text};
    border-bottom: 2px solid ${c.surface0};
  }

  /* Módulos base */
  #workspaces button {
    padding: 0 8px;
    color: ${c.subtext};
    background: transparent;
    border: none;
    border-radius: 0;
    border-bottom: 2px solid transparent;
  }

  #workspaces button.active {
    color: ${c.oro};
    border-bottom: 2px solid ${c.oro};
  }

  #workspaces button:hover {
    background-color: ${c.surface0};
  }

  #clock {
    color: ${c.text};
    font-weight: bold;
  }

  #pulseaudio {
    color: ${c.oliva};
  }

  #pulseaudio.muted {
    color: ${c.rojo};
  }

  #battery {
    color: ${c.oliva};
  }

  #battery.warning {
    color: ${c.ambar};
  }

  #battery.critical {
    color: ${c.rojo};
  }

  #network {
    color: ${c.oliva};
  }

  #network.disconnected {
    color: ${c.rojo};
  }

  #bluetooth {
    color: ${c.cobre};
  }

  #custom-nixos {
    color: ${c.oro};
    font-size: 16px;
    padding: 0 12px;
  }

  /* Tooltips */
  tooltip {
    background-color: ${c.mantle};
    border: 1px solid ${c.surface1};
    border-radius: 8px;
    color: ${c.text};
  }
''
```

## Patrones de layout

### Separación con espaciado CSS (sin separadores visibles)

```css
#módulo {
  padding: 0 10px;
  margin: 4px 2px;
}
```

### Separación con pill/píldora

```css
#módulo {
  padding: 0 10px;
  margin: 4px 2px;
  background-color: ${c.base};
  border-radius: 16px;
}
```

### Grupos de módulos

```css
.modules-left, .modules-right {
  margin: 4px;
}
```

## Recargar Waybar

```bash
pkill waybar; waybar &
```

O desde Hyprland bind:

```nix
"$mod SHIFT, R, exec, pkill waybar; waybar &"
```

## Debug

```bash
# Lanzar con output de errores
waybar -l debug 2>&1 | head -50

# Verificar qué módulos carga
waybar -l info 2>&1 | grep "module"
```
