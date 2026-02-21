{ pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    customColorScheme = {
      text               = "d4c4b0";
      subtext            = "8a7a6a";
      sidebar-text       = "d4c4b0";
      main               = "0a0a0a";
      sidebar            = "0a0a0a";
      player             = "121010";
      card               = "1e1616";
      shadow             = "080808";
      selected-row       = "2a1c1c";
      button             = "e8c020";
      button-active      = "e8c020";
      button-disabled    = "3a2828";
      tab-active         = "e8c020";
      notification       = "1e1616";
      notification-error = "c43030";
      misc               = "5a4a3a";
    };

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
      hidePodcasts
    ];
  };

  home.sessionVariables = {
    SPOTIFY_FLAGS = "--ozone-platform=x11";
  };

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    exec = "spotify --ozone-platform=x11 --disable-gpu";
    icon = "spotify";
    terminal = false;
    type = "Application";
    categories = [ "Audio" "Music" "Player" ];
  };
}
