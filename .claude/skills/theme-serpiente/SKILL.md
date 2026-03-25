---
name: theme-serpiente
description: >
  Paleta de colores "Serpiente" y cómo aplicarla a cada tipo de aplicación.
  Mapeo semántico de colores, patrones de CSS, config nativa, browser themes.
  Trigger: Cuando se apliquen colores a cualquier app, se cree un theme nuevo,
  se configure waybar/swaync/rofi/kitty/starship/browser CSS, o se modifique colores.nix.
metadata:
  author: occulta
  version: "1.0"
---

# Theme Serpiente — Paleta y aplicación

## REGLA FUNDAMENTAL

**SIEMPRE** leer `/etc/nixos/home/colores.nix` antes de usar cualquier color. NUNCA hardcodear valores hex — usar las variables del archivo.

## Paleta (definida en colores.nix)

### Colores base (fondos y superficies)

| Variable | Función semántica |
|----------|------------------|
| `crust` | Fondo más oscuro (barras, bordes exteriores) |
| `mantle` | Fondo secundario (sidebars, paneles) |
| `base` | Fondo principal (ventanas, editores) |
| `surface0` | Separadores, líneas sutiles |
| `surface1` | Elementos inactivos, bordes suaves |
| `surface2` | Elementos hover, selección inactiva |

### Colores de texto

| Variable | Función semántica |
|----------|------------------|
| `text` | Texto principal (máximo contraste) |
| `subtext` | Texto secundario (timestamps, metadata, placeholders) |

### Colores de acento

| Variable | Función semántica |
|----------|------------------|
| `oro` | Color principal, identidad del theme, títulos, acento primario |
| `ambar` | Nombres de usuario, badges, warnings |
| `rojo` | Errores, destructivo, urgente, git status |
| `oliva` | Éxito, confirmación, versiones, git ok |
| `cobre` | Ramas git, enlaces, acento secundario cálido |
| `arena` | Paths, directorios, acento terciario suave |

### Variantes _rgb

Cada color tiene variante `_rgb` (sin #, sin prefijo) para uso en `rgba()`:

```nix
c.oro      # → "#d4a017" (para CSS, config)
c.oro_rgb  # → "d4a017"  (para rgba en Hyprland)
```

## Cómo aplicar por tipo de app

### CSS (Waybar, SwayNC, Rofi, Wlogout)

```nix
let c = import ./colores.nix; in
''
  * {
    font-family: "JetBrainsMono Nerd Font";
  }
  window {
    background-color: ${c.crust};
    color: ${c.text};
  }
  .module {
    background-color: ${c.base};
    border: 1px solid ${c.surface1};
    border-radius: 8px;
    color: ${c.text};
  }
  .module:hover {
    background-color: ${c.surface0};
  }
  .active {
    color: ${c.oro};
    border-bottom: 2px solid ${c.oro};
  }
  .warning {
    color: ${c.ambar};
  }
  .critical {
    color: ${c.rojo};
  }
  .success {
    color: ${c.oliva};
  }
''
```

### Config nativa Nix (Kitty, Starship, fzf)

```nix
# Kitty (en kitty.nix)
programs.kitty.settings = {
  background = c.base;
  foreground = c.text;
  cursor     = c.oro;
  selection_background = c.surface1;
  # ...
};

# Starship (en shell.nix)
custom.capricorn.format = "[($output )](bold ${c.oro})";
username.format = "[$user](bold ${c.ambar}) ";
directory.format = "[$path](${c.arena}) ";

# fzf (en shell.nix)
"--color=bg+:${c.surface0},bg:${c.base},spinner:${c.oro},hl:${c.arena}"
```

### Hyprland (en hyprland.nix)

```nix
let strip = s: builtins.substring 1 6 s; in
{
  "col.active_border"   = "rgba(${strip c.oro}ff)";
  "col.inactive_border" = "rgba(${strip c.surface1}66)";
}
```

La función `strip` quita el `#` para uso en `rgba()`.

### Browser CSS (userChrome.css / userContent.css)

```css
:root {
  --serpiente-bg: ${c.base};
  --serpiente-fg: ${c.text};
  --serpiente-accent: ${c.oro};
  --serpiente-border: ${c.surface1};
}
```

Se inyecta vía Home Manager con `programs.zen-browser` o Firefox profile settings.

### GTK theme

```nix
gtk = {
  enable = true;
  theme.name = "Adwaita-dark";  # Base oscura
  # Los colores específicos se aplican via CSS overrides
};
```

## Mapeo semántico — Qué color usar para qué

| Contexto | Color | Razón |
|----------|-------|-------|
| Workspace activo | `oro` | Destaca sobre fondo oscuro |
| Workspace inactivo | `surface1` | Visible pero no distrae |
| Reloj / hora | `text` | Info principal, siempre legible |
| Volumen normal | `oliva` | Estado ok |
| Volumen mudo | `rojo` | Alerta |
| Batería >50% | `oliva` | Ok |
| Batería 20-50% | `ambar` | Warning |
| Batería <20% | `rojo` | Crítico |
| WiFi conectado | `oliva` | Ok |
| WiFi desconectado | `rojo` | Problema |
| Bluetooth | `cobre` | Acento cálido secundario |
| CPU/RAM normal | `text` | Info |
| CPU/RAM alto | `ambar` → `rojo` | Gradiente de urgencia |
| Notificación normal | `text` sobre `base` | Neutro |
| Notificación urgente | `rojo` sobre `mantle` | Destacar |
| Git branch | `cobre` | Consistente con Starship |
| Git modified | `rojo` | Consistente con Starship |
| Título de ventana | `oro` | Identidad del theme |
| Tooltip / popup | `text` sobre `mantle` | Contraste suave |

## Wallpaper

El wallpaper es una serpiente detallada en tonos rojos/naranjas/oros sobre fondo oscuro. Todo el ricing debe **complementarlo**, no competir con él. Los colores de la paleta fueron elegidos para armonizar con esta imagen.

## Anti-patrones

- NUNCA hardcodear `#d4a017` — usar `c.oro`
- NUNCA usar colores fuera de la paleta (blancos puros, azules, etc.)
- NUNCA usar el mismo color para estados diferentes (ok y error ambos en rojo)
- Si un color no existe en la paleta para un caso de uso, discutir antes de añadirlo
