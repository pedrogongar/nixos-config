# nixos-config

Configuración personal de NixOS con flakes y Home Manager. Escritorio Hyprland con estética Tokyo Night / Cyberspace, herramientas de desarrollo y configuración reproducible.

## Stack

- **NixOS 25.11** (unstable) con flakes
- **Home Manager** para configuración de usuario
- **Hyprland** como compositor Wayland (sin blur — optimizado para CPU)
- **Waybar** como barra de estado
- **Tokyo Night** como paleta base con acentos cyan

## Estructura

```
nixos-config/
├── flake.nix                    # Entrypoint — host y dependencias
├── flake.lock                   # Versiones fijadas
├── hosts/
│   └── portatil/                # Host único (físico)
│       ├── default.nix
│       └── hardware-configuration.nix  # generado localmente, no commitear
├── modules/
│   ├── base.nix                 # Locale, timezone, git, ssh
│   ├── desktop.nix              # Hyprland, PipeWire, greetd, fuentes
│   └── docker.nix               # Docker
└── home/
    ├── default.nix              # Importa todos los módulos home
    ├── hyprland.nix             # Compositor, keybinds, ventanas decorativas ws1
    ├── waybar.nix               # Barra: workspaces, reloj, métricas, IP
    ├── kitty.nix                # Terminal
    ├── fastfetch.nix            # Módulo fastfetch
    ├── fastfetch/
    │   └── config.jsonc         # Config fastfetch (ws1 decorativo)
    ├── neovim.nix               # IDE con LSP (Vue/TS/C#/Nix/Python)
    ├── vscode.nix               # VSCode con extensiones y settings
    ├── shell.nix                # Zsh + Starship (3 temas)
    ├── theme.nix                # GTK dark, cursor Bibata, iconos Papirus
    ├── apps.nix                 # Firefox, Discord, Telegram, Spotify, etc.
    ├── rofi.nix                 # Lanzador
    ├── rofi/
    │   └── theme.rasi
    ├── hyprlock.nix             # Pantalla de bloqueo
    ├── wlogout.nix              # Menú de apagado
    ├── wlogout/
    │   └── style.css
    ├── swaync.nix               # Notificaciones
    ├── swaync/
    │   ├── config.json
    │   └── style.css
    ├── matugen.nix              # Colores dinámicos desde wallpaper
    └── nano.nix                 # Config nano
```

## Uso en una máquina nueva

```bash
# 1. Instalar NixOS con flakes habilitados
# 2. Clonar el repositorio
git clone git@github.com:pedrogongar/nixos-config.git /etc/nixos

# 3. Generar hardware-configuration para la máquina actual (NO commitear)
nixos-generate-config --show-hardware-config > /etc/nixos/hosts/portatil/hardware-configuration.nix

# 4. Aplicar
sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil
```

## Workspace 1 — decorativo

El workspace 1 actúa como presentación del escritorio con dos ventanas Kitty flotantes fijadas:

- **cmatrix** (unimatrix con katakana) — esquina izquierda, 50% opacidad
- **fastfetch** — specs del sistema, 80% opacidad

Ambas son `nofocus` y `pin` — no interfieren con el flujo de trabajo.

## Temas de Starship

```bash
theme tokyo    # Tokyo Night (default)
theme dracula  # Dracula
theme malva    # Malva / Macchiato
```

## Temas dinámicos desde wallpaper

```bash
apply-theme ~/wallpapers/mi-fondo.jpg   # genera paleta con Matugen
default-theme                            # restaura paleta Tokyo Night
```

## Paleta base (Tokyo Night / Cyberspace)

| Variable   | Valor     | Uso                        |
|------------|-----------|----------------------------|
| `--bg`     | `#0d0e17` | Fondo profundo             |
| `--accent` | `#7dcfff` | Cyan — color principal     |
| `--blue`   | `#7aa2f7` | Azul workspaces activos    |
| `--purple` | `#bb9af7` | Malva — memoria, secundario|
| `--green`  | `#9ece6a` | Verde — batería, éxito     |
| `--teal`   | `#73daca` | Teal — volumen             |
| `--orange` | `#e0af68` | Naranja — IP local         |

## Licencia

MIT — consulta el archivo [LICENSE](LICENSE) para más detalles.
