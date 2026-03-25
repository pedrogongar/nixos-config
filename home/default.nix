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
    };
  };

  home.sessionVariables = {
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
