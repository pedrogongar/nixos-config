{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./shell.nix
    ./hyprland.nix
    ./kitty.nix
    ./theme.nix
    ./apps.nix
    ./fastfetch.nix
    ./rofi.nix
    ./hyprlock.nix
    ./wlogout.nix
    ./mako.nix
    ./matugen.nix
    ./nano.nix
    ./vscode.nix
    ./waybar.nix
    ./spicetify.nix
    ./btop.nix
    ./wallpaper-selector.nix
  ];

  home.username     = "occulta";
  home.homeDirectory = "/home/occulta";
  home.stateVersion  = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Pedro";
        email = "pedrogongar91@proton.me";
      };
      safe.directory = [ "/etc/nixos" ];
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/zip"              = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed"  = "org.gnome.FileRoller.desktop";
      "application/x-rar"            = "org.gnome.FileRoller.desktop";
      "application/x-tar"            = "org.gnome.FileRoller.desktop";
      "application/gzip"             = "org.gnome.FileRoller.desktop";
      "application/x-bzip2"          = "org.gnome.FileRoller.desktop";
      "application/x-xz"             = "org.gnome.FileRoller.desktop";
      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";

      "image/png"                    = "org.gnome.Loupe.desktop";
      "image/jpeg"                   = "org.gnome.Loupe.desktop";
      "image/gif"                    = "org.gnome.Loupe.desktop";
      "image/webp"                   = "org.gnome.Loupe.desktop";
      "image/svg+xml"                = "org.gnome.Loupe.desktop";
      "image/bmp"                    = "org.gnome.Loupe.desktop";

      "text/html"                    = "zen-beta.desktop";
      "x-scheme-handler/http"        = "zen-beta.desktop";
      "x-scheme-handler/https"       = "zen-beta.desktop";
      "x-scheme-handler/about"       = "zen-beta.desktop";
      "x-scheme-handler/unknown"     = "zen-beta.desktop";
    };
  };

  home.sessionVariables = {
    BROWSER = "zen-beta";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/imagenes/capturas";
  };

  home.packages = with pkgs; [
    curl
    wget
    unzip

    nodejs_22
    corepack_22

    python3

    dotnet-sdk_8

    docker-compose

    jq
    httpie
    gh
    dive
    nmap
  ];
}
