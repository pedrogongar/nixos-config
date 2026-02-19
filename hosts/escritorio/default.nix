{ config, lib, pkgs, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "nixos-escritorio";

  users.users.pedro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # TODO: GPU drivers (NVIDIA)

  system.stateVersion = "25.11";
}
