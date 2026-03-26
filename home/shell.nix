{ config, pkgs, claude-code, ... }:

let
  c = import ./colores.nix;

  # ── Starship: base + colores separados para theming dinámico ──────────
  #    Starship re-lee config en cada prompt, no necesita reload
  starshipBase = ''
    palette = "active"

    format = "$custom$username$directory$git_branch$git_status$nodejs$dotnet$python$nix_shell$cmd_duration$character"

    [custom.capricorn]
    command = "echo 󰪀"
    when = "true"
    format = "[($output )](bold sp_oro)"
    shell = ["sh"]

    [username]
    show_always = true
    format = "[$user](bold sp_ambar) "

    [directory]
    format = "[$path](sp_arena) "
    truncation_length = 3
    truncation_symbol = "…/"

    [git_branch]
    format = "[$branch](sp_cobre) "

    [git_status]
    format = "[$all_status$ahead_behind](sp_rojo) "
    ahead = "⇡"
    behind = "⇣"
    diverged = "⇕"
    modified = "!"
    staged = "+"
    untracked = "?"
    deleted = "✗"
    conflicted = "="

    [nodejs]
    format = "[ $version](sp_oliva) "
    detect_files = ["package.json", ".node-version"]

    [dotnet]
    format = "[󰌛 $version](sp_cobre) "

    [python]
    format = "[ $version](sp_oro) "

    [nix_shell]
    format = "[󱄅 nix](sp_arena) "

    [cmd_duration]
    format = "[ $duration](sp_subtext) "
    min_time = 2000

    [character]
    success_symbol = "[❯](bold sp_oro)"
    error_symbol = "[❯](bold sp_rojo)"
  '';

  starshipColors = ''

    [palettes.active]
    sp_oro = "${c.oro}"
    sp_ambar = "${c.ambar}"
    sp_arena = "${c.arena}"
    sp_cobre = "${c.cobre}"
    sp_rojo = "${c.rojo}"
    sp_oliva = "${c.oliva}"
    sp_subtext = "${c.subtext}"
  '';

in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable       = true;
    syntaxHighlighting.enable   = true;
    historySubstringSearch.enable = true;
    history = {
      size          = 10000;
      ignoreDups    = true;
      ignoreAllDups = true;
    };
    initExtra = ''
      bindkey -e
      export PATH="$HOME/.local/bin:$PATH"
      # Rebuild bat cache si el tema Serpiente no está cacheado
      if ! bat --list-themes 2>/dev/null | grep -q "Serpiente"; then
        bat cache --build &>/dev/null
      fi
      fastfetch
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil";
      ls      = "eza --icons";
      ll      = "eza -la --icons --git";
      lt      = "eza --tree --icons --level=2";
      cat     = "bat -P";
      cd      = "z";
      lg      = "lazygit";
      ld      = "lazydocker";
    };
  };

  # Starship: shell integration sin settings (config gestionada via xdg.configFile)
  programs.starship.enable = true;

  # Config inicial = base + paleta Serpiente (force=true permite sobreescritura por scripts)
  xdg.configFile."starship.toml" = {
    text = starshipBase + starshipColors;
    force = true;
  };
  xdg.configFile."starship-base.toml".text = starshipBase;

  programs.fzf = {
    enable               = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--color=bg+:${c.surface0},bg:${c.base},spinner:${c.oro},hl:${c.arena}"
      "--color=fg:${c.subtext},header:${c.arena},info:${c.oro},pointer:${c.oro}"
      "--color=marker:${c.oliva},fg+:${c.text},prompt:${c.oro},hl+:${c.arena}"
      "--color=border:${c.surface1}"
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "Serpiente";
  };

  # ── Bat: tema Serpiente (.tmTheme) ──────────────────────────────────
  xdg.configFile."bat/themes/Serpiente.tmTheme".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key><string>Serpiente</string>
      <key>settings</key>
      <array>
        <!-- Global settings -->
        <dict><key>settings</key><dict>
          <key>background</key><string>${c.base}</string>
          <key>foreground</key><string>${c.text}</string>
          <key>caret</key><string>${c.oro}</string>
          <key>selection</key><string>${c.surface1}</string>
          <key>lineHighlight</key><string>${c.surface0}</string>
          <key>gutterForeground</key><string>${c.overlay}</string>
        </dict></dict>
        <!-- comment -->
        <dict><key>scope</key><string>comment, comment.line, comment.block</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.arena}</string>
            <key>fontStyle</key><string>italic</string>
        </dict></dict>
        <!-- string -->
        <dict><key>scope</key><string>string, string.quoted</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oliva}</string>
        </dict></dict>
        <!-- constant.numeric -->
        <dict><key>scope</key><string>constant.numeric</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.ambar}</string>
        </dict></dict>
        <!-- constant.language -->
        <dict><key>scope</key><string>constant.language</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.ambar}</string>
        </dict></dict>
        <!-- keyword -->
        <dict><key>scope</key><string>keyword, keyword.control</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oro}</string>
        </dict></dict>
        <!-- keyword.operator -->
        <dict><key>scope</key><string>keyword.operator</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.rojo}</string>
        </dict></dict>
        <!-- storage.type -->
        <dict><key>scope</key><string>storage.type, storage.modifier</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.rojo}</string>
        </dict></dict>
        <!-- entity.name.function -->
        <dict><key>scope</key><string>entity.name.function</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oro}</string>
        </dict></dict>
        <!-- entity.name.type / class -->
        <dict><key>scope</key><string>entity.name.type, entity.name.class, entity.other.inherited-class</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.cobre}</string>
        </dict></dict>
        <!-- variable -->
        <dict><key>scope</key><string>variable, variable.other</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.text}</string>
        </dict></dict>
        <!-- variable.parameter -->
        <dict><key>scope</key><string>variable.parameter</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.subtext}</string>
        </dict></dict>
        <!-- entity.name.tag (HTML/XML) -->
        <dict><key>scope</key><string>entity.name.tag</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.rojo}</string>
        </dict></dict>
        <!-- entity.other.attribute-name -->
        <dict><key>scope</key><string>entity.other.attribute-name</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.ambar}</string>
        </dict></dict>
        <!-- support.function -->
        <dict><key>scope</key><string>support.function</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oro}</string>
        </dict></dict>
        <!-- support.type -->
        <dict><key>scope</key><string>support.type, support.class</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.cobre}</string>
        </dict></dict>
        <!-- punctuation -->
        <dict><key>scope</key><string>punctuation</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.subtext}</string>
        </dict></dict>
        <!-- meta.decorator -->
        <dict><key>scope</key><string>meta.decorator, punctuation.decorator</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.ambar}</string>
        </dict></dict>
        <!-- markup.heading -->
        <dict><key>scope</key><string>markup.heading</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oro}</string>
            <key>fontStyle</key><string>bold</string>
        </dict></dict>
        <!-- markup.bold -->
        <dict><key>scope</key><string>markup.bold</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.text}</string>
            <key>fontStyle</key><string>bold</string>
        </dict></dict>
        <!-- markup.italic -->
        <dict><key>scope</key><string>markup.italic</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.text}</string>
            <key>fontStyle</key><string>italic</string>
        </dict></dict>
        <!-- markup.inline.raw -->
        <dict><key>scope</key><string>markup.inline.raw, markup.raw</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.oliva}</string>
        </dict></dict>
        <!-- invalid -->
        <dict><key>scope</key><string>invalid, invalid.illegal</string>
          <key>settings</key><dict>
            <key>foreground</key><string>${c.rojo}</string>
            <key>background</key><string>${c.sangre}</string>
        </dict></dict>
      </array>
    </dict>
    </plist>
  '';

  programs.eza.enable = true;

  # ── EZA: colores Serpiente via EZA_COLORS (24-bit RGB) ──────────────
  home.sessionVariables.EZA_COLORS = builtins.concatStringsSep ":" [
    # Permisos usuario (oliva)
    "ur=38;2;${c.oliva_rgb}" "uw=38;2;${c.oliva_rgb}" "ux=38;2;${c.oliva_rgb}"
    # Permisos grupo (arena)
    "gr=38;2;${c.arena_rgb}" "gw=38;2;${c.arena_rgb}" "gx=38;2;${c.arena_rgb}"
    # Permisos otros (surface2)
    "tr=38;2;${c.surface2_rgb}" "tw=38;2;${c.surface2_rgb}" "tx=38;2;${c.surface2_rgb}"
    # Tamaño
    "sn=38;2;${c.oro_rgb}" "sb=38;2;${c.ambar_rgb}"
    # Fecha
    "da=38;2;${c.subtext_rgb}"
    # Usuarios
    "uu=38;2;${c.cobre_rgb}" "un=38;2;${c.surface2_rgb}"
    "gu=38;2;${c.arena_rgb}" "gn=38;2;${c.surface2_rgb}"
    # Tipos de archivo
    "di=38;2;${c.oro_rgb}" "fi=38;2;${c.text_rgb}" "ln=38;2;${c.ambar_rgb}"
    "ex=38;2;${c.oliva_rgb}" "xa=38;2;${c.arena_rgb}"
    # Header
    "hd=1;38;2;${c.oro_rgb}"
    # Git
    "ga=38;2;${c.oliva_rgb}" "gm=38;2;${c.ambar_rgb}" "gd=38;2;${c.rojo_rgb}"
  ];

  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable           = true;
    nix-direnv.enable = true;
  };

  home.packages = (with pkgs; [
    lazygit
    ripgrep
    fd
    tldr
    ncdu
    duf
    lazydocker
    quickemu
    uv
  ]) ++ [
    claude-code.packages.x86_64-linux.default
  ];
}
