{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    theme = ./rofi/theme.rasi;
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
