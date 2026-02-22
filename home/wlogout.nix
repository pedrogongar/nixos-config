{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  mkIcon = { paths, viewBox ? "0 0 24 24" }: ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="${viewBox}" fill="none"
         stroke="${c.oro}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
      ${paths}
    </svg>
  '';

  iconSuspend = mkIcon {
    paths = ''
      <line x1="10" y1="6" x2="10" y2="18"/>
      <line x1="14" y1="6" x2="14" y2="18"/>
    '';
  };

  iconLogout = mkIcon {
    paths = ''
      <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
      <polyline points="16 17 21 12 16 7"/>
      <line x1="21" y1="12" x2="9" y2="12"/>
    '';
  };

  iconReboot = mkIcon {
    paths = ''
      <polyline points="23 4 23 10 17 10"/>
      <path d="M20.49 15a9 9 0 11-2.12-9.36L23 10"/>
    '';
  };

  iconShutdown = mkIcon {
    paths = ''
      <line x1="12" y1="2" x2="12" y2="12"/>
      <path d="M16.24 7.76a6 6 0 010 8.49 6 6 0 01-8.49 0 6 6 0 010-8.49"/>
    '';
  };

  iconDir = "${config.xdg.configHome}/wlogout/icons";

in
{
  xdg.configFile = {
    "wlogout/icons/suspend.svg".text  = iconSuspend;
    "wlogout/icons/logout.svg".text   = iconLogout;
    "wlogout/icons/reboot.svg".text   = iconReboot;
    "wlogout/icons/shutdown.svg".text = iconShutdown;
  };

  programs.wlogout = {
    enable = true;
    layout = [
      { label = "suspend";  action = "systemctl suspend";      text = "Suspender";     keybind = "s"; }
      { label = "logout";   action = "hyprctl dispatch exit";  text = "Cerrar sesión"; keybind = "q"; }
      { label = "reboot";   action = "systemctl reboot";       text = "Reiniciar";     keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";     text = "Apagar";        keybind = "p"; }
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

      button:focus {
        background-color: rgba(${c.mantle_rgb}, 0.75);
        border-color: rgba(${c.oro_rgb}, 0.18);
        box-shadow: none;
        outline: none;
      }

      button:hover {
        background-color: rgba(${c.oro_rgb}, 0.12);
        border-color: ${c.oro};
      }

      #suspend {
        background-image: url("${iconDir}/suspend.svg");
      }

      #logout {
        background-image: url("${iconDir}/logout.svg");
      }

      #reboot {
        background-image: url("${iconDir}/reboot.svg");
      }

      #shutdown {
        background-image: url("${iconDir}/shutdown.svg");
      }
    '';
  };
}
