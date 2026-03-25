{ config, pkgs, ... }:

let
  c = import ./colores.nix;
  strip = s: builtins.substring 1 6 s;

  applyTheme = pkgs.writeShellScriptBin "apply-theme" ''
    WALLPAPER="$1"

    if [ -z "$WALLPAPER" ]; then
      echo "Uso: apply-theme /ruta/al/wallpaper.jpg"
      exit 1
    fi

    mkdir -p "$HOME/.cache/matugen"

    ${pkgs.matugen}/bin/matugen image "$WALLPAPER" \
      --config "$HOME/.config/matugen/config.toml"

    ${pkgs.swww}/bin/swww img "$WALLPAPER" \
      --transition-type grow \
      --transition-duration 2

    hyprctl reload
    makoctl reload 2>/dev/null
    pkill -SIGUSR2 waybar

    echo "$WALLPAPER" > "$HOME/.cache/matugen/current-wallpaper"
    echo "✓ Tema aplicado desde: $WALLPAPER"
  '';

  defaultTheme = pkgs.writeShellScriptBin "default-theme" ''
    DEFAULTS="$HOME/.config/matugen/defaults"
    OUTPUT="$HOME/.cache/matugen"

    mkdir -p "$OUTPUT"

    cp "$DEFAULTS/colors-hyprland.conf" "$OUTPUT/colors-hyprland.conf"
    cp "$DEFAULTS/colors-kitty.conf"    "$OUTPUT/colors-kitty.conf"
    cp "$DEFAULTS/colors-rofi.rasi"     "$OUTPUT/colors-rofi.rasi"
    cp "$DEFAULTS/colors-mako.conf"     "$OUTPUT/colors-mako.conf"
    cp "$DEFAULTS/colors-hyprlock.conf" "$OUTPUT/colors-hyprlock.conf"
    cp "$DEFAULTS/colors-cava.conf"     "$OUTPUT/colors-cava.conf"

    hyprctl reload 2>/dev/null
    makoctl reload 2>/dev/null
    pkill -SIGUSR2 waybar 2>/dev/null

    echo "✓ Paleta Serpiente aplicada"
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
    [templates.hyprlock]
    input_path = "~/.config/matugen/templates/hyprlock.conf"
    output_path = "~/.cache/matugen/colors-hyprlock.conf"
    [templates.cava]
    input_path = "~/.config/matugen/templates/cava.conf"
    output_path = "~/.cache/matugen/colors-cava.conf"
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
    selection_foreground ${c.text}
    selection_background ${c.surface0}
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
        border-col: rgba(${c.oro_rgb}, 0.2);
        urgent: ${c.rojo};
    }
  '';

  xdg.configFile."matugen/defaults/colors-mako.conf".text = ''
    background-color=${c.mantle}FA
    text-color=${c.text}
    border-color=${c.oro}2E
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
    selection_foreground #{{colors.on_surface.default.hex_stripped}}
    selection_background #{{colors.surface_container_high.default.hex_stripped}}
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
        border-col: rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3);
        urgent: #{{colors.error.default.hex_stripped}};
    }
  '';

  xdg.configFile."matugen/templates/mako.conf".text = ''
    background-color=#{{colors.surface_container.default.hex_stripped}}E6
    text-color=#{{colors.on_surface.default.hex_stripped}}
    border-color=#{{colors.primary.default.hex_stripped}}4D
  '';

  xdg.configFile."matugen/templates/hyprlock.conf".text = ''
    $fg = rgba({{colors.on_surface.default.red}}, {{colors.on_surface.default.green}}, {{colors.on_surface.default.blue}}, 1.0)
    $fg-dim = rgba({{colors.on_surface_variant.default.red}}, {{colors.on_surface_variant.default.green}}, {{colors.on_surface_variant.default.blue}}, 1.0)
    $accent = rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3)
    $bg = rgba({{colors.surface.default.red}}, {{colors.surface.default.green}}, {{colors.surface.default.blue}}, 0.75)
    $green = rgba({{colors.tertiary.default.red}}, {{colors.tertiary.default.green}}, {{colors.tertiary.default.blue}}, 0.5)
    $red = rgba({{colors.error.default.red}}, {{colors.error.default.green}}, {{colors.error.default.blue}}, 0.5)
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
