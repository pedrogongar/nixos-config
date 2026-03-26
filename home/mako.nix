{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  # ── Colores (se definen una vez, se reutilizan en defaults + config inicial) ──
  makoColors = ''
    background-color=${c.mantle}FA
    text-color=${c.text}
    border-color=${c.oro}2E
  '';

  # ── Estructura (sin colores, se combina con cat) ──
  makoBase = ''
    font=JetBrains Mono Nerd Font 12
    border-size=1
    border-radius=8
    padding=12
    margin=8
    width=380
    max-visible=3
    default-timeout=6000
    layer=overlay
    anchor=top-right
    max-icon-size=48
    icon-path=

    [urgency=low]
    default-timeout=4000

    [urgency=critical]
    default-timeout=0
    border-color=${c.rojo}
  '';

in
{
  # Config inicial = colores Serpiente + base (force=true permite sobreescritura por scripts)
  xdg.configFile."mako/config" = {
    text = makoColors + makoBase;
    force = true;
  };
  xdg.configFile."mako/config-base".text = makoBase;

  services.mako = {
    enable = true;
  };
}
