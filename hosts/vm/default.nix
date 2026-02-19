{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-dev";
  networking = {
    interfaces.enp1s0 = {
      ipv4.addresses = [{
        address = "192.168.122.50";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.122.1";
    nameservers = [ "8.8.8.8" ];
  };

  users.users.pedro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
