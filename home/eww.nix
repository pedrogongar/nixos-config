{ config, pkgs, ... }:

{
  programs.eww = {
    enable    = true;
    configDir = ./eww;
  };

  xdg.configFile."eww/scripts/red-icono.sh" = {
    source     = ./eww/scripts/red-icono.sh;
    executable = true;
  };

  xdg.configFile."eww/scripts/musica-progreso.sh" = {
    source     = ./eww/scripts/musica-progreso.sh;
    executable = true;
  };
}
