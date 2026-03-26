{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  # CSS overrides compartido entre GTK3 y GTK4
  gtkCss = ''
    /* ── Paleta Serpiente — GTK overrides ──────────────────────────── */

    /* Ventanas y fondos */
    window, .background { background-color: ${c.base}; color: ${c.text}; }

    /* Barras de título (headerbar) */
    headerbar { background-color: ${c.mantle}; color: ${c.text}; border-bottom: 1px solid ${c.surface0}; }
    headerbar:backdrop { background-color: ${c.crust}; }

    /* Botones */
    button { background-color: ${c.surface0}; color: ${c.text}; border: 1px solid ${c.surface1}; }
    button:hover { background-color: ${c.surface1}; }
    button:active, button:checked { background-color: ${c.surface2}; }
    button.suggested-action { background-color: ${c.oro}; color: ${c.crust}; }
    button.destructive-action { background-color: ${c.rojo}; color: ${c.text}; }

    /* Entradas de texto */
    entry { background-color: ${c.surface0}; color: ${c.text}; border: 1px solid ${c.surface1}; }
    entry:focus { border-color: ${c.oro}; }

    /* Listas y filas */
    row:selected { background-color: ${c.surface1}; }
    row:hover { background-color: ${c.surface0}; }

    /* Scrollbars */
    scrollbar slider { background-color: ${c.surface2}; }
    scrollbar slider:hover { background-color: ${c.overlay}; }

    /* Sidebar / navigation */
    .sidebar, .navigation-sidebar { background-color: ${c.mantle}; }
    .sidebar row:selected { background-color: ${c.surface1}; }

    /* Links */
    *:link, button.link { color: ${c.ambar}; }

    /* Tooltips */
    tooltip { background-color: ${c.surface0}; color: ${c.text}; border: 1px solid ${c.surface1}; }

    /* Check/Radio buttons accent */
    check, radio { color: ${c.oro}; }
    check:checked, radio:checked { background-color: ${c.oro}; color: ${c.crust}; }

    /* Switch */
    switch:checked { background-color: ${c.oro}; }

    /* Progress bars */
    progressbar progress { background-color: ${c.oro}; }

    /* Scales/sliders */
    scale highlight { background-color: ${c.oro}; }
  '';
in
{
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraCss = gtkCss;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraCss = gtkCss;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
