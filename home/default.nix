{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./shell.nix
    ./hyprland.nix
    ./kitty.nix
  ];

  home.username = "pedro";
  home.homeDirectory = "/home/pedro";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Pedro";
        email = "pedro@nixos-dev";
      };
      safe.directory = [ "/etc/nixos" ];
    };
  };

  home.packages = with pkgs; [
    htop
    curl
    wget
    unzip
    wl-clipboard

    nodejs_22
    corepack_22

    python3

    dotnet-sdk_8

    docker-compose
  ];
}
