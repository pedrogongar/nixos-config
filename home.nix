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
    htop
    curl
    wget
  ];
}
