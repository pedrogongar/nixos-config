{ config, lib, pkgs, ... }:

{
  imports = [
    # ./hardware-configuration.nix  # Se genera al instalar
    ../../modules/base.nix
    ../../modules/docker.nix
  ];

  networking.hostName = "nixos-escritorio";

  users.users.pedro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "audio" ];
  };

  # TODO: Hyprland, audio, GPU drivers

  system.stateVersion = "25.11";
}
