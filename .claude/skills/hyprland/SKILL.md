---
name: hyprland
description: >
  Hyprland v0.53+ compositor Wayland. Windowrules, dispatchers, IPC con hyprctl,
  scripts de shell, extraConfig vs settings, keybindings, monitores, workspaces.
  Trigger: Cuando se edite hyprland.nix, se configuren windowrules, keybindings,
  monitores, workspaces, scripts de shell para Hyprland, o se debug con hyprctl.
metadata:
  author: occulta
  version: "1.0"
---

# Hyprland v0.53+ — Skill para NixOS + Home Manager

Documentación oficial: https://wiki.hypr.land

## Sintaxis de Windowrules (v0.53+ — BREAKING CHANGE)

La sintaxis cambió completamente en v0.53. NO usar la sintaxis antigua (`windowrulev2`).

### Formato nuevo

```
windowrule = PROPIEDAD VALOR, match:CAMPO REGEX
```

### Propiedades booleanas REQUIEREN valor explícito

```
# ✅ CORRECTO
windowrule = float on,         match:class ^(kitty)$
windowrule = fullscreen on,    match:class ^(mpv)$
windowrule = center on,        match:class ^(pavucontrol)$

# ❌ INCORRECTO — error "missing a value"
windowrule = float,            match:class ^(kitty)$
windowrule = fullscreen,       match:class ^(mpv)$
```

### Propiedades con valor

```
windowrule = opacity 0.8 0.8,       match:class ^(kitty)$
windowrule = size 640 360,          match:class ^(mpv)$
windowrule = move 100 100,          match:class ^(kitty)$
windowrule = workspace 1 silent,    match:class ^(terminal-ws1)$
windowrule = border_size 0,         match:class ^(terminal-ws1)$
windowrule = rounding 10,           match:class ^(kitty)$
```

### Match fields disponibles

| Field | Ejemplo | Descripción |
|-------|---------|-------------|
| `match:class` | `^(kitty)$` | Clase de ventana (regex) |
| `match:title` | `^(.*Hyprland.*)$` | Título de ventana (regex) |
| `match:float` | `true` / `false` | Estado flotante |
| `match:fullscreen` | `1` | Estado fullscreen |
| `match:workspace` | `w[tv1]` | Selector de workspace |
| `match:tag` | `mytag` | Tag dinámico |

### Reglas múltiples para misma ventana

```
windowrule = float on,              match:class ^(com\.gabm\.satty)$
windowrule = fullscreen on,         match:class ^(com\.gabm\.satty)$
```

### Layer rules (para waybar, swaync, rofi)

```
layerrule = blur on,                match:namespace swaync-control-center
layerrule = blur on,                match:namespace swaync-notification-window
```

### Opacity — es un PRODUCTO

`active_opacity` × `windowrule opacity` = opacidad final. Usar `override` para valor absoluto:

```
windowrule = opacity 0.8 override 0.8 override, match:class ^(kitty)$
```

## Special Workspaces (Scratchpads)

### Comportamiento

- Se renderizan como **overlay flotante**, NO siguen el layout (dwindle/master)
- Necesitan `float on`, `size`, `center on` para posicionarse
- Si la ventana se **cierra** (no se oculta), el proceso muere. El toggle después muestra ws vacío

### Patrón correcto para scratchpads

```nix
# En bind — script que toggle o relanza si la ventana murió
"$mod SHIFT, B, exec, ${scratchpadToggle}/bin/scratchpad-toggle btop btop-scratchpad kitty --class btop-scratchpad -e btop"
```

```bash
# Script scratchpad-toggle
WS="$1"; CLASS="$2"; shift 2
hyprctl dispatch togglespecialworkspace "$WS"
sleep 0.1
if ! hyprctl clients -j | jq -e ".[] | select(.class==\"$CLASS\")" > /dev/null 2>&1; then
  "$@" &
fi
```

```
# Windowrules
windowrule = workspace special:btop silent,  match:class ^(btop-scratchpad)$
windowrule = float on,                       match:class ^(btop-scratchpad)$
windowrule = size 60% 70%,                   match:class ^(btop-scratchpad)$
windowrule = center on,                      match:class ^(btop-scratchpad)$
```

## hyprctl — IPC con Hyprland

### Comandos esenciales

```bash
hyprctl monitors -j          # Monitores conectados (JSON)
hyprctl workspaces -j        # Workspaces activos (JSON)
hyprctl clients -j           # Ventanas abiertas (JSON)
hyprctl activewindow -j      # Ventana con foco (JSON)
hyprctl activeworkspace -j   # Workspace activo (JSON)

hyprctl dispatch workspace 3
hyprctl dispatch movetoworkspacesilent "3,address:0x..."
hyprctl dispatch killactive
hyprctl dispatch togglespecialworkspace nombre
hyprctl dispatch focuswindow class:kitty
hyprctl dispatch exit
hyprctl keyword monitor "eDP-1, disable"
```

### CRÍTICO: dispatch es asíncrono

```bash
hyprctl dispatch workspace "$FREE"
sleep 0.3  # Esperar transición
satty -f "$TMP"
```

### CRÍTICO: keyword bind AÑADE, no reemplaza

```bash
# Esto crea DOS binds para SUPER+T
hyprctl keyword bind "SUPER, T, exec, kitty"
hyprctl keyword bind "SUPER, T, exec, alacritty"
```

## Clases de ventana — NUNCA asumas el nombre

| Ejecutable | Clase REAL |
|-----------|-----------|
| satty | `com.gabm.satty` |
| pavucontrol | `org.pulseaudio.pavucontrol` |
| zapzap | `com.rtosta.zapzap` |

```bash
hyprctl clients -j | jq '.[] | {class, title}'
```

## NixOS + Home Manager: settings vs extraConfig

- **settings**: Nix attrset para config estructurada (general, monitor, bind, exec-once)
- **extraConfig**: String literal para windowrules/layerrules v0.53+ (Home Manager no soporta la sintaxis nueva)

## Scripts de shell en NixOS

```nix
let
  miScript = pkgs.writeShellScriptBin "mi-script" ''
    RESULT=$(hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')
    echo "$RESULT"
  '';
in {
  bind = [ "$mod, X, exec, ${miScript}/bin/mi-script" ];
}
```

- Usar `${pkgs.jq}/bin/jq` en vez de `jq`
- Scripts desde `bind exec` asocian ventanas al ws del bind, NO al ws activo tras dispatch
- Para mover ventanas: lanzar background + esperar + movetoworkspacesilent

## Anti-patrones

- Windowrules sin valor explícito en booleanos
- Asumir nombres de clase sin verificar
- Depender de `dispatch workspace` para ubicar ventanas desde binds
- Usar `hyprctl keyword bind` para "reemplazar" binds
- Windowrules v0.53+ en `settings` de Home Manager
- Procesos que dependen de transición de ws sin `sleep`
