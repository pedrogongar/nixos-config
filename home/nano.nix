{ config, pkgs, ... }:

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
    set titlecolor bold,brightwhite,black
    set promptcolor brightwhite,brightblack
    set statuscolor bold,black,yellow
    set errorcolor bold,black,red
    set spotlightcolor black,blue
    set selectedcolor black,cyan
    set stripecolor ,brightblack
    set scrollercolor yellow
    set numbercolor brightblack
    set keycolor blue
    set functioncolor yellow
    include "${pkgs.nano}/share/nano/*.nanorc"
  '';
}
