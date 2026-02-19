{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Tema e iconos
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        pkief.material-icon-theme

        # Vue / Frontend
        vue.volar
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode

        # C# / .NET
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit

        # Nix
        jnoortheen.nix-ide

        # Docker
        ms-azuretools.vscode-docker

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # Git
        eamodio.gitlens

        # Calidad de vida
        usernamehw.errorlens
        christian-kohler.path-intellisense
        gruntfuggly.todo-tree
        aaron-bond.better-comments
        formulahendry.code-runner
        mikestead.dotenv
        oderwat.indent-rainbow
      ];

      userSettings = {
        # Tema
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "catppuccin.accentColor" = "mauve";

        # Fuente
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;

        # Apariencia
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "workbench.list.smoothScrolling" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.renderWhitespace" = "boundary";
        "editor.linkedEditing" = true;
        "editor.minimap.enabled" = false;
        "window.titleBarStyle" = "custom";
        "breadcrumbs.enabled" = true;

        # Formateo al guardar
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

        # Formateo por lenguaje
        "[vue]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[csharp]" = {
          "editor.defaultFormatter" = "ms-dotnettools.csharp";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.wordWrap" = "on";
        };

        # Terminal integrado
        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.defaultProfile.linux" = "zsh";

        # Vue / Volar
        "vue.server.hybridMode" = true;

        # TypeScript
        "typescript.preferences.importModuleSpecifier" = "relative";
        "typescript.suggest.autoImports" = true;
        "typescript.updateImportsOnFileMove.enabled" = "always";

        # ESLint
        "eslint.validate" = [ "javascript" "typescript" "vue" ];

        # Tailwind
        "tailwindCSS.emmetCompletions" = true;
        "tailwindCSS.includeLanguages" = {
          "vue" = "html";
        };

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "gitlens.currentLine.enabled" = true;

        # Error Lens
        "errorLens.enabledDiagnosticLevels" = [ "error" "warning" "info" ];
        "errorLens.gutterIconsEnabled" = true;

        # Better Comments
        "better-comments.tags" = [
          { "tag" = "!";    "color" = "#ed8796"; "strikethrough" = false; "underline" = false; "bold" = true; }
          { "tag" = "?";    "color" = "#8aadf4"; "strikethrough" = false; "underline" = false; "bold" = false; }
          { "tag" = "TODO"; "color" = "#e0af68"; "strikethrough" = false; "underline" = false; "bold" = true; }
          { "tag" = "*";    "color" = "#a6da95"; "strikethrough" = false; "underline" = false; "bold" = false; }
        ];

        # Todo Tree
        "todo-tree.highlights.defaultHighlight" = {
          "foreground" = "#1a1b26";
          "background" = "#c4a7e7";
          "iconColour" = "#c4a7e7";
          "type" = "tag";
        };

        # Code Runner
        "code-runner.runInTerminal" = true;
        "code-runner.saveFileBeforeRun" = true;

        # Explorer
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;

        # Nix IDE
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # Telemetría off
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
