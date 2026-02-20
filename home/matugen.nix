{ config, pkgs, ... }:

let
  c = import ./colores.nix;

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
    swaync-client -rs
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
    cp "$DEFAULTS/colors-swaync.css"    "$OUTPUT/colors-swaync.css"
    cp "$DEFAULTS/colors-hyprlock.conf" "$OUTPUT/colors-hyprlock.conf"
    cp "$DEFAULTS/colors-cava.conf"     "$OUTPUT/colors-cava.conf"
    cp "$DEFAULTS/colors-btop.theme"    "$OUTPUT/colors-btop.theme"

    hyprctl reload 2>/dev/null
    swaync-client -rs 2>/dev/null
    pkill -SIGUSR2 waybar 2>/dev/null

    echo "✓ Paleta Malva Night aplicada"
  '';

in
{
  home.packages = [ applyTheme defaultTheme ];

  home.file.".config/btop/themes/malva-night.theme".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.cache/matugen/colors-btop.theme";

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

  # ── Defaults Malva Night ──────────────────────────────────────────────

  xdg.configFile."matugen/defaults/colors-hyprland.conf".text = ''
    $accent = rgb(c4a7e7)
    $accent2 = rgb(7aa2f7)
    $bg = rgb(1a1b26)
    $bg-surface = rgba(1a1b2699)
    $border = rgba(c4a7e766)
    $text = rgb(c0caf5)
    $text-dim = rgb(565f89)
    $red = rgb(f38ba8)
    $green = rgb(a6e3a1)
    $yellow = rgb(f9e2af)
  '';

  xdg.configFile."matugen/defaults/colors-kitty.conf".text = ''
    foreground ${c.text}
    background ${c.base}
    selection_foreground ${c.text}
    selection_background ${c.surface0}
    color0  ${c.crust}
    color1  ${c.red}
    color2  ${c.green}
    color3  ${c.yellow}
    color4  ${c.blue}
    color5  ${c.malva}
    color6  ${c.cyan}
    color7  ${c.subtext}
    color8  ${c.surface2}
    color9  ${c.red}
    color10 ${c.green}
    color11 ${c.yellow}
    color12 ${c.blue}
    color13 ${c.fuchsia}
    color14 ${c.teal}
    color15 ${c.text}
  '';

  xdg.configFile."matugen/defaults/colors-rofi.rasi".text = ''
    * {
        bg: rgba(22, 22, 30, 0.92);
        bg-alt: rgba(26, 27, 38, 0.98);
        fg: ${c.text};
        fg-dim: ${c.surface2};
        accent: ${c.malva};
        border-col: rgba(196, 167, 231, 0.2);
        urgent: ${c.red};
    }
  '';

  xdg.configFile."matugen/defaults/colors-swaync.css".text = ''
    @define-color bg rgba(22, 22, 30, 0.92);
    @define-color bg-alt rgba(26, 27, 38, 0.98);
    @define-color border rgba(196, 167, 231, 0.18);
    @define-color text ${c.text};
    @define-color text-dim ${c.surface2};
    @define-color accent ${c.malva};
    @define-color urgent ${c.red};
  '';

  xdg.configFile."matugen/defaults/colors-hyprlock.conf".text = ''
    $fg = rgba(192, 202, 245, 1.0)
    $fg-dim = rgba(86, 95, 137, 1.0)
    $accent = rgba(196, 167, 231, 0.3)
    $bg = rgba(26, 27, 38, 0.75)
    $green = rgba(166, 227, 161, 0.5)
    $red = rgba(243, 139, 168, 0.5)
  '';

  xdg.configFile."matugen/defaults/colors-cava.conf".text = ''
    [color]
    gradient = 1
    gradient_count = 4
    gradient_color_1 = '${c.malva}'
    gradient_color_2 = '${c.blue}'
    gradient_color_3 = '${c.teal}'
    gradient_color_4 = '${c.green}'
  '';

  xdg.configFile."matugen/defaults/colors-btop.theme".text = ''
    theme[main_bg]="${c.base}"
    theme[main_fg]="${c.text}"
    theme[title]="${c.text}"
    theme[hi_fg]="${c.malva}"
    theme[selected_bg]="${c.surface0}"
    theme[selected_fg]="${c.text}"
    theme[inactive_fg]="${c.surface2}"
    theme[proc_misc]="${c.blue}"
    theme[cpu_box]="${c.malva}"
    theme[mem_box]="${c.blue}"
    theme[net_box]="${c.green}"
    theme[proc_box]="${c.teal}"
    theme[div_line]="${c.surface2}"
    theme[temp_start]="${c.blue}"
    theme[temp_mid]="${c.yellow}"
    theme[temp_end]="${c.red}"
    theme[cpu_start]="${c.malva}"
    theme[cpu_mid]="${c.blue}"
    theme[cpu_end]="${c.teal}"
    theme[free_start]="${c.green}"
    theme[free_mid]="${c.blue}"
    theme[free_end]="${c.malva}"
    theme[cached_start]="${c.teal}"
    theme[cached_mid]="${c.blue}"
    theme[cached_end]="${c.malva}"
    theme[available_start]="${c.green}"
    theme[available_mid]="${c.blue}"
    theme[available_end]="${c.malva}"
    theme[used_start]="${c.malva}"
    theme[used_mid]="${c.blue}"
    theme[used_end]="${c.red}"
    theme[download_start]="${c.green}"
    theme[download_mid]="${c.blue}"
    theme[download_end]="${c.malva}"
    theme[upload_start]="${c.rosewater}"
    theme[upload_mid]="${c.malva}"
    theme[upload_end]="${c.blue}"
  '';

  # ── Templates matugen (sin cambios) ───────────────────────────────────

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
