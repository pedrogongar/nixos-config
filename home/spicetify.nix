{ pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  c = import ./colores.nix;
  strip = s: builtins.substring 1 6 s;

  colorIni = pkgs.writeText "color.ini" ''
    [serpiente]
    text               = ${strip c.text}
    subtext            = ${strip c.subtext}
    sidebar-text       = ${strip c.text}
    main               = ${strip c.base}
    sidebar            = ${strip c.base}
    player             = ${strip c.mantle}
    card               = ${strip c.surface0}
    shadow             = ${strip c.crust}
    selected-row       = ${strip c.surface1}
    button             = ${strip c.oro}
    button-active      = ${strip c.oro}
    button-disabled    = ${strip c.surface2}
    tab-active         = ${strip c.oro}
    notification       = ${strip c.surface0}
    notification-error = ${strip c.rojo}
    misc               = ${strip c.overlay}
    base               = ${strip c.base}
    mantle             = ${strip c.mantle}
    crust              = ${strip c.crust}
    surface0           = ${strip c.surface0}
    surface1           = ${strip c.surface1}
    surface2           = ${strip c.surface2}
    overlay0           = ${strip c.overlay}
    overlay1           = ${strip c.overlay}
    overlay2           = ${strip c.overlay}
    red                = ${strip c.rojo}
    ambar              = ${strip c.ambar}
    oro                = ${strip c.oro}
  '';

  temaSerpiente = pkgs.runCommand "spicetify-tema-serpiente" {} ''
    mkdir -p $out
    cp ${./spicetify/user.css} $out/user.css
    cp ${colorIni} $out/color.ini
  '';
in
{
  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;

    theme = {
      name = "serpiente";
      src = temaSerpiente;
      injectCss = true;
      replaceColors = true;
      homeConfig = true;
      injectThemeJs = false;
    };

    colorScheme = "serpiente";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
    ];
  };

  home.sessionVariables = {
    SPOTIFY_FLAGS = "--ozone-platform=x11";
  };

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    exec = "spotify --disable-gpu --no-zygote";
    icon = "spotify";
    terminal = false;
    type = "Application";
    categories = [ "Audio" "Music" "Player" ];
  };
}
