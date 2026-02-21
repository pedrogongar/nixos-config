{ config, lib, pkgs, ... }:

let
  c = import ../home/colores.nix;
 
  tuigreetTheme = builtins.concatStringsSep ";" [
    "border=#000000"
    "container=#000000"
    "prompt=${c.oro}"
    "text=${c.text}"
    "input=${c.text}"
    "time=${c.subtext}"
    "action=${c.oro}"
    "button=#111111"
  ];

in {

  programs.hyprland.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ── greetd + tuigreet ──
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "${pkgs.greetd.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-session"
          "--asterisks"
          "--time-format '%A, %d %B %Y  %H:%M'"
          "--cmd Hyprland"
	  "--width 40"
          "--window-padding 0"
          "--container-padding 1"
          "--prompt-padding 1"
          "--theme '${tuigreetTheme}'"
        ];
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bibata-cursors
    gnome-themes-extra
    wl-clipboard
    xdg-utils
    libnotify
    brightnessctl
    pamixer
    playerctl
  ];

  environment.pathsToLink = [
    "/share/wayland-sessions"
    "/share/xsessions"
  ];

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  programs.steam.enable = true;
}
