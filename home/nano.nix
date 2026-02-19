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
    set titlecolor bold,#c0caf5,#1a1b26
    set promptcolor #c0caf5,#24253a
    set statuscolor bold,#1a1b26,#c4a7e7
    set errorcolor bold,#1a1b26,#ed8796
    set spotlightcolor #1a1b26,#8aadf4
    set selectedcolor #1a1b26,#8bd5ca
    set stripecolor ,#24253a
    set scrollercolor #c4a7e7
    set numbercolor #565f89
    set keycolor #8aadf4
    set functioncolor #c4a7e7
    include "${pkgs.nano}/share/nano/*.nanorc"
  '';
}
