{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  home.file.".config/nano/nanorc".text = ''
    set autoindent
    set tabsize 2
    set tabstospaces
    set linenumbers
    set mouse
    set smarthome
    set zap
    set atblanks
    set softwrap
    set stateflags
    set titlecolor bold,${c.text},${c.base}
    set promptcolor ${c.text},${c.surface0}
    set statuscolor bold,${c.base},${c.oro}
    set errorcolor bold,${c.base},${c.rojo}
    set spotlightcolor ${c.base},${c.cobre}
    set selectedcolor ${c.base},${c.arena}
    set stripecolor ,${c.surface0}
    set scrollercolor ${c.oro}
    set numbercolor ${c.surface2}
    set keycolor ${c.cobre}
    set functioncolor ${c.oro}
    include "${pkgs.nano}/share/nano/*.nanorc"
  '';
}
