{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.username = "pedro";
  home.homeDirectory = "/home/pedro";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings.user = {
      name = "Pedro";
      email = "pedro@nixos-dev";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-dev";
    };
  };

  home.packages = with pkgs; [
    htop
    curl
    wget
    unzip

    nodejs_22
    corepack_22

    python3

    dotnet-sdk_8

    docker-compose
  ];
}
