{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrains Mono Nerd Font 12";
      background-color = "${c.mantle}FA";
      text-color = "${c.text}";
      border-color = "${c.oro}2E";
      border-size = 1;
      border-radius = 8;
      padding = "12";
      margin = "8";
      width = 380;
      max-visible = 3;
      default-timeout = 6000;
      layer = "overlay";
      anchor = "top-right";
      max-icon-size = 48;
      icon-path = "";

      "urgency=low" = {
        default-timeout = 4000;
      };

      "urgency=critical" = {
        default-timeout = 0;
        border-color = "${c.rojo}";
      };
    };
  };
}
