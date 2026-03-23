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
    ./swaync.nix
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
