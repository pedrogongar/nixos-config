{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  home.packages = with pkgs; [
    discord
    telegram-desktop
    zapzap

    vlc

    obsidian
    libreoffice
    evince

    kdePackages.kcolorchooser
    kdePackages.kate

    file-roller
    unzip
    p7zip
    unrar

    bruno
    wireshark
    solaar
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "svg.context-properties.content.enabled" = true;
        "browser.tabs.drawInTitlebar" = true;

        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
      };
      userChrome = ''
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

          --lwt-accent-color: ${c.crust} !important;
          --lwt-text-color: ${c.text} !important;
          --toolbar-bgcolor: ${c.mantle} !important;
          --toolbar-color: ${c.text} !important;
          --toolbar-field-background-color: ${c.base} !important;
          --toolbar-field-color: ${c.text} !important;
          --toolbar-field-border-color: ${c.surface1} !important;
          --toolbar-field-focus-background-color: ${c.base} !important;
          --toolbar-field-focus-color: ${c.text} !important;
          --toolbar-field-focus-border-color: ${c.oro} !important;
          --tab-selected-bgcolor: ${c.base} !important;
          --tab-selected-textcolor: ${c.text} !important;
          --tab-loading-fill: ${c.oro} !important;
          --urlbar-box-bgcolor: ${c.surface0} !important;
          --urlbar-box-hover-bgcolor: ${c.surface1} !important;
          --urlbar-box-active-bgcolor: ${c.surface1} !important;
          --arrowpanel-background: ${c.surface0} !important;
          --arrowpanel-color: ${c.text} !important;
          --arrowpanel-border-color: ${c.surface1} !important;
          --sidebar-background-color: ${c.mantle} !important;
          --sidebar-text-color: ${c.text} !important;
          --chrome-content-separator-color: ${c.surface0} !important;
          --autocomplete-popup-background: ${c.surface0} !important;
          --autocomplete-popup-color: ${c.text} !important;
          --autocomplete-popup-highlight-background: ${c.surface1} !important;
          --autocomplete-popup-highlight-color: ${c.text} !important;
          --tab-icon-overlay-fill: ${c.text} !important;
          --tab-icon-overlay-stroke: ${c.crust} !important;
          --toolbarbutton-icon-fill: ${c.text} !important;
          --focus-outline-color: ${c.oro} !important;
        }

        /* ─── Barra de herramientas ────────────────────────────────────── */
        #navigator-toolbox {
          background: var(--serp-mantle) !important;
          border-bottom: 1px solid var(--serp-surface0) !important;
        }

        /* ─── Barra de pestañas ────────────────────────────────────────── */
        #TabsToolbar {
          background: var(--serp-crust) !important;
        }

        .tab-background {
          border-radius: 6px 6px 0 0 !important;
          margin-block: 4px 0 !important;
        }

        .tabbrowser-tab[selected] .tab-background {
          background: var(--serp-base) !important;
          border-top: 2px solid var(--serp-oro) !important;
        }

        .tabbrowser-tab:not([selected]) .tab-background {
          background: transparent !important;
        }

        .tabbrowser-tab:not([selected]):hover .tab-background {
          background: var(--serp-surface0) !important;
        }

        .tab-text {
          color: var(--serp-subtext) !important;
        }

        .tabbrowser-tab[selected] .tab-text {
          color: var(--serp-text) !important;
        }

        /* ─── Barra de URL ─────────────────────────────────────────────── */
        #urlbar-background {
          background: var(--serp-base) !important;
          border: 1px solid var(--serp-surface1) !important;
          border-radius: 8px !important;
        }

        #urlbar:not([focused]) #urlbar-background {
          border-color: var(--serp-surface0) !important;
        }

        #urlbar[focused] #urlbar-background {
          border-color: var(--serp-oro) !important;
          box-shadow: 0 0 4px rgba(${c.oro_rgb}, 0.15) !important;
        }

        #urlbar-input {
          color: var(--serp-text) !important;
        }

        /* ─── Barra de marcadores ──────────────────────────────────────── */
        #PersonalToolbar {
          background: var(--serp-mantle) !important;
          color: var(--serp-subtext) !important;
          border-bottom: 1px solid var(--serp-surface0) !important;
        }

        #PlacesToolbarItems .bookmark-item {
          color: var(--serp-subtext) !important;
        }

        #PlacesToolbarItems .bookmark-item:hover {
          background: var(--serp-surface0) !important;
          color: var(--serp-text) !important;
        }

        /* ─── Botones toolbar ──────────────────────────────────────────── */
        #nav-bar {
          background: var(--serp-mantle) !important;
        }

        toolbarbutton:hover:not([disabled]) {
          background: var(--serp-surface0) !important;
        }

        /* ─── Botones nueva pestaña / cerrar ───────────────────────────── */
        .tabbrowser-tab .tab-close-button {
          color: var(--serp-subtext) !important;
        }

        .tabbrowser-tab .tab-close-button:hover {
          color: var(--serp-rojo) !important;
          background: rgba(${c.rojo_rgb}, 0.15) !important;
        }

        /* ─── Sidebar ──────────────────────────────────────────────────── */
        #sidebar-box {
          background: var(--serp-mantle) !important;
        }

        /* ─── Findbar ──────────────────────────────────────────────────── */
        .browserContainer > findbar {
          background: var(--serp-mantle) !important;
          border-top: 1px solid var(--serp-surface0) !important;
          color: var(--serp-text) !important;
        }

        /* ─── Menú contextual / paneles ────────────────────────────────── */
        menupopup,
        panel {
          --panel-background: var(--serp-surface0) !important;
          --panel-border-color: var(--serp-surface1) !important;
          --panel-color: var(--serp-text) !important;
        }

        menupopup > menuitem:hover,
        menupopup > menu:hover {
          background-color: var(--serp-surface1) !important;
          color: var(--serp-text) !important;
        }
      '';

      userContent = ''
        @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
          body {
            background-color: ${c.base} !important;
          }
        }

        @-moz-document url-prefix("about:") {
          :root {
            --in-content-page-background: ${c.base} !important;
            --in-content-page-color: ${c.text} !important;
            --in-content-box-background: ${c.surface0} !important;
            --in-content-box-border-color: ${c.surface1} !important;
            --in-content-primary-button-background: ${c.oro} !important;
            --in-content-primary-button-text-color: ${c.crust} !important;
            --in-content-focus-outline-color: ${c.oro} !important;
            --card-background-color: ${c.surface0} !important;
            --link-color: ${c.ambar} !important;
          }
        }
      '';
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
      default-bg              = c.base;
      default-fg              = c.text;
      statusbar-bg            = c.mantle;
      statusbar-fg            = c.text;
      inputbar-bg             = c.mantle;
      inputbar-fg             = c.text;
      completion-bg           = c.surface0;
      completion-fg           = c.text;
      completion-highlight-bg = c.oro;
      completion-highlight-fg = c.crust;
      highlight-color         = "rgba(${c.oro_rgb},0.3)";
      highlight-active-color  = "rgba(${c.ambar_rgb},0.4)";
      recolor-lightcolor      = c.base;
      recolor-darkcolor       = c.text;
      notification-bg         = c.surface0;
      notification-fg         = c.text;
      notification-error-bg   = c.rojo;
      notification-error-fg   = c.crust;
      notification-warning-bg = c.ambar;
      notification-warning-fg = c.crust;
    };
  };
}
