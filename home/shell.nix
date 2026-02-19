{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    history = {
      size = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-dev";
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      cd = "z";
      lg = "lazygit";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$nodejs$dotnet$python$cmd_duration$line_break$character";
      directory.truncation_length = 3;
      git_branch.format = "[$branch]($style) ";
      git_status.format = "[$all_status$ahead_behind]($style) ";
      nodejs.format = "[$symbol($version)]($style) ";
      dotnet.format = "[$symbol($version)]($style) ";
      python.format = "[$symbol($version)]($style) ";
      cmd_duration.min_time = 2000;
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "tokyonight_night";
  };

  programs.eza.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    lazygit
  ];
}
