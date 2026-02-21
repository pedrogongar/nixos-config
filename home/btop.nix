{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "serpiente";
      theme_background = false;
      truecolor = true;
      rounded_corners = true;
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_tree = false;
    };
  };

  xdg.configFile."btop/themes/serpiente.theme".text = ''
    theme[main_bg]="${c.base}"
    theme[main_fg]="${c.text}"
    theme[title]="${c.text}"
    theme[hi_fg]="${c.oro}"
    theme[selected_bg]="${c.surface0}"
    theme[selected_fg]="${c.text}"
    theme[inactive_fg]="${c.surface2}"
    theme[proc_misc]="${c.ambar}"
    theme[cpu_box]="${c.oro}"
    theme[mem_box]="${c.ambar}"
    theme[net_box]="${c.ambar}"
    theme[proc_box]="${c.arena}"
    theme[div_line]="${c.surface2}"
    theme[temp_start]="${c.oro}"
    theme[temp_mid]="${c.ambar}"
    theme[temp_end]="${c.rojo}"
    theme[cpu_start]="${c.oro}"
    theme[cpu_mid]="${c.ambar}"
    theme[cpu_end]="${c.rojo}"
    theme[free_start]="${c.oro}"
    theme[free_mid]="${c.ambar}"
    theme[free_end]="${c.rojo}"
    theme[cached_start]="${c.ambar}"
    theme[cached_mid]="${c.oro}"
    theme[cached_end]="${c.rojo}"
    theme[available_start]="${c.oro}"
    theme[available_mid]="${c.ambar}"
    theme[available_end]="${c.sangre}"
    theme[used_start]="${c.ambar}"
    theme[used_mid]="${c.rojo}"
    theme[used_end]="${c.sangre}"
    theme[download_start]="${c.oro}"
    theme[download_mid]="${c.ambar}"
    theme[download_end]="${c.rojo}"
    theme[upload_start]="${c.text}"
    theme[upload_mid]="${c.ambar}"
    theme[upload_end]="${c.rojo}"
  '';
}
