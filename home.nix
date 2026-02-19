{ config, pkgs, ... }:

{
  home.username = "pedro";
  home.homeDirectory = "/home/pedro";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    userName = "Pedro";
    userEmail = "pedro@nixos-dev";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-dev";
    };
  };

  home.packages = with pkgs; [
      # Herramientas básicas
      htop
      curl
      wget
      ripgrep
      fd
      unzip

      # Node.js (JS/TS/CSS)
      nodejs_22
      corepack_22

      # Python
      python3

      # .NET
      dotnet-sdk_8

      # Docker
      docker-compose
  ];
}
