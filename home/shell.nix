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
      # Rebuild bat cache si el tema cambió
      _BT="$HOME/.config/bat/themes/Serpiente.tmTheme"
      _BH="$HOME/.cache/bat-theme-hash"
      if [ -f "$_BT" ]; then
        _NH=$(md5sum "$_BT" 2>/dev/null | cut -d' ' -f1)
        [ "$_NH" != "$(cat "$_BH" 2>/dev/null)" ] && bat cache --build &>/dev/null && echo "$_NH" > "$_BH"
      fi
      export EZA_COLORS="ur=38;2;138;128;48:uw=38;2;138;128;48:ux=38;2;138;128;48:gr=38;2;144;122;80:gw=38;2;144;122;80:gx=38;2;144;122;80:tr=38;2;58;40;40:tw=38;2;58;40;40:tx=38;2;58;40;40:sn=38;2;232;192;32:sb=38;2;224;136;48:da=38;2;176;160;144:uu=38;2;160;112;64:un=38;2;58;40;40:gu=38;2;144;122;80:gn=38;2;58;40;40:di=1;38;2;232;192;32:fi=38;2;212;196;176:ex=38;2;138;128;48:ln=38;2;224;136;48:lp=38;2;144;122;80:bO=38;2;196;48;48:xa=38;2;58;40;40:hd=1;38;2;232;192;32:ga=38;2;138;128;48:gm=38;2;224;136;48:gd=38;2;196;48;48"
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

  # ── Bat: tema Serpiente (adaptado de Catppuccin con paleta Serpiente) ──
  xdg.configFile."bat/themes/Serpiente.tmTheme".source = ./bat-serpiente.tmTheme;
  # ── Bat: gramática Nix mejorada (vscode-nix-ide) ──────────────────
  xdg.configFile."bat/syntaxes/nix.tmLanguage.json".source = ./bat-nix-syntax.tmLanguage.json;

  programs.eza.enable = true;


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
