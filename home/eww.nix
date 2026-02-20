{ config, pkgs, ... }:

{
  programs.eww = {
    enable    = true;
    configDir = ./eww;
  };

  xdg.configFile."eww/scripts/musica-progreso.sh" = {
    source     = ./eww/scripts/musica-progreso.sh;
    executable = true;
  };

  xdg.configFile."eww/scripts/pomodoro.sh" = {
    source     = ./eww/scripts/pomodoro.sh;
    executable = true;
  };
}
