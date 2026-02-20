{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix  # generado con: nixos-generate-config
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/desktop.nix
  ];

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-portatil";
  networking.networkmanager.enable = true;

  users.users.pedro = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" "video" "audio" "networkmanager" ];
    shell        = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
