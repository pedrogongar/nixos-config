---
name: ricing-apps
description: >
  Cómo personalizar y estilizar las apps del ecosistema Hyprland: rofi, swaync,
  hyprlock, wlogout, fastfetch, kitty. Formatos de config, CSS, y patrones comunes.
  Trigger: Cuando se personalice la apariencia de rofi, swaync, hyprlock, wlogout,
  fastfetch, kitty, o cualquier app del ecosistema de escritorio.
metadata:
  author: occulta
  version: "1.0"
---

# Ricing de Apps — Ecosistema Hyprland

## Rofi (lanzador de apps)

### Formato: .rasi (CSS-like)

```nix
# En rofi.nix — theme como archivo .rasi
xdg.configFile."rofi/theme.rasi".text = let c = import ./colores.nix; in ''
  * {
    bg:       ${c.base};
    bg-alt:   ${c.mantle};
    fg:       ${c.text};
    accent:   ${c.oro};
    border:   ${c.surface1};
    selected: ${c.surface0};
  }

  window {
    width:            400px;
    background-color: @bg;
    border:           2px solid;
    border-color:     @border;
    border-radius:    12px;
  }

  inputbar {
    background-color: @bg-alt;
    padding:          8px 12px;
    border-radius:    8px;
    children:         [ prompt, entry ];
  }

  prompt {
    text-color: @accent;
  }

  entry {
    text-color:        @fg;
    placeholder:       "Buscar...";
    placeholder-color: ${c.subtext};
  }

  listview {
    lines:    8;
    columns:  1;
    padding:  8px 0;
  }

  element {
    padding:       8px 12px;
    border-radius: 8px;
  }

  element selected {
    background-color: @selected;
    text-color:       @accent;
  }
'';
```

### En Home Manager

```nix
programs.rofi = {
  enable = true;
  theme = "~/.config/rofi/theme.rasi";
  # O theme inline con configFile
};
```

## SwayNC (notificaciones)

### Archivos: config.json + style.css

```nix
# config.json
xdg.configFile."swaync/config.json".text = builtins.toJSON {
  positionX = "right";
  positionY = "top";
  layer = "overlay";
  control-center-width = 400;
  notification-window-width = 400;
  timeout = 5;
  timeout-low = 3;
  timeout-critical = 10;
};

# style.css
xdg.configFile."swaync/style.css".text = let c = import ./colores.nix; in ''
  .notification-row {
    background: ${c.mantle};
    border-radius: 12px;
    margin: 4px 8px;
    border: 1px solid ${c.surface1};
  }
  .notification-content {
    color: ${c.text};
    padding: 8px 12px;
  }
  .summary {
    color: ${c.oro};
    font-weight: bold;
  }
  .body {
    color: ${c.subtext};
  }
  .control-center {
    background: ${c.crust};
    border-left: 2px solid ${c.surface0};
  }
'';
```

## Hyprlock (pantalla de bloqueo)

### Formato: config Hyprland-like

```nix
programs.hyprlock = {
  enable = true;
  settings = {
    background = [{
      path = "~/imagenes/wallpapers/default.jpg";
      blur_passes = 3;
      blur_size = 6;
    }];
    input-field = [{
      size = "250, 50";
      outline_thickness = 2;
      outer_color = "rgba(${strip c.oro}ff)";
      inner_color = "rgba(${strip c.base}ee)";
      font_color = "rgba(${strip c.text}ff)";
      fade_on_empty = true;
      placeholder_text = "Contraseña...";
      fail_text = "Incorrecto";
    }];
    label = [{
      text = "$TIME";
      font_size = 64;
      font_family = "JetBrainsMono Nerd Font";
      color = "rgba(${strip c.oro}ff)";
      position = "0, 100";
      halign = "center";
      valign = "center";
    }];
  };
};
```

## Wlogout (menú de apagado)

### Formato: CSS + layout JSON

```nix
# Layout
programs.wlogout = {
  enable = true;
  layout = [
    { label = "lock"; action = "hyprlock"; text = "Bloquear"; }
    { label = "logout"; action = "hyprctl dispatch exit"; text = "Salir"; }
    { label = "shutdown"; action = "systemctl poweroff"; text = "Apagar"; }
    { label = "reboot"; action = "systemctl reboot"; text = "Reiniciar"; }
  ];
  style = let c = import ./colores.nix; in ''
    window {
      background-color: rgba(0, 0, 0, 0.7);
    }
    button {
      background-color: ${c.base};
      color: ${c.text};
      border: 2px solid ${c.surface1};
      border-radius: 16px;
      margin: 8px;
    }
    button:hover {
      background-color: ${c.surface0};
      border-color: ${c.oro};
      color: ${c.oro};
    }
    button:focus {
      background-color: ${c.surface0};
      border-color: ${c.oro};
    }
  '';
};
```

## Fastfetch

### Formato: JSONC (config.jsonc)

```jsonc
// ~/.config/fastfetch/config.jsonc
{
  "modules": [
    { "type": "title", "color": { "1": "yellow" } },
    { "type": "separator" },
    { "type": "os", "key": " distro" },
    { "type": "kernel", "key": " kernel" },
    { "type": "cpu", "key": " cpu" },
    { "type": "gpu", "key": " gpu" },
    { "type": "memory", "key": " memory" },
    { "type": "disk", "key": "󰋊 disk" },
    { "type": "shell", "key": " shell" },
    { "type": "packages", "key": " pkgs" },
    { "type": "localip", "key": "󰈀 ip" },
    "break",
    { "type": "colors" }
  ]
}
```

Los colores de fastfetch se mapean via ANSI. Para integrar con theme serpiente, usar los colores del terminal (kitty) que ya está themeado.

## Kitty (terminal)

### Colores en Home Manager

```nix
programs.kitty = {
  enable = true;
  settings = {
    background            = c.base;
    foreground            = c.text;
    cursor                = c.oro;
    cursor_text_color     = c.base;
    selection_background  = c.surface1;
    selection_foreground  = c.text;
    url_color             = c.cobre;

    # 16 colores ANSI
    color0  = c.surface0;  # negro
    color1  = c.rojo;      # rojo
    color2  = c.oliva;     # verde
    color3  = c.ambar;     # amarillo
    color4  = c.cobre;     # azul (mapeado a cobre)
    color5  = c.arena;     # magenta (mapeado a arena)
    color6  = c.oro;       # cyan (mapeado a oro)
    color7  = c.text;      # blanco
    # Bright variants
    color8  = c.surface2;
    color9  = c.rojo;
    color10 = c.oliva;
    color11 = c.oro;
    color12 = c.cobre;
    color13 = c.arena;
    color14 = c.ambar;
    color15 = c.text;
  };
};
```

## Patrón general de ricing

1. **Leer `colores.nix`** — obtener la paleta
2. **Identificar el formato** de config de la app (CSS, JSON, TOML, Nix attrset)
3. **Mapear semánticamente** — usar la tabla de mapeo de theme-serpiente skill
4. **Aplicar via Home Manager** — preferir `programs.X.settings` si existe, sino `xdg.configFile`
5. **Verificar** — rebuild y comprobar visualmente
