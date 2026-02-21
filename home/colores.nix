# ─── Paleta Serpiente ────────────────────────────────────────────────────
#
# Única fuente de verdad para todos los colores del sistema.
# Cada módulo importa este archivo con: c = import ./colores.nix;
#
# Convención rgba: usar componentes RGB + opacidad en cada módulo.
#   Ejemplo: "rgba(${c.oro_rgb}, 0.3)"
#
# No añadir aliases ni colores duplicados.
# ─────────────────────────────────────────────────────────────────────────

{
  # ── Fondos ──

  crust    = "#080808";
  mantle   = "#121010";
  base     = "#0a0a0a";
  surface0 = "#1e1616";
  surface1 = "#2a1c1c";
  surface2 = "#3a2828";

  # ── Texto ──

  text     = "#d4c4b0";
  subtext  = "#8a7a6a";

  # ── Acentos primarios ──

  oro      = "#e8c020";
  ambar    = "#e08830";
  rojo     = "#c43030";
  sangre   = "#7a1818";

  # ── Acentos secundarios ──

  oliva    = "#8a8030";
  cobre    = "#a07040";
  arena    = "#907a50";

  # ── Componentes RGB (para construcción de rgba en CSS/conf) ──

  base_rgb     = "10,10,10";
  mantle_rgb   = "18,16,16";
  crust_rgb    = "8,8,8";
  surface0_rgb = "30,22,22";
  surface1_rgb = "42,28,28";
  surface2_rgb = "58,40,40";
  text_rgb     = "212,196,176";
  subtext_rgb  = "138,122,106";
  oro_rgb      = "232,192,32";
  ambar_rgb    = "224,136,48";
  rojo_rgb     = "196,48,48";
  sangre_rgb   = "122,24,24";
  oliva_rgb    = "138,128,48";
  cobre_rgb    = "160,112,64";
  arena_rgb    = "144,122,80";

  # ── Mapeo Catppuccin (para catppuccin-nvim y spicetify) ──
  # Sin prefijo # — catppuccin-vsc los espera así.

  catppuccin = {
    rosewater = "d4c4b0";
    flamingo  = "e08830";
    pink      = "c43030";
    mauve     = "e8c020";
    red       = "c43030";
    maroon    = "7a1818";
    peach     = "e08830";
    yellow    = "e8c020";
    green     = "8a8030";
    teal      = "907a50";
    sky       = "907a50";
    sapphire  = "907a50";
    blue      = "a07040";
    lavender  = "e8c020";
    text      = "d4c4b0";
    subtext1  = "8a7a6a";
    subtext0  = "8a7a6a";
    overlay2  = "5a4a3a";
    overlay1  = "5a4a3a";
    overlay0  = "5a4a3a";
    surface2  = "3a2828";
    surface1  = "2a1c1c";
    surface0  = "1e1616";
    base      = "0a0a0a";
    mantle    = "121010";
    crust     = "080808";
  };
}
