{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  rofiTheme = pkgs.writeText "serpiente.rasi" ''
    * {
        bg:           rgba(${c.base_rgb}, 0.92);
        bg-alt:       rgba(${c.mantle_rgb}, 0.98);
        fg:           ${c.text};
        fg-dim:       ${c.subtext};
        accent:       ${c.oro};
        border-col:   rgba(${c.oro_rgb}, 0.2);
        urgent:       ${c.rojo};

        font: "JetBrains Mono Nerd Font 12";

        background-color: transparent;
        text-color: @fg;
    }

    window {
        width: 500px;
        padding: 0;
        border: 1px solid;
        border-color: @border-col;
        border-radius: 10px;
        background-color: @bg;
    }

    mainbox {
        spacing: 0;
        children: [ inputbar, listview ];
    }

    inputbar {
        padding: 14px 18px;
        spacing: 12px;
        border: 0 0 1px 0;
        border-color: @border-col;
        children: [ prompt, entry ];
    }

    prompt {
        font: "JetBrains Mono Nerd Font 13";
        text-color: @accent;
    }

    entry {
        placeholder: "buscar...";
        placeholder-color: @fg-dim;
        font: "JetBrains Mono Nerd Font 12";
    }

    listview {
        lines: 7;
        padding: 8px;
        spacing: 2px;
        fixed-height: true;
        scrollbar: false;
    }

    element {
        padding: 10px 14px;
        spacing: 14px;
        border-radius: 6px;
    }

    element selected.normal {
        background-color: rgba(${c.oro_rgb}, 0.1);
        border: 0 0 0 2px;
        border-color: @accent;
    }

    element-icon {
        size: 28px;
    }

    element-text {
        font: "JetBrains Mono Nerd Font 12";
        vertical-align: 0.5;
    }

    element-text selected {
        text-color: @fg;
    }
  '';
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    theme = "${rofiTheme}";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "";
      drun-display-format = "{name}";
      disable-history = false;
      sorting-method = "fzf";
    };
  };
}
