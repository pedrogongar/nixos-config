{ config, pkgs, ... }:

{
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."fastfetch/nixos-ascii".source  = ./fastfetch/nixos-ascii;
  xdg.configFile."fastfetch/fastfetch-bienvenida.sh" = {
    source     = ./fastfetch/fastfetch-bienvenida.sh;
    executable = true;
  };
}
