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
    set promptcolor #c0caf5,#24283b
    set statuscolor bold,#1a1b26,#c4a7e7
    set errorcolor bold,#1a1b26,#f38ba8
    set spotlightcolor #1a1b26,#7aa2f7
    set selectedcolor #1a1b26,#94e2d5
    set stripecolor ,#24283b
    set scrollercolor #c4a7e7
    set numbercolor #565f89
    set keycolor #7aa2f7
    set functioncolor #c4a7e7
    include "${pkgs.nano}/share/nano/*.nanorc"
  '';
}
