# nixos-config

Configuración personal de NixOS con flakes y Home Manager. Incluye escritorio Hyprland con rice completo en paleta malva, herramientas de desarrollo y configuración reproducible para múltiples máquinas.

## Stack

- **NixOS 25.11** (unstable) con flakes
- **Home Manager** para configuración de usuario
- **Hyprland** como compositor Wayland
- **Eww** para barra y widgets de escritorio
- **Catppuccin Mocha** como tema base con acento malva

## Estructura

```
nixos-config/
├── flake.nix                    # Entrypoint — hosts y dependencias
├── flake.lock                   # Versiones fijadas
├── hosts/
│   ├── vm/                      # Host: VM QEMU/KVM (desarrollo)
│   └── escritorio/              # Host: máquina física (pendiente NVIDIA)
├── modules/
│   ├── base.nix                 # Configuración base del sistema
│   ├── desktop.nix              # Hyprland, PipeWire, greetd, fuentes
│   └── docker.nix               # Docker y virtualización
└── home/
    ├── default.nix              # Importa todos los módulos home
    ├── hyprland.nix             # Compositor, keybinds, animaciones
    ├── eww.nix                  # Barra flotante y widgets de escritorio
    ├── kitty.nix                # Terminal con tabs, splits y ligaduras
    ├── neovim.nix               # IDE completo con LSP (Vue/TS/C#/Nix/Python)
    ├── vscode.nix               # VSCode con extensiones y settings
    ├── shell.nix                # Zsh + Starship (3 temas)
    ├── theme.nix                # GTK dark, cursor Bibata, iconos Papirus
    ├── apps.nix                 # Firefox, Discord, Telegram, Spotify, etc.
    ├── rofi.nix                 # Lanzador de aplicaciones
    ├── hyprlock.nix             # Pantalla de bloqueo
    ├── wlogout.nix              # Menú de apagado
    ├── swaync.nix               # Notificaciones
    └── matugen.nix              # Colores dinámicos desde wallpaper
```

## Hosts disponibles

| Host | Descripción | Estado |
|---|---|---|
| `nixos-dev` | VM QEMU/KVM sobre CachyOS | ✅ Activo |
| `nixos-escritorio` | Máquina física con RTX 4060 | 🚧 Pendiente NVIDIA |

## Uso en una máquina nueva

```bash
# 1. Instalar NixOS con flakes habilitados
# 2. Clonar el repositorio
git clone git@github.com:pedrogongar/nixos-config.git /etc/nixos

# 3. Ajustar hardware-configuration.nix para la máquina actual
nixos-generate-config --show-hardware-config

# 4. Aplicar la configuración
sudo nixos-rebuild switch --flake /etc/nixos#nixos-dev
```

## Paleta de colores (Malva)

| Variable | Valor | Uso |
|---|---|---|
| `--bg` | `#1a1b26` | Fondo principal |
| `--accent1` | `#c4a7e7` | Malva — color principal |
| `--accent2` | `#8aadf4` | Azul |
| `--accent3` | `#a6da95` | Verde |
| `--accent4` | `#f0c6c6` | Rosa |
| `--accent5` | `#8bd5ca` | Teal |

Los colores pueden reemplazarse dinámicamente desde cualquier wallpaper con `apply-theme /ruta/wallpaper.jpg`.

## Licencia

MIT — consulta el archivo [LICENSE](LICENSE) para más detalles.
