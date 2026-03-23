{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/desktop.nix
    ../../modules/virtualisation.nix
  ];

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "quiet" "loglevel=3" "splash" ];
  boot.consoleLogLevel = 0;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users.occulta = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" "video" "audio" "networkmanager" "libvirtd" ];
    shell        = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
}
