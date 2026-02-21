{ config, pkgs, ... }:

let
  c = import ./colores.nix;
  iconPath = "${pkgs.wlogout}/share/wlogout/icons";
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "suspend";  action = "systemctl suspend";           text = "Suspender";      keybind = "s"; }
      { label = "logout";   action = "hyprctl dispatch exit";       text = "Cerrar sesión";  keybind = "q"; }
      { label = "reboot";   action = "systemctl reboot";            text = "Reiniciar";      keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";          text = "Apagar";         keybind = "p"; }
    ];
    style = ''
      window {
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 13px;
        color: ${c.text};
        background-color: rgba(${c.base_rgb}, 0.88);
      }

      button {
        background-color: rgba(${c.mantle_rgb}, 0.75);
        border: 1px solid rgba(${c.oro_rgb}, 0.18);
        border-radius: 10px;
        margin: 8px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 36px;
        color: ${c.text};
        transition: all 0.2s ease;
      }

      button:hover {
        background-color: rgba(${c.oro_rgb}, 0.12);
        border-color: ${c.oro};
      }

      button:focus {
        background-color: rgba(${c.oro_rgb}, 0.18);
        border-color: ${c.oro};
        box-shadow: 0 0 12px rgba(${c.oro_rgb}, 0.2);
      }

      #suspend {
        background-image: image(url("${iconPath}/suspend.png"));
      }

      #logout {
        background-image: image(url("${iconPath}/logout.png"));
      }

      #reboot {
        background-image: image(url("${iconPath}/reboot.png"));
      }

      #shutdown {
        background-image: image(url("${iconPath}/shutdown.png"));
      }
    '';
  };
}
