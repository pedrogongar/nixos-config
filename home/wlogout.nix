{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock";     action = "hyprlock";                    text = "Bloquear"; keybind = "l"; }
      { label = "logout";   action = "hyprctl dispatch exit";       text = "Cerrar sesión"; keybind = "q"; }
      { label = "suspend";  action = "systemctl suspend";           text = "Suspender"; keybind = "s"; }
      { label = "reboot";   action = "systemctl reboot";            text = "Reiniciar"; keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";          text = "Apagar"; keybind = "p"; }
    ];
    style = builtins.readFile ./wlogout/style.css;
  };
}
