{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Navegador
    firefox

    # Comunicación
    discord
    telegram-desktop

    # Multimedia
    vlc
    spotify

    # Productividad
    obsidian
    libreoffice
    evince

    # Utilidades
    kdePackages.kcolorchooser
    kdePackages.kate

  ];

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
    };
  };
}
