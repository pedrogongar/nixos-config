{ config, pkgs, ... }:

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
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil";
      ls      = "eza --icons";
      ll      = "eza -la --icons --git";
      lt      = "eza --tree --icons --level=2";
      cat     = "bat";
      cd      = "z";
      lg      = "lazygit";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "[](${c.malva})"
        "$username"
        "[](fg:${c.malva} bg:${c.blue})"
        "$directory"
        "[](fg:${c.blue} bg:${c.surface0})"
        "$git_branch"
        "$git_status"
        "[](${c.surface0}) "
        "$nodejs"
        "$dotnet"
        "$python"
        "$nix_shell"
        "$cmd_duration"
        "$character"
      ];

      username = {
        show_always = true;
        format      = "[  $user ](bold fg:${c.crust} bg:${c.malva})";
      };

      directory = {
        format            = "[ $path ](bold fg:${c.crust} bg:${c.blue})";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        format = "[ 󰪀 $branch ](fg:${c.text} bg:${c.surface0})";
      };

      git_status = {
        format     = "[$all_status$ahead_behind ](fg:${c.yellow} bg:${c.surface0})";
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
        format       = "[ $version ](${c.green})";
        detect_files = [ "package.json" ".node-version" ];
      };

      dotnet = {
        format = "[󰌛 $version ](${c.blue})";
      };

      python = {
        format = "[ $version ](${c.yellow})";
      };

      nix_shell = {
        format = "[󱄅 nix ](${c.cyan})";
      };

      cmd_duration = {
        format   = "[ $duration ](${c.peach})";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold ${c.malva})";
        error_symbol   = "[❯](bold ${c.red})";
      };
    };
  };

  programs.fzf = {
    enable               = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--color=bg+:${c.surface0},bg:${c.base},spinner:${c.malva},hl:${c.cyan}"
      "--color=fg:${c.subtext},header:${c.cyan},info:${c.malva},pointer:${c.malva}"
      "--color=marker:${c.green},fg+:${c.text},prompt:${c.malva},hl+:${c.cyan}"
      "--color=border:${c.surface1}"
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
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

  home.packages = with pkgs; [
    lazygit
  ];
}
