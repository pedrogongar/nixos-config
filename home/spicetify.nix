{ pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

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
