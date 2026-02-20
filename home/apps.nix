{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  home.packages = with pkgs; [
    discord
    telegram-desktop

    vlc

    obsidian
    libreoffice
    evince

    kdePackages.kcolorchooser
    kdePackages.kate
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "svg.context-properties.content.enabled" = true;
        "browser.tabs.drawInTitlebar" = true;
      };
      userChrome = ''
        :root {
          --malva-crust:    ${c.crust};
          --malva-mantle:   ${c.mantle};
          --malva-base:     ${c.base};
          --malva-surface0: ${c.surface0};
          --malva-surface1: ${c.surface1};
          --malva-surface2: ${c.surface2};
          --malva-text:     ${c.text};
          --malva-subtext:  ${c.subtext};
          --malva-malva:    ${c.malva};
          --malva-blue:     ${c.blue};
          --malva-cyan:     ${c.cyan};
          --malva-red:      ${c.red};
        }

        /* ─── Barra de herramientas ────────────────────────────────────── */
        #navigator-toolbox {
          background: var(--malva-mantle) !important;
          border-bottom: 1px solid var(--malva-surface0) !important;
        }

        /* ─── Barra de pestañas ────────────────────────────────────────── */
        #TabsToolbar {
          background: var(--malva-crust) !important;
        }

        .tab-background {
          border-radius: 6px 6px 0 0 !important;
          margin-block: 4px 0 !important;
        }

        .tabbrowser-tab[selected] .tab-background {
          background: var(--malva-base) !important;
          border-top: 2px solid var(--malva-malva) !important;
        }

        .tabbrowser-tab:not([selected]) .tab-background {
          background: transparent !important;
        }

        .tabbrowser-tab:not([selected]):hover .tab-background {
          background: var(--malva-surface0) !important;
        }

        .tab-text {
          color: var(--malva-subtext) !important;
        }

        .tabbrowser-tab[selected] .tab-text {
          color: var(--malva-text) !important;
        }

        /* ─── Barra de URL ─────────────────────────────────────────────── */
        #urlbar-background {
          background: var(--malva-base) !important;
          border: 1px solid var(--malva-surface1) !important;
          border-radius: 8px !important;
        }

        #urlbar:not([focused]) #urlbar-background {
          border-color: var(--malva-surface0) !important;
        }

        #urlbar[focused] #urlbar-background {
          border-color: var(--malva-malva) !important;
          box-shadow: 0 0 4px rgba(196, 167, 231, 0.15) !important;
        }

        #urlbar-input {
          color: var(--malva-text) !important;
        }

        /* ─── Sidebar ──────────────────────────────────────────────────── */
        #sidebar-box {
          background: var(--malva-mantle) !important;
        }

        /* ─── Findbar ──────────────────────────────────────────────────── */
        .browserContainer > findbar {
          background: var(--malva-mantle) !important;
          border-top: 1px solid var(--malva-surface0) !important;
          color: var(--malva-text) !important;
        }

        /* ─── Menú contextual ──────────────────────────────────────────── */
        menupopup {
          --panel-background: var(--malva-mantle) !important;
          --panel-border-color: var(--malva-surface1) !important;
          --panel-color: var(--malva-text) !important;
        }
      '';

      userContent = ''
        @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
          body {
            background-color: ${c.base} !important;
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
      completion-highlight-bg = c.malva;
      completion-highlight-fg = c.crust;
      highlight-color         = "rgba(196,167,231,0.3)";
      highlight-active-color  = "rgba(122,162,247,0.4)";
      recolor-lightcolor      = c.base;
      recolor-darkcolor       = c.text;
      notification-bg         = c.surface0;
      notification-fg         = c.text;
      notification-error-bg   = c.red;
      notification-error-fg   = c.crust;
      notification-warning-bg = c.yellow;
      notification-warning-fg = c.crust;
    };
  };
}
