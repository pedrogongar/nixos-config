{ config, pkgs, ... }:

let
  c = import ./colores.nix;
  strip = s: builtins.substring 1 6 s;
  
  sattyScript = pkgs.writeShellScriptBin "satty-capture" ''
    # 1. Guardar workspace actual
    ORIGINAL=$(hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')

    # 2. Capturar área con grim+slurp (si cancela, salir limpio)
    TMP=$(mktemp /tmp/satty-XXXXXX.png)
    grim -g "$(slurp)" "$TMP" 2>/dev/null || { rm -f "$TMP"; exit 0; }

    # 3. Buscar primer workspace libre entre 2 y 10
    FREE=$(hyprctl workspaces -j | ${pkgs.jq}/bin/jq \
      '[.[].id] | sort | . as $used |
       [range(2;11)] | map(select(. as $i | $used | index($i) | not)) | .[0]')
    [ "$FREE" = "null" ] || [ -z "$FREE" ] && FREE=10

    # 4. Lanzar satty en background
    satty -f "$TMP" &
    SATTY_PID=$!

    # 5. Esperar a que la ventana aparezca (clase real: com.gabm.satty)
    ADDR=""
    for i in $(seq 1 30); do
      ADDR=$(hyprctl clients -j | ${pkgs.jq}/bin/jq -r \
        '.[] | select(.class=="com.gabm.satty") | .address' | head -1)
      [ -n "$ADDR" ] && break
      sleep 0.1
    done

    # 6. Mover satty al workspace libre y cambiar ahí
    if [ -n "$ADDR" ]; then
      hyprctl dispatch movetoworkspacesilent "$FREE,address:$ADDR"
      hyprctl dispatch workspace "$FREE"
    fi

    # 7. Esperar a que satty se cierre
    wait $SATTY_PID

    # 8. Volver al workspace original
    hyprctl dispatch workspace "$ORIGINAL"

    # 9. Limpiar temporal
    rm -f "$TMP"
  '';

  monitorScript = pkgs.writeShellScriptBin "monitor-switch" ''
    OPTIONS="  Solo portátil\n  Externos (portátil cerrado)\n  Todo activo"

    CHOICE=$(echo -e "$OPTIONS" | ${pkgs.rofi}/bin/rofi -dmenu -p "Monitor" -theme-str '
      window { width: 300px; }
      listview { lines: 3; }
    ')

    case "$CHOICE" in
      *"Solo portátil"*)
        hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
        hyprctl keyword monitor "HDMI-A-1, disable"
        hyprctl keyword monitor "DP-1, disable"
        ;;
      *"Externos"*)
        hyprctl keyword monitor "eDP-1, disable"
        hyprctl keyword monitor "HDMI-A-1, 1920x1080@144, 0x0, 1"
        hyprctl keyword monitor "DP-1, 1920x1080@165, 1920x0, 1"
        ;;
      *"Todo activo"*)
        hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
        hyprctl keyword monitor "HDMI-A-1, 1920x1080@144, 1920x0, 1"
        hyprctl keyword monitor "DP-1, 1920x1080@165, 3840x0, 1"
        ;;
    esac
    sleep 1
    swww img ~/imagenes/wallpapers/default.jpg
    pkill waybar; waybar &
  '';

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod"         = "SUPER";
      "$terminal"    = "kitty";
      "$menu"        = "rofi -show drun";
      "$browser"     = "zen-beta";
      "$fileManager" = "thunar";

      monitor = [
        "HDMI-A-1, 1920x1080@144, 0x0, 1"
        "DP-1, 1920x1080@165, 1920x0, 1"
        "eDP-1, 1920x1080@60, 3840x0, 1"
      ];

      general = {
        gaps_in     = 4;
        gaps_out    = 4;
        border_size = 0;
        "col.active_border"   = "rgba(${strip c.oro}ff)";
        "col.inactive_border" = "rgba(${strip c.surface1}66)";
        layout = "dwindle";
      };

      decoration = {
        rounding         = 16;
        active_opacity   = 1.0;
        inactive_opacity = 0.85;
        blur = {
          enabled           = false;
          size              = 4;
          passes            = 3;
          noise             = 0.02;
          brightness        = 1.0;
          contrast          = 1.0;
          new_optimizations = true;
          xray              = false;
          popups            = true;
          special           = true;
        };
        shadow = {
          enabled = true;
          range   = 8;
          color   = "rgba(00000066)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "zoom, 0.05, 0.7, 0.1, 1.0"
        ];
        animation = [
          "windows,     1, 3,   zoom, popin 90%"
          "windowsIn,   1, 3,   zoom, popin 90%"
          "windowsOut,  1, 2.6, zoom, popin 90%"
          "windowsMove, 1, 3.5, zoom, slide"
          "fade,        1, 3,   zoom"
          "workspaces,  1, 3,   zoom, slide"
        ];
      };

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
        smart_split    = true;
      };

      input = {
        kb_layout    = "es";
        follow_mouse = 1;
        sensitivity  = 0.8;
        touchpad = {
          natural_scroll = true;
        };
      };

      misc = {
        disable_hyprland_logo    = true;
        disable_splash_rendering = true;
        animate_manual_resizes   = true;
        vfr                      = true;
      };

      bind = [
        # ── Apps ──────────────────────────────────────────────────────
        "$mod, T,           exec, $terminal"
        "$mod, A,           exec, $menu"
        "$mod, F,           exec, $browser"
        "$mod, E,           exec, $fileManager"
        "$mod, V,           exec, codium"
        "$mod, D,           exec, discord"
        "$mod, S,           exec, steam"
        "$mod, O,           exec, obsidian"

        # ── Ventanas ─────────────────────────────────────────────────
        "$mod, Q,           exec, if ! hyprctl activewindow | grep -qE '(bienvenida|unimatrix|fastfetch)-ws1'; then hyprctl dispatch killactive; fi"
        "$mod SHIFT, M,     exit"
        "$mod SHIFT, F,     fullscreen"
        "$mod SHIFT, V,     togglefloating"
        "$mod, P,           pseudo"
        "$mod, J,           togglesplit"

        # ── Utilidades ───────────────────────────────────────────────
        "$mod, M,           exec, ${monitorScript}/bin/monitor-switch"
        "$mod, N,           exec, swaync-client -t -sw"
        "$mod, X,           exec, wlogout --buttons-per-row 2"
        "$mod, L,           exec, hyprlock"

        # ── Navegación ───────────────────────────────────────────────
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"

        # ── Workspaces ───────────────────────────────────────────────
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # ── Capturas ─────────────────────────────────────────────────
        # Super+Shift+S → captura área, guarda y copia al portapapeles
        "$mod SHIFT, S,     exec, grimblast --notify copysave area"
        # Print → igual que Super+Shift+S
        ", Print,            exec, grimblast --notify copysave area"
        # Shift+Print → captura pantalla completa
        "SHIFT, Print,       exec, grimblast --notify copysave screen"
        # Super+Shift+A → captura área con editor de anotaciones (flechas, texto, blur)
        "$mod SHIFT, A,     exec, ${sattyScript}/bin/satty-capture"

        # ── Teclas multimedia / Fn ───────────────────────────────────
        ", XF86AudioRaiseVolume,  exec, pamixer -i 5"
        ", XF86AudioLowerVolume,  exec, pamixer -d 5"
        ", XF86AudioMute,         exec, pamixer -t"
        ", XF86AudioMicMute,      exec, pamixer --default-source -t"
        ", XF86MonBrightnessUp,   exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioPlay,         exec, playerctl play-pause"
        ", XF86AudioNext,         exec, playerctl next"
        ", XF86AudioPrev,         exec, playerctl previous"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "sleep 2 && if hyprctl monitors all | grep -q 'HDMI-A-1' && hyprctl monitors all | grep -q 'DP-1'; then hyprctl keyword monitor 'eDP-1, disable'; fi"
        "swww-daemon && sleep 1 && swww img ~/imagenes/wallpapers/default.jpg"
        "swaync"
        "waybar"
        "kitty --class bienvenida-ws1 -o background_opacity=0.0"
        "kitty --class fastfetch-ws1 -o background_opacity=0.75 -e ~/.config/fastfetch/fastfetch-bienvenida.sh"
        "kitty --class unimatrix-ws1 -o background_opacity=0.75 -e unimatrix -s 96 -c yellow"
      ];
    };

    extraConfig = ''
      # ── Satty (anotaciones) ────────────────────────────────────────
      windowrule = float on,                 match:class ^(com\.gabm\.satty)$
      windowrule = fullscreen on,            match:class ^(com\.gabm\.satty)$

      # ── Pantalla bienvenida (ws1) — 1080p ─────────────────────────
      windowrule = float on,              match:class ^(bienvenida-ws1)$
      windowrule = move 10 38,            match:class ^(bienvenida-ws1)$
      windowrule = size 940 1032,         match:class ^(bienvenida-ws1)$
      windowrule = workspace 1 silent,    match:class ^(bienvenida-ws1)$
      windowrule = border_size 0,         match:class ^(bienvenida-ws1)$

      windowrule = float on,              match:class ^(unimatrix-ws1)$
      windowrule = move 960 38,           match:class ^(unimatrix-ws1)$
      windowrule = size 950 511,          match:class ^(unimatrix-ws1)$
      windowrule = workspace 1 silent,    match:class ^(unimatrix-ws1)$
      windowrule = border_size 0,         match:class ^(unimatrix-ws1)$

      windowrule = float on,              match:class ^(fastfetch-ws1)$
      windowrule = move 960 559,          match:class ^(fastfetch-ws1)$
      windowrule = size 950 511,          match:class ^(fastfetch-ws1)$
      windowrule = workspace 1 silent,    match:class ^(fastfetch-ws1)$
      windowrule = border_size 0,         match:class ^(fastfetch-ws1)$

      windowrule = float on,              match:class ^(mpv)$
      windowrule = size 640 360,          match:class ^(mpv)$
      windowrule = center on,             match:class ^(mpv)$
      windowrule = opacity 1.0 1.0,       match:class ^(mpv)$

      windowrule = opacity 0.88 1,        match:class ^(codium|VSCodium|code|Code)$
      windowrule = opacity 0.9 1,         match:class ^(thunar|Thunar)$

      layerrule = blur on,                match:namespace swaync-control-center
      layerrule = blur on,                match:namespace swaync-notification-window
    '';
  };

  home.packages = with pkgs; [
    swww
    grim
    slurp
    satty
    grimblast
    swaynotificationcenter
    hyprlock
    wlogout
    rofi
    pavucontrol
    cava
    fastfetch
    btop
    unimatrix
    yazi
    matugen
    thunar
    jq
    socat
    bluez
    blueman
    solaar
  ];
}
