# nixos-config

Configuración personal de NixOS con flakes y Home Manager. Escritorio Hyprland con tema "Serpiente" — paleta oscura con acentos rojos, naranjas y oros.

## Stack

- **NixOS 26.05** (Yarara, unstable) con flakes
- **Home Manager** para configuración de usuario
- **Hyprland 0.54** como compositor Wayland
- **Waybar** como barra de estado
- **Tema Serpiente** — paleta propia definida en `home/colores.nix`

## Hardware

- MSI portátil, Intel i7-13620H, Intel UHD Graphics, 32GB RAM, NVMe 1TB
- Monitores: HDMI-A-1 Acer 1080p@144Hz (izq, principal) + DP-1 ASUS 1080p@165Hz (der) + eDP-1 portátil (desactivado con externos)
- Audio: PipeWire + WirePlumber, FiiO K11 DAC/AMP USB

## Estructura

```
nixos-config/
├── flake.nix                    # Inputs: nixpkgs, home-manager, spicetify, zen-browser, claude-code
├── flake.lock
├── hosts/
│   └── portatil/
│       ├── default.nix          # Hardware, boot, usuarios, bluetooth, steam
│       └── hardware-configuration.nix
├── modules/
│   ├── base.nix                 # Locale, timezone, git, ssh
│   ├── desktop.nix              # greetd/tuigreet, PipeWire, Hyprland, fuentes, portales XDG
│   └── docker.nix
└── home/
    ├── default.nix              # Punto de entrada Home Manager
    ├── colores.nix              # Paleta tema Serpiente (source of truth para colores)
    ├── hyprland.nix             # Compositor: monitores, keybindings, windowrules, scripts
    ├── shell.nix                # Zsh, Starship, fzf, bat, eza, zoxide, direnv, Claude Code
    ├── apps.nix                 # Zen Browser, Discord, Telegram, VLC, Obsidian, ZapZap, etc.
    ├── waybar.nix               # Barra de estado
    ├── kitty.nix                # Terminal
    ├── rofi.nix                 # Lanzador
    ├── mako.nix                 # Notificaciones (Wayland nativo)
    ├── theme.nix                # GTK dark, cursor Bibata, iconos Papirus
    ├── hyprlock.nix             # Pantalla de bloqueo
    ├── wlogout.nix              # Menú de apagado
    ├── matugen.nix              # Temas dinámicos desde wallpaper
    ├── spicetify.nix            # Spotify personalizado
    ├── neovim.nix               # Editor con LSP
    ├── vscode.nix               # VSCodium con extensiones
    ├── btop.nix                 # Monitor de recursos
    ├── nano.nix                 # Config nano
    ├── fastfetch.nix            # Info del sistema
    └── fastfetch/               # Config fastfetch
```

## Tema Serpiente

Paleta oscura inspirada en tonos de serpiente: rojos profundos, naranjas cálidos y oros sobre fondo casi negro. Definida en `home/colores.nix` y aplicada de forma coherente en todas las apps.

| Variable   | Hex       | Uso                          |
|------------|-----------|------------------------------|
| `crust`    | `#080808` | Negro absoluto               |
| `base`     | `#0a0a0a` | Fondo principal              |
| `mantle`   | `#121010` | Fondo alternativo            |
| `surface0` | `#1e1616` | Superficies elevadas         |
| `text`     | `#d4c4b0` | Texto principal              |
| `subtext`  | `#b0a090` | Texto secundario             |
| `oro`      | `#e8c020` | Acento principal             |
| `ambar`    | `#e08830` | Acento cálido                |
| `rojo`     | `#c43030` | Alertas, urgencia            |
| `oliva`    | `#8a8030` | Éxito, confirmación          |
| `cobre`    | `#a07040` | Acento terciario             |
| `arena`    | `#907a50` | Acento neutro                |

## Keybindings principales

| Atajo | Acción |
|---|---|
| `Super+T` | Terminal kitty |
| `Super+A` | Rofi (lanzador) |
| `Super+F` | Zen Browser |
| `Super+E` | Thunar |
| `Super+V` | VSCodium |
| `Super+C` | Claude Code (ws1, mitad derecha) |
| `Super+Q` | Cerrar ventana (protege terminal-ws1) |
| `Super+N` | Descartar notificaciones |
| `Super+X` | Wlogout |
| `Super+L` | Hyprlock |
| `Super+M` | Selector de monitores |
| `Super+Shift+S` | Captura de área |
| `Super+Shift+B` | Scratchpad btop |
| `Super+Shift+W` | Scratchpad Spotify |
| `Super+Shift+Z` | Scratchpad ZapZap |

## Workspace 1

Workspace decorativo con dos terminales flotantes fijadas:

- **Terminal principal** (mitad izquierda) — fondo completamente transparente, sin borde
- **Claude Code** (mitad derecha) — opacidad 0.75, sin borde, se lanza con `Super+C`
- **Fastfetch** se ejecuta al abrir cada terminal

## Temas dinámicos desde wallpaper

```bash
apply-theme ~/imagenes/wallpapers/mi-fondo.jpg   # genera paleta con Matugen
default-theme                                      # restaura paleta Serpiente
```

Matugen genera colores para: Hyprland, kitty, rofi, mako, hyprlock, cava.

## Uso en una máquina nueva

```bash
# 1. Instalar NixOS con flakes habilitados
# 2. Clonar el repositorio
git clone git@github.com:pedrogongar/nixos-config.git /etc/nixos

# 3. Generar hardware-configuration para la máquina
nixos-generate-config --show-hardware-config > /etc/nixos/hosts/portatil/hardware-configuration.nix

# 4. Aplicar
sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil
```

## Licencia

MIT — consulta el archivo [LICENSE](LICENSE) para más detalles.
