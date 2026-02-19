{ config, pkgs, ... }:

let
  applyTheme = pkgs.writeShellScriptBin "apply-theme" ''
    WALLPAPER="$1"
    TEMPLATES="$HOME/.config/matugen/templates"
    OUTPUT="$HOME/.cache/matugen"

    if [ -z "$WALLPAPER" ]; then
      echo "Uso: apply-theme /ruta/al/wallpaper.jpg"
      exit 1
    fi

    mkdir -p "$OUTPUT"

    ${pkgs.matugen}/bin/matugen image "$WALLPAPER" \
      --config "$HOME/.config/matugen/config.toml"

    # Aplicar wallpaper
    ${pkgs.swww}/bin/swww img "$WALLPAPER" \
      --transition-type grow \
      --transition-duration 2

    # Recargar componentes
    hyprctl reload
    eww reload
    swaync-client -rs

    # Guardar wallpaper actual
    echo "$WALLPAPER" > "$HOME/.cache/matugen/current-wallpaper"

    echo "✓ Tema aplicado desde: $WALLPAPER"
  '';

  defaultTheme = pkgs.writeShellScriptBin "default-theme" ''
    DEFAULTS="$HOME/.config/matugen/defaults"
    OUTPUT="$HOME/.cache/matugen"

    mkdir -p "$OUTPUT"

    cp "$DEFAULTS/colors-hyprland.conf" "$OUTPUT/colors-hyprland.conf"
    cp "$DEFAULTS/colors-eww.scss" "$OUTPUT/colors-eww.scss"
    cp "$DEFAULTS/colors-kitty.conf" "$OUTPUT/colors-kitty.conf"
    cp "$DEFAULTS/colors-rofi.rasi" "$OUTPUT/colors-rofi.rasi"
    cp "$DEFAULTS/colors-swaync.css" "$OUTPUT/colors-swaync.css"
    cp "$DEFAULTS/colors-hyprlock.conf" "$OUTPUT/colors-hyprlock.conf"
    cp "$DEFAULTS/colors-cava.conf" "$OUTPUT/colors-cava.conf"
    cp "$DEFAULTS/colors-btop.theme" "$OUTPUT/colors-btop.theme"

    hyprctl reload 2>/dev/null
    eww reload 2>/dev/null
    swaync-client -rs 2>/dev/null

    echo "✓ Paleta default aplicada"
  '';

in
{
  home.packages = [ applyTheme defaultTheme ];

  # Config de Matugen
  xdg.configFile."matugen/config.toml".text = ''
    [config]
    type = "scheme-tonal-spot"
    [templates]
    [templates.hyprland]
    input_path = "~/.config/matugen/templates/hyprland.conf"
    output_path = "~/.cache/matugen/colors-hyprland.conf"
    [templates.eww]
    input_path = "~/.config/matugen/templates/eww.scss"
    output_path = "~/.cache/matugen/colors-eww.scss"
    [templates.kitty]
    input_path = "~/.config/matugen/templates/kitty.conf"
    output_path = "~/.cache/matugen/colors-kitty.conf"
    [templates.rofi]
    input_path = "~/.config/matugen/templates/rofi.rasi"
    output_path = "~/.cache/matugen/colors-rofi.rasi"
    [templates.swaync]
    input_path = "~/.config/matugen/templates/swaync.css"
    output_path = "~/.cache/matugen/colors-swaync.css"
    [templates.hyprlock]
    input_path = "~/.config/matugen/templates/hyprlock.conf"
    output_path = "~/.cache/matugen/colors-hyprlock.conf"
    [templates.cava]
    input_path = "~/.config/matugen/templates/cava.conf"
    output_path = "~/.cache/matugen/colors-cava.conf"
    [templates.btop]
    input_path = "~/.config/matugen/templates/btop.theme"
    output_path = "~/.cache/matugen/colors-btop.theme"
  '';

  # Paleta default (malva del mockup)
  xdg.configFile."matugen/defaults/colors-hyprland.conf".text = ''
    $accent = rgb(c4a7e7)
    $accent2 = rgb(8aadf4)
    $bg = rgb(1a1b26)
    $bg-surface = rgba(1a1b2699)
    $border = rgba(c4a7e766)
    $text = rgb(c0caf5)
    $text-dim = rgb(565f89)
    $red = rgb(ed8796)
    $green = rgb(a6da95)
    $yellow = rgb(e0af68)
  '';

  xdg.configFile."matugen/defaults/colors-eww.scss".text = ''
    $bg: rgba(26, 27, 38, 0.75);
    $bg-widget: rgba(36, 37, 52, 0.70);
    $bg-hover: rgba(196, 167, 231, 0.1);
    $border: rgba(196, 167, 231, 0.3);
    $text: #c0caf5;
    $text-dim: #565f89;
    $text-bright: #e0e4ff;
    $accent1: #c4a7e7;
    $accent2: #8aadf4;
    $accent3: #a6da95;
    $accent4: #f0c6c6;
    $accent5: #8bd5ca;
    $red: #ed8796;
    $radius: 14px;
    $radius-sm: 8px;
  '';

  xdg.configFile."matugen/defaults/colors-kitty.conf".text = ''
    foreground #c0caf5
    background #1a1b26
    selection_foreground #c0caf5
    selection_background #33467c
    color0 #15161e
    color1 #f7768e
    color2 #9ece6a
    color3 #e0af68
    color4 #7aa2f7
    color5 #bb9af7
    color6 #7dcfff
    color7 #a9b1d6
    color8 #414868
    color9 #f7768e
    color10 #9ece6a
    color11 #e0af68
    color12 #7aa2f7
    color13 #bb9af7
    color14 #7dcfff
    color15 #c0caf5
  '';

  xdg.configFile."matugen/defaults/colors-rofi.rasi".text = ''
    * {
        bg: rgba(26, 27, 38, 0.85);
        bg-alt: rgba(36, 37, 52, 0.9);
        fg: #c0caf5;
        fg-dim: #565f89;
        accent: #c4a7e7;
        border-col: rgba(196, 167, 231, 0.3);
        urgent: #ed8796;
    }
  '';

  xdg.configFile."matugen/defaults/colors-swaync.css".text = ''
    @define-color bg rgba(26, 27, 38, 0.85);
    @define-color bg-alt rgba(36, 37, 52, 0.9);
    @define-color border rgba(196, 167, 231, 0.3);
    @define-color text #c0caf5;
    @define-color text-dim #565f89;
    @define-color accent #c4a7e7;
    @define-color urgent #ed8796;
  '';

  xdg.configFile."matugen/defaults/colors-hyprlock.conf".text = ''
    $fg = rgba(192, 202, 245, 1.0)
    $fg-dim = rgba(86, 95, 137, 1.0)
    $accent = rgba(196, 167, 231, 0.3)
    $bg = rgba(26, 27, 38, 0.75)
    $green = rgba(166, 218, 149, 0.5)
    $red = rgba(237, 135, 150, 0.5)
  '';

  xdg.configFile."matugen/defaults/colors-cava.conf".text = ''
    [color]
    gradient = 1
    gradient_count = 4
    gradient_color_1 = '#8aadf4'
    gradient_color_2 = '#c4a7e7'
    gradient_color_3 = '#8bd5ca'
    gradient_color_4 = '#a6da95'
  '';

  xdg.configFile."matugen/defaults/colors-btop.theme".text = ''
    theme[main_bg]="#1a1b26"
    theme[main_fg]="#c0caf5"
    theme[title]="#c0caf5"
    theme[hi_fg]="#c4a7e7"
    theme[selected_bg]="#33467c"
    theme[selected_fg]="#c0caf5"
    theme[inactive_fg]="#565f89"
    theme[proc_misc]="#8aadf4"
    theme[cpu_box]="#c4a7e7"
    theme[mem_box]="#8aadf4"
    theme[net_box]="#a6da95"
    theme[proc_box]="#8bd5ca"
    theme[div_line]="#565f89"
    theme[temp_start]="#8aadf4"
    theme[temp_mid]="#e0af68"
    theme[temp_end]="#ed8796"
    theme[cpu_start]="#c4a7e7"
    theme[cpu_mid]="#8aadf4"
    theme[cpu_end]="#8bd5ca"
    theme[free_start]="#a6da95"
    theme[free_mid]="#8aadf4"
    theme[free_end]="#c4a7e7"
    theme[cached_start]="#8bd5ca"
    theme[cached_mid]="#8aadf4"
    theme[cached_end]="#c4a7e7"
    theme[available_start]="#a6da95"
    theme[available_mid]="#8aadf4"
    theme[available_end]="#c4a7e7"
    theme[used_start]="#c4a7e7"
    theme[used_mid]="#8aadf4"
    theme[used_end]="#ed8796"
    theme[download_start]="#a6da95"
    theme[download_mid]="#8aadf4"
    theme[download_end]="#c4a7e7"
    theme[upload_start]="#f0c6c6"
    theme[upload_mid]="#c4a7e7"
    theme[upload_end]="#8aadf4"
  '';

  # Templates para Matugen (usa {{variables}} que Matugen reemplaza)
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

  xdg.configFile."matugen/templates/eww.scss".text = ''
    $bg: rgba({{colors.surface.default.red}}, {{colors.surface.default.green}}, {{colors.surface.default.blue}}, 0.75);
    $bg-widget: rgba({{colors.surface_container.default.red}}, {{colors.surface_container.default.green}}, {{colors.surface_container.default.blue}}, 0.70);
    $bg-hover: rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.1);
    $border: rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3);
    $text: #{{colors.on_surface.default.hex_stripped}};
    $text-dim: #{{colors.on_surface_variant.default.hex_stripped}};
    $text-bright: #{{colors.on_surface.default.hex_stripped}};
    $accent1: #{{colors.primary.default.hex_stripped}};
    $accent2: #{{colors.secondary.default.hex_stripped}};
    $accent3: #{{colors.tertiary.default.hex_stripped}};
    $accent4: #{{colors.error.default.hex_stripped}};
    $accent5: #{{colors.tertiary_container.default.hex_stripped}};
    $red: #{{colors.error.default.hex_stripped}};
    $radius: 14px;
    $radius-sm: 8px;
  '';

  xdg.configFile."matugen/templates/kitty.conf".text = ''
    foreground #{{colors.on_surface.default.hex_stripped}}
    background #{{colors.surface.default.hex_stripped}}
    selection_foreground #{{colors.on_surface.default.hex_stripped}}
    selection_background #{{colors.surface_container_high.default.hex_stripped}}
    color0 #{{colors.surface.default.hex_stripped}}
    color1 #{{colors.error.default.hex_stripped}}
    color2 #{{colors.tertiary.default.hex_stripped}}
    color3 #{{colors.secondary.default.hex_stripped}}
    color4 #{{colors.primary.default.hex_stripped}}
    color5 #{{colors.primary_container.default.hex_stripped}}
    color6 #{{colors.tertiary_container.default.hex_stripped}}
    color7 #{{colors.on_surface.default.hex_stripped}}
    color8 #{{colors.on_surface_variant.default.hex_stripped}}
    color9 #{{colors.error.default.hex_stripped}}
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

  xdg.configFile."matugen/templates/swaync.css".text = ''
    @define-color bg rgba({{colors.surface.default.red}}, {{colors.surface.default.green}}, {{colors.surface.default.blue}}, 0.85);
    @define-color bg-alt rgba({{colors.surface_container.default.red}}, {{colors.surface_container.default.green}}, {{colors.surface_container.default.blue}}, 0.9);
    @define-color border rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.3);
    @define-color text #{{colors.on_surface.default.hex_stripped}};
    @define-color text-dim #{{colors.on_surface_variant.default.hex_stripped}};
    @define-color accent #{{colors.primary.default.hex_stripped}};
    @define-color urgent #{{colors.error.default.hex_stripped}};
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

  xdg.configFile."matugen/templates/btop.theme".text = ''
    theme[main_bg]="#{{colors.surface.default.hex_stripped}}"
    theme[main_fg]="#{{colors.on_surface.default.hex_stripped}}"
    theme[title]="#{{colors.on_surface.default.hex_stripped}}"
    theme[hi_fg]="#{{colors.primary.default.hex_stripped}}"
    theme[selected_bg]="#{{colors.surface_container_high.default.hex_stripped}}"
    theme[selected_fg]="#{{colors.on_surface.default.hex_stripped}}"
    theme[inactive_fg]="#{{colors.on_surface_variant.default.hex_stripped}}"
    theme[proc_misc]="#{{colors.secondary.default.hex_stripped}}"
    theme[cpu_box]="#{{colors.primary.default.hex_stripped}}"
    theme[mem_box]="#{{colors.secondary.default.hex_stripped}}"
    theme[net_box]="#{{colors.tertiary.default.hex_stripped}}"
    theme[proc_box]="#{{colors.tertiary_container.default.hex_stripped}}"
    theme[div_line]="#{{colors.on_surface_variant.default.hex_stripped}}"
    theme[temp_start]="#{{colors.secondary.default.hex_stripped}}"
    theme[temp_mid]="#{{colors.primary.default.hex_stripped}}"
    theme[temp_end]="#{{colors.error.default.hex_stripped}}"
    theme[cpu_start]="#{{colors.primary.default.hex_stripped}}"
    theme[cpu_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[cpu_end]="#{{colors.tertiary.default.hex_stripped}}"
    theme[free_start]="#{{colors.tertiary.default.hex_stripped}}"
    theme[free_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[free_end]="#{{colors.primary.default.hex_stripped}}"
    theme[cached_start]="#{{colors.tertiary_container.default.hex_stripped}}"
    theme[cached_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[cached_end]="#{{colors.primary.default.hex_stripped}}"
    theme[available_start]="#{{colors.tertiary.default.hex_stripped}}"
    theme[available_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[available_end]="#{{colors.primary.default.hex_stripped}}"
    theme[used_start]="#{{colors.primary.default.hex_stripped}}"
    theme[used_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[used_end]="#{{colors.error.default.hex_stripped}}"
    theme[download_start]="#{{colors.tertiary.default.hex_stripped}}"
    theme[download_mid]="#{{colors.secondary.default.hex_stripped}}"
    theme[download_end]="#{{colors.primary.default.hex_stripped}}"
    theme[upload_start]="#{{colors.error.default.hex_stripped}}"
    theme[upload_mid]="#{{colors.primary.default.hex_stripped}}"
    theme[upload_end]="#{{colors.secondary.default.hex_stripped}}"
  '';
}
