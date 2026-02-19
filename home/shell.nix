{ config, pkgs, ... }:

let
  starshipFormat = ''
    format = """
    [](fg:sec1)\
    $username\
    [](fg:sec1 bg:sec2)\
    $directory\
    [](fg:sec2 bg:sec3)\
    $git_branch\
    $git_status\
    [](fg:sec3 bg:none) \
    $nodejs\
    $dotnet\
    $python\
    """
  '';

  starshipModules = ''
    [username]
    show_always = true
    format = "[   $user ](bold fg:text bg:sec1 )"

    [hostname]
    ssh_only = true
    format = "[   $hostname ](bold fg:text bg:sec1)"

    [directory]
    format = "[ $path ](bold fg:text bg:sec2)"
    truncation_length = 3
    truncation_symbol = "…/"

    [git_branch]
    format = "[ 󰪀 $branch ](fg:text bg:sec3)"
    symbol = ""

    [git_status]
    format = "[$all_status$ahead_behind ](fg:text bg:sec3)"
    ahead = "⇡"
    behind = "⇣"
    diverged = "⇕"
    modified = "~"
    staged = "+"
    untracked = "?"

    [nodejs]
    format = "[ $version](fg:node) "
    detect_files = ["package.json", ".node-version"]

    [dotnet]
    format = "[󰌛 $version](fg:dotnet) "

    [python]
    format = "[ $version](fg:python) "

    [cmd_duration]
    format = "[ $duration](fg:dimmed)"
    min_time = 2000

    [character]
    success_symbol = "[❯](bold fg:success)"
    error_symbol = "[❯](bold fg:error)"
  '';

  mkTheme = name: colors: ''
    palette = "${name}"

    ${starshipFormat}

    ${starshipModules}

    [palettes.${name}]
    ${colors}
  '';

  themes = {
    tokyo = mkTheme "tokyo" ''
      sec1 = "#7aa2f7"
      sec2 = "#bb9af7"
      sec3 = "#e3aaff"
      text = "#15161e"
      node = "#9ece6a"
      dotnet = "#7dcfff"
      python = "#e0af68"
      dimmed = "#565f89"
      success = "#9ece6a"
      error = "#f7768e"
    '';

    dracula = mkTheme "dracula" ''
      sec1 = "#bd93f9"
      sec2 = "#ff79c6"
      sec3 = "#8be9fd"
      text = "#282a36"
      node = "#50fa7b"
      dotnet = "#8be9fd"
      python = "#ffb86c"
      dimmed = "#6272a4"
      success = "#50fa7b"
      error = "#ff5555"
    '';

    malva = mkTheme "malva" ''
      sec1 = "#8aadf4"
      sec2 = "#c4a7e7"
      sec3 = "#8bd5ca"
      text = "#1e2030"
      node = "#a6da95"
      dotnet = "#8bd5ca"
      python = "#f0c6c6"
      dimmed = "#6e738d"
      success = "#a6da95"
      error = "#ed8796"
    '';
  };

in
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
    envExtra = ''
      if [[ -f "$HOME/.config/starship/current-theme" ]]; then
        export STARSHIP_CONFIG="$HOME/.config/starship/$(cat "$HOME/.config/starship/current-theme").toml"
      else
        export STARSHIP_CONFIG="$HOME/.config/starship/tokyo.toml"
      fi
    '';
    initContent = ''
      function theme() {
        local themes_dir="$HOME/.config/starship"
        case "$1" in
          tokyo|dracula|malva)
            echo "$1" > "$themes_dir/current-theme"
            export STARSHIP_CONFIG="$themes_dir/$1.toml"
            echo "✓ Tema cambiado a: $1 (abre una nueva terminal o ejecuta '"'"'exec zsh'"'"' para aplicar)"
            ;;
          "")
            local actual
            actual=$(cat "$themes_dir/current-theme" 2>/dev/null || echo "tokyo")
            echo "Tema actual: $actual"
            echo "Disponibles: tokyo, dracula, malva"
            ;;
          *)
            echo "✗ Tema no reconocido: $1"
            echo "Disponibles: tokyo, dracula, malva"
            ;;
        esac
      }
    '';
  };

  programs.starship = {
    enable = true;
  };

  xdg.configFile = {
    "starship/tokyo.toml".text = themes.tokyo;
    "starship/dracula.toml".text = themes.dracula;
    "starship/malva.toml".text = themes.malva;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
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
