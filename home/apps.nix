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
    loupe

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
        @import url("file://${config.home.homeDirectory}/.cache/matugen/colors-zen.css");

        :root {
          /* Variables Firefox */
          --lwt-accent-color: var(--serp-crust) !important;
          --lwt-text-color: var(--serp-text) !important;
          --toolbar-bgcolor: var(--serp-mantle) !important;
          --toolbar-color: var(--serp-text) !important;
          --toolbar-field-background-color: var(--serp-base) !important;
          --toolbar-field-color: var(--serp-text) !important;
          --toolbar-field-border-color: var(--serp-surface1) !important;
          --toolbar-field-focus-background-color: var(--serp-base) !important;
          --toolbar-field-focus-color: var(--serp-text) !important;
          --toolbar-field-focus-border-color: var(--serp-oro) !important;
          --tab-selected-bgcolor: var(--serp-base) !important;
          --tab-selected-textcolor: var(--serp-text) !important;
          --tab-loading-fill: var(--serp-oro) !important;
          --urlbar-box-bgcolor: var(--serp-surface0) !important;
          --urlbar-box-hover-bgcolor: var(--serp-surface1) !important;
          --urlbar-box-active-bgcolor: var(--serp-surface1) !important;
          --arrowpanel-background: var(--serp-surface0) !important;
          --arrowpanel-color: var(--serp-text) !important;
          --arrowpanel-border-color: var(--serp-surface1) !important;
          --sidebar-background-color: var(--serp-mantle) !important;
          --sidebar-text-color: var(--serp-text) !important;
          --chrome-content-separator-color: var(--serp-surface0) !important;
          --autocomplete-popup-background: var(--serp-surface0) !important;
          --autocomplete-popup-color: var(--serp-text) !important;
          --autocomplete-popup-highlight-background: var(--serp-surface1) !important;
          --autocomplete-popup-highlight-color: var(--serp-text) !important;
          --tab-icon-overlay-fill: var(--serp-text) !important;
          --tab-icon-overlay-stroke: var(--serp-crust) !important;
          --toolbarbutton-icon-fill: var(--serp-text) !important;
          --focus-outline-color: var(--serp-oro) !important;
          /* Variables Zen */
          --toolbox-bgcolor: var(--serp-mantle) !important;
          --toolbox-textcolor: var(--serp-text) !important;
          --zen-primary-color: var(--serp-crust) !important;
        }

        /* Fondos principales — Zen no hereda todas las variables */
        #navigator-toolbox { background: var(--serp-mantle) !important; }
        #TabsToolbar { background: var(--serp-crust) !important; }
        #nav-bar { background: var(--serp-mantle) !important; }
        #sidebar-box { background: var(--serp-mantle) !important; }

        /* Paneles y menús contextuales */
        menupopup, panel {
          --panel-background: var(--serp-surface0) !important;
          --panel-border-color: var(--serp-surface1) !important;
          --panel-color: var(--serp-text) !important;
        }
      '';

      userContent = ''
        @import url("file://${config.home.homeDirectory}/.cache/matugen/colors-zen.css");

        @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
          body {
            background-color: var(--serp-base) !important;
          }
        }

        @-moz-document url-prefix("about:") {
          :root {
            --in-content-page-background: var(--serp-base) !important;
            --in-content-page-color: var(--serp-text) !important;
            --in-content-box-background: var(--serp-surface0) !important;
            --in-content-box-border-color: var(--serp-surface1) !important;
            --in-content-primary-button-background: var(--serp-oro) !important;
            --in-content-primary-button-text-color: var(--serp-crust) !important;
            --in-content-focus-outline-color: var(--serp-oro) !important;
            --card-background-color: var(--serp-surface0) !important;
            --link-color: var(--serp-ambar) !important;
          }
        }
      '';
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = false;
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
