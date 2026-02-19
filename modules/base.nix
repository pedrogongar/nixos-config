{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "es_ES.UTF-8";
  console.keyMap = "es";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;
}
