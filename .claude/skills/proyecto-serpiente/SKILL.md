---
name: proyecto-serpiente
description: >
  Convenciones operativas del repositorio nixos-config: workflow de rebuild,
  estructura de archivos, cómo añadir módulos, git workflow, dónde va cada cosa.
  Trigger: Cuando se añada un módulo nuevo, se reestructure el proyecto, se dude
  sobre dónde colocar configuración, o se necesite el flujo de trabajo estándar.
metadata:
  author: occulta
  version: "1.0"
---

# Proyecto NixOS "Serpiente" — Convenciones

## Repositorio

- **URL**: https://github.com/pedrogongar/nixos-config
- **Local**: `/etc/nixos` (propiedad de occulta, NO requiere sudo para editar)
- **Branch**: `main` (único)

## Workflow estándar

### 1. Editar archivos

```bash
# Los archivos son propiedad de occulta, editar directamente
nano /etc/nixos/home/hyprland.nix
# O con Claude Code (tiene acceso directo)
```

### 2. Rebuild

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil
```

**NUNCA hacer rebuild sin confirmación de Pedro.**

### 3. Verificar

- Comprobar que funciona visualmente y funcionalmente
- Si requiere exec-once: `hyprctl dispatch exit` (reloguear)

### 4. Commit + Push (solo si funciona)

```bash
cd /etc/nixos && git add . && git commit -m "tipo: descripción" && git push
```

### Prefijos de commit

| Prefijo | Uso |
|---------|-----|
| `feat:` | Nueva funcionalidad |
| `fix:` | Corrección de bug |
| `refactor:` | Reestructuración sin cambio funcional |
| `docs:` | Documentación (CLAUDE.md, README, skills) |
| `style:` | Cambios estéticos (colores, CSS, ricing) |

Mensajes en **español**, imperativos, descriptivos.

## Dónde va cada cosa

### Sistema (requiere rebuild + reloguear)

| Qué | Dónde |
|-----|-------|
| Hardware, boot, kernel | `hosts/portatil/default.nix` |
| Servicios del sistema (PipeWire, greetd) | `modules/desktop.nix` |
| Locale, timezone, SSH | `modules/base.nix` |
| Docker | `modules/docker.nix` |

### Home Manager (requiere rebuild)

| Qué | Dónde |
|-----|-------|
| Hyprland (compositor) | `home/hyprland.nix` |
| Terminal (kitty) | `home/kitty.nix` |
| Shell (zsh, starship, fzf) | `home/shell.nix` |
| Waybar | `home/waybar.nix` |
| Apps (browser, discord, etc.) | `home/apps.nix` |
| Rofi | `home/rofi.nix` |
| Notificaciones | `home/swaync.nix` |
| GTK theme, cursor, iconos | `home/theme.nix` |
| Hyprlock | `home/hyprlock.nix` |
| Wlogout | `home/wlogout.nix` |
| Paleta de colores | `home/colores.nix` |
| Fastfetch | `home/fastfetch/` |

### Flake

| Qué | Dónde |
|-----|-------|
| Inputs (nixpkgs, home-manager, flakes externos) | `flake.nix` |
| Versiones fijadas | `flake.lock` (NO editar manualmente) |

## Cómo añadir un módulo nuevo

### 1. Crear el archivo

```bash
touch /etc/nixos/home/mi-modulo.nix
```

### 2. Estructura mínima

```nix
{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  # Configuración aquí
}
```

### 3. Importar en default.nix

```nix
# home/default.nix
imports = [
  ./hyprland.nix
  ./shell.nix
  ./mi-modulo.nix  # Añadir aquí
  # ...
];
```

### 4. Rebuild y verificar

## Cómo añadir un input externo al flake

### 1. Añadir input en flake.nix

```nix
inputs = {
  # ... existentes ...
  nuevo-flake = {
    url = "github:autor/repo";
    inputs.nixpkgs.follows = "nixpkgs";  # Compartir nixpkgs
  };
};
```

### 2. Pasarlo a outputs

```nix
outputs = { self, nixpkgs, ..., nuevo-flake }: let
  homeManagerModule = {
    home-manager.extraSpecialArgs = { inherit ... nuevo-flake; };
    # ...
  };
```

### 3. Recibirlo en el módulo

```nix
{ config, pkgs, nuevo-flake, ... }:
{
  home.packages = [
    nuevo-flake.packages.x86_64-linux.default
  ];
}
```

### 4. Actualizar lock

```bash
nix flake update  # Actualiza todos
nix flake lock --update-input nuevo-flake  # Solo uno
```

## Archivos que NO se editan

- `flake.lock` — lo gestiona Nix
- `hosts/portatil/hardware-configuration.nix` — generado por NixOS
- Cualquier cosa en `/nix/store/` — inmutable

## Backups

- Antes de cambios grandes: `cp archivo.nix archivo.nix.bak`
- Si el cambio funciona: evaluar si borrar el backup
- Objetivo: mantener el repo lo más limpio posible, sin archivos duplicados

## Alias útiles

| Alias | Comando real |
|-------|-------------|
| `rebuild` | `sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil` |
| `ls` | `eza --icons` |
| `ll` | `eza -la --icons --git` |
| `lt` | `eza --tree --icons --level=2` |
| `cat` | `bat -P` |
| `cd` | `zoxide (z)` |
| `lg` | `lazygit` |
| `ld` | `lazydocker` |
