{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  mkSvg = paths: ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none"
         stroke="${c.oro}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
      ${paths}
    </svg>
  '';

  iconDir = "${config.xdg.configHome}/wlogout/icons";

  # ── Colores (se reutilizan en defaults + CSS inicial) ────────────────
  wlogoutColors = ''
    @define-color wl_base ${c.base};
    @define-color wl_mantle ${c.mantle};
    @define-color wl_accent ${c.oro};
    @define-color wl_text ${c.text};
  '';

  # ── Estructura CSS (sin colores hardcodeados) ────────────────────────
  wlogoutBase = ''
    window {
      font-family: "JetBrains Mono Nerd Font", monospace;
      font-size: 14px;
      color: @wl_text;
      background-color: alpha(@wl_base, 0.85);
    }

    button {
      background-color: alpha(@wl_mantle, 0.8);
      border: 2px solid alpha(@wl_accent, 0.15);
      border-radius: 16px;
      margin: 12px;
      background-repeat: no-repeat;
      background-position: center 35%;
      background-size: 64px;
      color: @wl_text;
      transition: all 0.3s ease;
    }

    button:focus {
      background-color: alpha(@wl_mantle, 0.8);
      border-color: alpha(@wl_accent, 0.15);
      box-shadow: none;
      outline: none;
    }

    button:hover {
      background-color: alpha(@wl_accent, 0.1);
      border-color: @wl_accent;
      box-shadow: 0 0 20px alpha(@wl_accent, 0.15);
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

in
{
  # SVGs iniciales con accent Serpiente (se sobreescriben por scripts al cambiar tema)
  xdg.configFile = {
    "wlogout/icons/suspend.svg" = { force = true; text = mkSvg ''
      <path d="M42 26.68A18 18 0 1121.32 6 14 14 0 0042 26.68z"/>
    ''; };
    "wlogout/icons/logout.svg" = { force = true; text = mkSvg ''
      <path d="M18 42H10a4 4 0 01-4-4V10a4 4 0 014-4h8"/>
      <polyline points="32 34 42 24 32 14"/>
      <line x1="42" y1="24" x2="18" y2="24"/>
    ''; };
    "wlogout/icons/reboot.svg" = { force = true; text = mkSvg ''
      <path d="M4 10v10h10"/>
      <path d="M38.66 30A16 16 0 0010.34 13.34L4 20"/>
      <path d="M44 38V28H34"/>
      <path d="M9.34 18A16 16 0 0037.66 34.66L44 28"/>
    ''; };
    "wlogout/icons/shutdown.svg" = { force = true; text = mkSvg ''
      <path d="M24 4v16"/>
      <path d="M36.73 12.27A16 16 0 1111.27 12.27"/>
    ''; };
  };

  # CSS inicial = colores Serpiente + base (force=true permite sobreescritura por scripts)
  xdg.configFile."wlogout/style.css" = {
    text = wlogoutColors + wlogoutBase;
    force = true;
  };
  xdg.configFile."wlogout/style-base.css".text = wlogoutBase;

  programs.wlogout = {
    enable = true;
    layout = [
      { label = "suspend";  action = "systemctl suspend";      text = "Suspender";     keybind = "s"; }
      { label = "logout";   action = "hyprctl dispatch exit";  text = "Cerrar sesión"; keybind = "q"; }
      { label = "reboot";   action = "systemctl reboot";       text = "Reiniciar";     keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff";     text = "Apagar";        keybind = "p"; }
    ];
    # CSS gestionado via xdg.configFile (colores dinámicos + base)
  };
}
