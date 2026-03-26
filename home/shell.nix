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
    config.theme = "ansi";
  };

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
