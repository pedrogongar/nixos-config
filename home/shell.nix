{ config, pkgs, claude-code, ... }:

let
  c = import ./colores.nix;
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

  programs.starship = {
    enable = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "$custom"
        "$username"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$dotnet"
        "$python"
        "$nix_shell"
        "$cmd_duration"
        "$character"
      ];

      custom.capricorn = {
        command = "echo 󰪀";
        when = "true";
        format = "[($output )](bold ${c.oro})";
        shell = ["sh"];
      };

      username = {
        show_always = true;
        format = "[$user](bold ${c.ambar}) ";
      };

      directory = {
        format = "[$path](${c.arena}) ";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        format = "[$branch](${c.cobre}) ";
      };

      git_status = {
        format = "[$all_status$ahead_behind](${c.rojo}) ";
        ahead      = "⇡";
        behind     = "⇣";
        diverged   = "⇕";
        modified   = "!";
        staged     = "+";
        untracked  = "?";
        deleted    = "✗";
        conflicted = "=";
      };

      nodejs = {
        format       = "[ $version](${c.oliva}) ";
        detect_files = [ "package.json" ".node-version" ];
      };

      dotnet = {
        format = "[󰌛 $version](${c.cobre}) ";
      };

      python = {
        format = "[ $version](${c.oro}) ";
      };

      nix_shell = {
        format = "[󱄅 nix](${c.arena}) ";
      };

      cmd_duration = {
        format   = "[ $duration](${c.subtext}) ";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold ${c.oro})";
        error_symbol   = "[❯](bold ${c.rojo})";
      };
    };
  };

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
  ]) ++ [
    claude-code.packages.x86_64-linux.default
  ];
}
