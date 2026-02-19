{ config, pkgs, ... }:

{
  xdg.configFile = {
    "swaync/config.json".source = ./swaync/config.json;
    "swaync/style.css".source = ./swaync/style.css;
  };
}
