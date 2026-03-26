{ config, pkgs, ... }:

let
  c = import ./colores.nix;
  strip = s: builtins.substring 1 6 s;

  # ── Función común: aplicar colores + wallpaper + recargar apps ────────
  #    Usada por ambos scripts para evitar duplicación
  applyColors = ''
    # Aplicar wallpaper solo en monitores activos (no reactivar eDP-1)
    MONITORS=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')
    for mon in $MONITORS; do
      ${pkgs.swww}/bin/swww img "$WALLPAPER" \
        --outputs "$mon" \
        --transition-type grow \
        --transition-duration 2 &
    done
    wait

    # Aplicar borde activo de Hyprland desde colores generados
    HYPR_COLORS="$HOME/.cache/matugen/colors-hyprland.conf"
    if [ -f "$HYPR_COLORS" ]; then
      ACCENT=$(grep '^\$accent =' "$HYPR_COLORS" | head -1 | ${pkgs.gawk}/bin/awk '{print $3}')
      if [ -n "$ACCENT" ]; then
        hyprctl keyword general:col.active_border "$ACCENT" 2>/dev/null
      fi
    fi

    # Mako: cat colores + base → config (romper symlink del store si existe)
    MAKO_COLORS="$HOME/.cache/matugen/colors-mako.conf"
    MAKO_BASE="$HOME/.config/mako/config-base"
    MAKO_CONFIG="$HOME/.config/mako/config"
    if [ -f "$MAKO_COLORS" ] && [ -f "$MAKO_BASE" ]; then
      [ -L "$MAKO_CONFIG" ] && rm "$MAKO_CONFIG"
      cat "$MAKO_COLORS" "$MAKO_BASE" > "$MAKO_CONFIG"
    fi

    # Waybar: cat colores + base → style.css (romper symlink del store si existe)
    WAYBAR_COLORS="$HOME/.cache/matugen/colors-waybar.css"
    WAYBAR_BASE="$HOME/.config/waybar/style-base.css"
    WAYBAR_CSS="$HOME/.config/waybar/style.css"
    if [ -f "$WAYBAR_COLORS" ] && [ -f "$WAYBAR_BASE" ]; then
      [ -L "$WAYBAR_CSS" ] && rm "$WAYBAR_CSS"
      cat "$WAYBAR_COLORS" "$WAYBAR_BASE" > "$WAYBAR_CSS"
    fi

    # Wlogout: cat colores + base → style.css + regenerar SVGs con accent
    WLOGOUT_COLORS="$HOME/.cache/matugen/colors-wlogout.css"
    WLOGOUT_BASE="$HOME/.config/wlogout/style-base.css"
    WLOGOUT_CSS="$HOME/.config/wlogout/style.css"
    if [ -f "$WLOGOUT_COLORS" ] && [ -f "$WLOGOUT_BASE" ]; then
      [ -L "$WLOGOUT_CSS" ] && rm "$WLOGOUT_CSS"
      cat "$WLOGOUT_COLORS" "$WLOGOUT_BASE" > "$WLOGOUT_CSS"
    fi

    # Starship: cat base + colores → starship.toml (mv atómico para forzar re-lectura)
    STARSHIP_COLORS="$HOME/.cache/matugen/colors-starship.toml"
    STARSHIP_BASE="$HOME/.config/starship-base.toml"
    STARSHIP_CONF="$HOME/.config/starship.toml"
    if [ -f "$STARSHIP_COLORS" ] && [ -f "$STARSHIP_BASE" ]; then
      [ -L "$STARSHIP_CONF" ] && rm "$STARSHIP_CONF"
      cat "$STARSHIP_BASE" "$STARSHIP_COLORS" > "''${STARSHIP_CONF}.tmp"
      mv "''${STARSHIP_CONF}.tmp" "$STARSHIP_CONF"
    fi

    # Generar SVGs de wlogout con el accent del tema activo
    WL_ACCENT="${c.oro}"
    if [ -f "$WLOGOUT_COLORS" ]; then
      _ACC=$(grep '@define-color wl_accent' "$WLOGOUT_COLORS" | grep -o '#[0-9a-fA-F]*')
      [ -n "$_ACC" ] && WL_ACCENT="$_ACC"
    fi
    ICON_DIR="$HOME/.config/wlogout/icons"
    mkdir -p "$ICON_DIR"
    for _icon in shutdown reboot logout suspend; do
      [ -L "$ICON_DIR/$_icon.svg" ] && rm "$ICON_DIR/$_icon.svg"
    done

    cat > "$ICON_DIR/shutdown.svg" << SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none" stroke="$WL_ACCENT" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M24 4v16"/>
  <path d="M36.73 12.27A16 16 0 1111.27 12.27"/>
</svg>
SVGEOF

    cat > "$ICON_DIR/reboot.svg" << SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none" stroke="$WL_ACCENT" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M4 10v10h10"/>
  <path d="M38.66 30A16 16 0 0010.34 13.34L4 20"/>
  <path d="M44 38V28H34"/>
  <path d="M9.34 18A16 16 0 0037.66 34.66L44 28"/>
</svg>
SVGEOF

    cat > "$ICON_DIR/logout.svg" << SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none" stroke="$WL_ACCENT" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M18 42H10a4 4 0 01-4-4V10a4 4 0 014-4h8"/>
  <polyline points="32 34 42 24 32 14"/>
  <line x1="42" y1="24" x2="18" y2="24"/>
</svg>
SVGEOF

    cat > "$ICON_DIR/suspend.svg" << SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none" stroke="$WL_ACCENT" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M42 26.68A18 18 0 1121.32 6 14 14 0 0042 26.68z"/>
</svg>
SVGEOF

    # Obsidian: copiar CSS snippet al vault (crear snippets si no existe)
    OBSIDIAN_CSS="$HOME/.cache/matugen/colors-obsidian.css"
    OBSIDIAN_VAULT="$HOME/obsidian/dev/.obsidian"
    if [ -f "$OBSIDIAN_CSS" ] && [ -d "$OBSIDIAN_VAULT" ]; then
      mkdir -p "$OBSIDIAN_VAULT/snippets"
      cp "$OBSIDIAN_CSS" "$OBSIDIAN_VAULT/snippets/matugen-theme.css"
    fi

    # Recargar apps (hyprctl exec asegura contexto correcto desde waybar/selector)
    ${pkgs.mako}/bin/makoctl reload 2>/dev/null
    hyprctl dispatch exec "${pkgs.procps}/bin/pkill -SIGUSR2 waybar" 2>/dev/null
    hyprctl dispatch exec "${pkgs.procps}/bin/pkill -USR1 kitty" 2>/dev/null
    # Forzar redibujado del prompt (starship re-lee config al redibujar)
    sleep 0.3
    hyprctl dispatch exec "${pkgs.procps}/bin/pkill -SIGWINCH zsh" 2>/dev/null

    # Proteger eDP-1: si hay monitores externos, mantener deshabilitado
    if hyprctl monitors -j | ${pkgs.jq}/bin/jq -e '[.[].name] | any(. == "HDMI-A-1" or . == "DP-1")' > /dev/null 2>&1; then
      sleep 0.5
      hyprctl keyword monitor "eDP-1, disable" 2>/dev/null
    fi

    echo "$WALLPAPER" > "$HOME/.cache/matugen/current-wallpaper"
  '';

  applyTheme = pkgs.writeShellScriptBin "apply-theme" ''
    WALLPAPER="$1"
    DEFAULT_WP="$HOME/imagenes/wallpapers/default.jpg"

    if [ -z "$WALLPAPER" ]; then
      echo "Uso: apply-theme /ruta/al/wallpaper.jpg"
      exit 1
    fi

    # Si es el wallpaper default → usar paleta Serpiente curada
    REAL_PATH=$(realpath "$WALLPAPER" 2>/dev/null || echo "$WALLPAPER")
    REAL_DEFAULT=$(realpath "$DEFAULT_WP" 2>/dev/null || echo "$DEFAULT_WP")
    if [ "$REAL_PATH" = "$REAL_DEFAULT" ]; then
      exec default-theme "$WALLPAPER"
    fi

    mkdir -p "$HOME/.cache/matugen"

    # Generar paleta desde el wallpaper (--source-color-index 0 evita prompt interactivo)
    ${pkgs.matugen}/bin/matugen image "$WALLPAPER" \
      --config "$HOME/.config/matugen/config.toml" \
      --source-color-index 0

    ${applyColors}
    echo "✓ Tema aplicado desde: $WALLPAPER"
  '';

  defaultTheme = pkgs.writeShellScriptBin "default-theme" ''
    WALLPAPER="''${1:-$HOME/imagenes/wallpapers/default.jpg}"
    DEFAULTS="$HOME/.config/matugen/defaults"
    OUTPUT="$HOME/.cache/matugen"

    mkdir -p "$OUTPUT"

    # Restaurar paleta Serpiente (copiar todos los defaults al cache)
    install -m 644 "$DEFAULTS/colors-hyprland.conf" "$OUTPUT/colors-hyprland.conf"
    install -m 644 "$DEFAULTS/colors-kitty.conf"    "$OUTPUT/colors-kitty.conf"
    install -m 644 "$DEFAULTS/colors-rofi.rasi"     "$OUTPUT/colors-rofi.rasi"
    install -m 644 "$DEFAULTS/colors-mako.conf"     "$OUTPUT/colors-mako.conf"
    install -m 644 "$DEFAULTS/colors-waybar.css"    "$OUTPUT/colors-waybar.css"
    install -m 644 "$DEFAULTS/colors-wlogout.css"   "$OUTPUT/colors-wlogout.css"
    install -m 644 "$DEFAULTS/colors-starship.toml" "$OUTPUT/colors-starship.toml"
    install -m 644 "$DEFAULTS/colors-hyprlock.conf" "$OUTPUT/colors-hyprlock.conf"
    install -m 644 "$DEFAULTS/colors-cava.conf"     "$OUTPUT/colors-cava.conf"
    install -m 644 "$DEFAULTS/colors-neovim.lua"   "$OUTPUT/colors-neovim.lua"
    install -m 644 "$DEFAULTS/colors-zen.css"      "$OUTPUT/colors-zen.css"
    install -m 644 "$DEFAULTS/colors-obsidian.css" "$OUTPUT/colors-obsidian.css"

    ${applyColors}
    echo "✓ Paleta Serpiente restaurada"
  '';

in
{
  home.packages = [ applyTheme defaultTheme ];

  xdg.configFile."matugen/config.toml".text = ''
    [config]
    type = "scheme-tonal-spot"
    [templates]
    [templates.hyprland]
    input_path = "~/.config/matugen/templates/hyprland.conf"
    output_path = "~/.cache/matugen/colors-hyprland.conf"
    [templates.kitty]
    input_path = "~/.config/matugen/templates/kitty.conf"
    output_path = "~/.cache/matugen/colors-kitty.conf"
    [templates.rofi]
    input_path = "~/.config/matugen/templates/rofi.rasi"
    output_path = "~/.cache/matugen/colors-rofi.rasi"
    [templates.mako]
    input_path = "~/.config/matugen/templates/mako.conf"
    output_path = "~/.cache/matugen/colors-mako.conf"
    [templates.waybar]
    input_path = "~/.config/matugen/templates/waybar.css"
    output_path = "~/.cache/matugen/colors-waybar.css"
    [templates.wlogout]
    input_path = "~/.config/matugen/templates/wlogout.css"
    output_path = "~/.cache/matugen/colors-wlogout.css"
    [templates.starship]
    input_path = "~/.config/matugen/templates/starship.toml"
    output_path = "~/.cache/matugen/colors-starship.toml"
    [templates.hyprlock]
    input_path = "~/.config/matugen/templates/hyprlock.conf"
    output_path = "~/.cache/matugen/colors-hyprlock.conf"
    [templates.cava]
    input_path = "~/.config/matugen/templates/cava.conf"
    output_path = "~/.cache/matugen/colors-cava.conf"
    [templates.neovim]
    input_path = "~/.config/matugen/templates/neovim.lua"
    output_path = "~/.cache/matugen/colors-neovim.lua"
    [templates.zen]
    input_path = "~/.config/matugen/templates/zen.css"
    output_path = "~/.cache/matugen/colors-zen.css"
    [templates.obsidian]
    input_path = "~/.config/matugen/templates/obsidian.css"
    output_path = "~/.cache/matugen/colors-obsidian.css"
  '';

  # ── Defaults Serpiente ────────────────────────────────────────────────

  xdg.configFile."matugen/defaults/colors-hyprland.conf".text = ''
    $accent = rgb(${strip c.oro})
    $accent2 = rgb(${strip c.ambar})
    $bg = rgb(${strip c.base})
    $bg-surface = rgba(${strip c.base}99)
    $border = rgba(${strip c.oro}66)
    $text = rgb(${strip c.text})
    $text-dim = rgb(${strip c.subtext})
    $red = rgb(${strip c.rojo})
    $green = rgb(${strip c.oliva})
    $yellow = rgb(${strip c.oro})
  '';

  xdg.configFile."matugen/defaults/colors-kitty.conf".text = ''
    foreground ${c.text}
    background ${c.base}
    cursor ${c.oro}
    cursor_text_color ${c.base}
    selection_foreground ${c.text}
    selection_background ${c.surface0}
    url_color ${c.arena}
    active_tab_foreground ${c.base}
    active_tab_background ${c.oro}
    inactive_tab_foreground ${c.surface2}
    inactive_tab_background ${c.mantle}
    color0  ${c.mantle}
    color1  ${c.rojo}
    color2  ${c.oliva}
    color3  ${c.oro}
    color4  ${c.cobre}
    color5  ${c.ambar}
    color6  ${c.arena}
    color7  ${c.subtext}
    color8  ${c.surface2}
    color9  ${c.rojo}
    color10 ${c.oliva}
    color11 ${c.oro}
    color12 ${c.cobre}
    color13 ${c.ambar}
    color14 ${c.arena}
    color15 ${c.text}
  '';

  xdg.configFile."matugen/defaults/colors-rofi.rasi".text = ''
    * {
        bg: rgba(${c.base_rgb}, 0.92);
        bg-alt: rgba(${c.mantle_rgb}, 0.98);
        fg: ${c.text};
        fg-dim: ${c.subtext};
        accent: ${c.oro};
        accent-dim: rgba(${c.oro_rgb}, 0.1);
        border-col: rgba(${c.oro_rgb}, 0.2);
        urgent: ${c.rojo};
    }
  '';

  xdg.configFile."matugen/defaults/colors-mako.conf".text = ''
    background-color=${c.mantle}FA
    text-color=${c.text}
    border-color=${c.oro}2E
  '';

  xdg.configFile."matugen/defaults/colors-waybar.css".text = ''
    @define-color wb_base ${c.base};
    @define-color wb_oro ${c.oro};
    @define-color wb_ambar ${c.ambar};
    @define-color wb_text ${c.text};
    @define-color wb_oliva ${c.oliva};
    @define-color wb_rojo ${c.rojo};
  '';

  xdg.configFile."matugen/defaults/colors-wlogout.css".text = ''
    @define-color wl_base ${c.base};
    @define-color wl_mantle ${c.mantle};
    @define-color wl_accent ${c.oro};
    @define-color wl_text ${c.text};
  '';

  xdg.configFile."matugen/defaults/colors-starship.toml".text = ''

    [palettes.active]
    sp_oro = "${c.oro}"
    sp_ambar = "${c.ambar}"
    sp_arena = "${c.arena}"
    sp_cobre = "${c.cobre}"
    sp_rojo = "${c.rojo}"
    sp_oliva = "${c.oliva}"
    sp_subtext = "${c.subtext}"
  '';

  xdg.configFile."matugen/defaults/colors-hyprlock.conf".text = ''
    $fg = rgba(${c.text_rgb}, 1.0)
    $fg-dim = rgba(${c.subtext_rgb}, 1.0)
    $accent = rgba(${c.oro_rgb}, 0.3)
    $bg = rgba(${c.base_rgb}, 0.75)
    $green = rgba(${c.oliva_rgb}, 0.5)
    $red = rgba(${c.rojo_rgb}, 0.5)
  '';

  xdg.configFile."matugen/defaults/colors-cava.conf".text = ''
    [color]
    gradient = 1
    gradient_count = 4
    gradient_color_1 = '${c.oro}'
    gradient_color_2 = '${c.ambar}'
    gradient_color_3 = '${c.rojo}'
    gradient_color_4 = '${c.sangre}'
  '';

  xdg.configFile."matugen/defaults/colors-neovim.lua".text = ''
    return {
      rosewater = "${c.text}",
      flamingo  = "${c.ambar}",
      pink      = "${c.rojo}",
      mauve     = "${c.oro}",
      red       = "${c.rojo}",
      maroon    = "${c.sangre}",
      peach     = "${c.ambar}",
      yellow    = "${c.oro}",
      green     = "${c.oliva}",
      teal      = "${c.arena}",
      sky       = "${c.arena}",
      sapphire  = "${c.arena}",
      blue      = "${c.cobre}",
      lavender  = "${c.oro}",
      text      = "${c.text}",
      subtext1  = "${c.subtext}",
      subtext0  = "${c.subtext}",
      overlay2  = "${c.overlay}",
      overlay1  = "${c.overlay}",
      overlay0  = "${c.overlay}",
      surface2  = "${c.surface2}",
      surface1  = "${c.surface1}",
      surface0  = "${c.surface0}",
      base      = "${c.base}",
      mantle    = "${c.mantle}",
      crust     = "${c.crust}",
    }
  '';

  xdg.configFile."matugen/defaults/colors-zen.css".text = ''
    :root {
      --serp-crust:    ${c.crust};
      --serp-mantle:   ${c.mantle};
      --serp-base:     ${c.base};
      --serp-surface0: ${c.surface0};
      --serp-surface1: ${c.surface1};
      --serp-surface2: ${c.surface2};
      --serp-text:     ${c.text};
      --serp-subtext:  ${c.subtext};
      --serp-oro:      ${c.oro};
      --serp-ambar:    ${c.ambar};
      --serp-rojo:     ${c.rojo};
      --serp-oliva:    ${c.oliva};
      --serp-cobre:    ${c.cobre};
      --serp-arena:    ${c.arena};
      --serp-oro-glow: rgba(${c.oro_rgb}, 0.15);
      --serp-rojo-bg:  rgba(${c.rojo_rgb}, 0.15);
    }
  '';

  xdg.configFile."matugen/defaults/colors-obsidian.css".text = ''
    body {
      --background-primary:          ${c.base};
      --background-primary-alt:      ${c.mantle};
      --background-secondary:        ${c.mantle};
      --background-secondary-alt:    ${c.crust};
      --background-modifier-border:  ${c.surface1};
      --background-modifier-form-field: ${c.surface0};
      --background-modifier-hover:   ${c.surface0};
      --background-modifier-success: ${c.oliva};
      --background-modifier-error:   ${c.rojo};
      --text-normal:                 ${c.text};
      --text-muted:                  ${c.subtext};
      --text-faint:                  ${c.arena};
      --text-accent:                 ${c.oro};
      --text-accent-hover:           ${c.ambar};
      --text-on-accent:              ${c.crust};
      --interactive-normal:          ${c.surface0};
      --interactive-hover:           ${c.surface1};
      --interactive-accent:          ${c.oro};
      --interactive-accent-hover:    ${c.ambar};
      --scrollbar-bg:                ${c.base};
      --scrollbar-thumb-bg:          ${c.surface1};
      --scrollbar-active-thumb-bg:   ${c.surface2};
      --titlebar-background:         ${c.crust};
      --titlebar-background-focused: ${c.mantle};
      --graph-line:                  ${c.arena};
      --graph-node:                  ${c.oro};
      --graph-node-focused:          ${c.ambar};
    }
  '';

  # ── Templates matugen (placeholders, sin cambios) ─────────────────────

  xdg.configFile."matugen/templates/hyprland.conf".text = ''
    $accent = rgb({{colors.primary.default.hex_stripped}})
    $accent2 = rgb({{colors.secondary.default.hex_stripped}})
    $bg = rgb({{colors.surface.default.hex_stripped}})
    $bg-surface = rgba({{colors.surface.default.hex_stripped}}99)
    $border = rgba({{colors.primary.default.hex_stripped}}66)
    $text = rgb({{colors.on_surface.default.hex_stripped}})
    $text-dim = rgb({{colors.on_surface_variant.default.hex_stripped}})
    $red = rgb({{colors.error.default.hex_stripped}})
    $green = rgb({{colors.tertiary.default.hex_stripped}})
    $yellow = rgb({{colors.secondary.default.hex_stripped}})
  '';

  xdg.configFile."matugen/templates/kitty.conf".text = ''
    foreground #{{colors.on_surface.default.hex_stripped}}
    background #{{colors.surface.default.hex_stripped}}
    cursor #{{colors.primary.default.hex_stripped}}
    cursor_text_color #{{colors.surface.default.hex_stripped}}
    selection_foreground #{{colors.on_surface.default.hex_stripped}}
    selection_background #{{colors.surface_container_high.default.hex_stripped}}
    url_color #{{colors.tertiary_container.default.hex_stripped}}
    active_tab_foreground #{{colors.surface.default.hex_stripped}}
    active_tab_background #{{colors.primary.default.hex_stripped}}
    inactive_tab_foreground #{{colors.surface_container_highest.default.hex_stripped}}
    inactive_tab_background #{{colors.surface_container_low.default.hex_stripped}}
    color0  #{{colors.surface.default.hex_stripped}}
    color1  #{{colors.error.default.hex_stripped}}
    color2  #{{colors.tertiary.default.hex_stripped}}
    color3  #{{colors.secondary.default.hex_stripped}}
    color4  #{{colors.primary.default.hex_stripped}}
    color5  #{{colors.primary_container.default.hex_stripped}}
    color6  #{{colors.tertiary_container.default.hex_stripped}}
    color7  #{{colors.on_surface.default.hex_stripped}}
    color8  #{{colors.on_surface_variant.default.hex_stripped}}
    color9  #{{colors.error.default.hex_stripped}}
    color10 #{{colors.tertiary.default.hex_stripped}}
    color11 #{{colors.secondary.default.hex_stripped}}
    color12 #{{colors.primary.default.hex_stripped}}
    color13 #{{colors.primary_container.default.hex_stripped}}
    color14 #{{colors.tertiary_container.default.hex_stripped}}
    color15 #{{colors.on_surface.default.hex_stripped}}
  '';

  xdg.configFile."matugen/templates/rofi.rasi".text = ''
    * {
        bg: rgba({{colors.surface.default.red}}, {{colors.surface.default.green}}, {{colors.surface.default.blue}}, 0.85);
        bg-alt: rgba({{colors.surface_container.default.red}}, {{colors.surface_container.default.green}}, {{colors.surface_container.default.blue}}, 0.9);
        fg: #{{colors.on_surface.default.hex_stripped}};
        fg-dim: #{{colors.on_surface_variant.default.hex_stripped}};
        accent: #{{colors.primary.default.hex_stripped}};
        accent-dim: rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.1);
        border-col: rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3);
        urgent: #{{colors.error.default.hex_stripped}};
    }
  '';

  xdg.configFile."matugen/templates/mako.conf".text = ''
    background-color=#{{colors.surface_container.default.hex_stripped}}E6
    text-color=#{{colors.on_surface.default.hex_stripped}}
    border-color=#{{colors.primary.default.hex_stripped}}4D
  '';

  xdg.configFile."matugen/templates/waybar.css".text = ''
    @define-color wb_base #{{colors.surface.default.hex_stripped}};
    @define-color wb_oro #{{colors.primary.default.hex_stripped}};
    @define-color wb_ambar #{{colors.secondary.default.hex_stripped}};
    @define-color wb_text #{{colors.on_surface.default.hex_stripped}};
    @define-color wb_oliva #{{colors.tertiary.default.hex_stripped}};
    @define-color wb_rojo #{{colors.error.default.hex_stripped}};
  '';

  xdg.configFile."matugen/templates/wlogout.css".text = ''
    @define-color wl_base #{{colors.surface.default.hex_stripped}};
    @define-color wl_mantle #{{colors.surface_container.default.hex_stripped}};
    @define-color wl_accent #{{colors.primary.default.hex_stripped}};
    @define-color wl_text #{{colors.on_surface.default.hex_stripped}};
  '';

  xdg.configFile."matugen/templates/starship.toml".text = ''

    [palettes.active]
    sp_oro = "#{{colors.primary.default.hex_stripped}}"
    sp_ambar = "#{{colors.secondary.default.hex_stripped}}"
    sp_arena = "#{{colors.tertiary_container.default.hex_stripped}}"
    sp_cobre = "#{{colors.primary_container.default.hex_stripped}}"
    sp_rojo = "#{{colors.error.default.hex_stripped}}"
    sp_oliva = "#{{colors.tertiary.default.hex_stripped}}"
    sp_subtext = "#{{colors.on_surface_variant.default.hex_stripped}}"
  '';

  xdg.configFile."matugen/templates/hyprlock.conf".text = ''
    $fg = rgba({{colors.on_surface.default.red}}, {{colors.on_surface.default.green}}, {{colors.on_surface.default.blue}}, 1.0)
    $fg-dim = rgba({{colors.on_surface_variant.default.red}}, {{colors.on_surface_variant.default.green}}, {{colors.on_surface_variant.default.blue}}, 1.0)
    $accent = rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3)
    $bg = rgba({{colors.surface.default.red}}, {{colors.surface.default.green}}, {{colors.surface.default.blue}}, 0.75)
    $green = rgba({{colors.tertiary.default.red}}, {{colors.tertiary.default.green}}, {{colors.tertiary.default.blue}}, 0.5)
    $red = rgba({{colors.error.default.red}}, {{colors.error.default.green}}, {{colors.error.default.blue}}, 0.5)
  '';

  xdg.configFile."matugen/templates/obsidian.css".text = ''
    body {
      --background-primary:          #{{colors.surface.default.hex_stripped}};
      --background-primary-alt:      #{{colors.surface_container_low.default.hex_stripped}};
      --background-secondary:        #{{colors.surface_container_low.default.hex_stripped}};
      --background-secondary-alt:    #{{colors.surface_dim.default.hex_stripped}};
      --background-modifier-border:  #{{colors.surface_container_high.default.hex_stripped}};
      --background-modifier-form-field: #{{colors.surface_container.default.hex_stripped}};
      --background-modifier-hover:   #{{colors.surface_container.default.hex_stripped}};
      --background-modifier-success: #{{colors.tertiary.default.hex_stripped}};
      --background-modifier-error:   #{{colors.error.default.hex_stripped}};
      --text-normal:                 #{{colors.on_surface.default.hex_stripped}};
      --text-muted:                  #{{colors.on_surface_variant.default.hex_stripped}};
      --text-faint:                  #{{colors.tertiary_container.default.hex_stripped}};
      --text-accent:                 #{{colors.primary.default.hex_stripped}};
      --text-accent-hover:           #{{colors.secondary.default.hex_stripped}};
      --text-on-accent:              #{{colors.surface_dim.default.hex_stripped}};
      --interactive-normal:          #{{colors.surface_container.default.hex_stripped}};
      --interactive-hover:           #{{colors.surface_container_high.default.hex_stripped}};
      --interactive-accent:          #{{colors.primary.default.hex_stripped}};
      --interactive-accent-hover:    #{{colors.secondary.default.hex_stripped}};
      --scrollbar-bg:                #{{colors.surface.default.hex_stripped}};
      --scrollbar-thumb-bg:          #{{colors.surface_container_high.default.hex_stripped}};
      --scrollbar-active-thumb-bg:   #{{colors.surface_container_highest.default.hex_stripped}};
      --titlebar-background:         #{{colors.surface_dim.default.hex_stripped}};
      --titlebar-background-focused: #{{colors.surface_container_low.default.hex_stripped}};
      --graph-line:                  #{{colors.tertiary_container.default.hex_stripped}};
      --graph-node:                  #{{colors.primary.default.hex_stripped}};
      --graph-node-focused:          #{{colors.secondary.default.hex_stripped}};
    }
  '';

  xdg.configFile."matugen/templates/zen.css".text = ''
    :root {
      --serp-crust:    #{{colors.surface_dim.default.hex_stripped}};
      --serp-mantle:   #{{colors.surface_container_low.default.hex_stripped}};
      --serp-base:     #{{colors.surface.default.hex_stripped}};
      --serp-surface0: #{{colors.surface_container.default.hex_stripped}};
      --serp-surface1: #{{colors.surface_container_high.default.hex_stripped}};
      --serp-surface2: #{{colors.surface_container_highest.default.hex_stripped}};
      --serp-text:     #{{colors.on_surface.default.hex_stripped}};
      --serp-subtext:  #{{colors.on_surface_variant.default.hex_stripped}};
      --serp-oro:      #{{colors.primary.default.hex_stripped}};
      --serp-ambar:    #{{colors.secondary.default.hex_stripped}};
      --serp-rojo:     #{{colors.error.default.hex_stripped}};
      --serp-oliva:    #{{colors.tertiary.default.hex_stripped}};
      --serp-cobre:    #{{colors.primary_container.default.hex_stripped}};
      --serp-arena:    #{{colors.tertiary_container.default.hex_stripped}};
      --serp-oro-glow: rgba({{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}, 0.15);
      --serp-rojo-bg:  rgba({{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}, 0.15);
    }
  '';

  xdg.configFile."matugen/templates/neovim.lua".text = ''
    return {
      rosewater = "#{{colors.on_surface.default.hex_stripped}}",
      flamingo  = "#{{colors.secondary.default.hex_stripped}}",
      pink      = "#{{colors.error.default.hex_stripped}}",
      mauve     = "#{{colors.primary.default.hex_stripped}}",
      red       = "#{{colors.error.default.hex_stripped}}",
      maroon    = "#{{colors.error_container.default.hex_stripped}}",
      peach     = "#{{colors.secondary.default.hex_stripped}}",
      yellow    = "#{{colors.primary.default.hex_stripped}}",
      green     = "#{{colors.tertiary.default.hex_stripped}}",
      teal      = "#{{colors.tertiary_container.default.hex_stripped}}",
      sky       = "#{{colors.tertiary_container.default.hex_stripped}}",
      sapphire  = "#{{colors.tertiary_container.default.hex_stripped}}",
      blue      = "#{{colors.primary_container.default.hex_stripped}}",
      lavender  = "#{{colors.primary.default.hex_stripped}}",
      text      = "#{{colors.on_surface.default.hex_stripped}}",
      subtext1  = "#{{colors.on_surface_variant.default.hex_stripped}}",
      subtext0  = "#{{colors.on_surface_variant.default.hex_stripped}}",
      overlay2  = "#{{colors.outline.default.hex_stripped}}",
      overlay1  = "#{{colors.outline.default.hex_stripped}}",
      overlay0  = "#{{colors.outline_variant.default.hex_stripped}}",
      surface2  = "#{{colors.surface_container_highest.default.hex_stripped}}",
      surface1  = "#{{colors.surface_container_high.default.hex_stripped}}",
      surface0  = "#{{colors.surface_container.default.hex_stripped}}",
      base      = "#{{colors.surface.default.hex_stripped}}",
      mantle    = "#{{colors.surface_container_low.default.hex_stripped}}",
      crust     = "#{{colors.surface_dim.default.hex_stripped}}",
    }
  '';

  xdg.configFile."matugen/templates/cava.conf".text = ''
    [color]
    gradient = 1
    gradient_count = 4
    gradient_color_1 = '#{{colors.primary.default.hex_stripped}}'
    gradient_color_2 = '#{{colors.secondary.default.hex_stripped}}'
    gradient_color_3 = '#{{colors.tertiary.default.hex_stripped}}'
    gradient_color_4 = '#{{colors.tertiary_container.default.hex_stripped}}'
  '';
}
