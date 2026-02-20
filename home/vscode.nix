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

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # Nix
        jnoortheen.nix-ide

        # Docker
        ms-azuretools.vscode-docker

        # Git
        eamodio.gitlens

        # IntelliSense y navegación
        christian-kohler.path-intellisense
        redhat.vscode-yaml

        # Calidad de código
        usernamehw.errorlens
        streetsidesoftware.code-spell-checker
        aaron-bond.better-comments
        gruntfuggly.todo-tree
        mikestead.dotenv
        formulahendry.code-runner
      ];
      # Extensiones a instalar manualmente desde el marketplace (no disponibles en nixpkgs):
      # - johnpapa.peacock
      # - mhutchie.git-graph
      # - wix.vscode-import-cost
      # - naumovs.color-highlight
      # - kisstkondoros.vscode-gutter-preview
      # - ecmel.vscode-html-css

      userSettings = {
        # ─── Tema ─────────────────────────────────────────────────────────────
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "catppuccin.accentColor" = "mauve";

        # ─── Fuente ───────────────────────────────────────────────────────────
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;

        # ─── Apariencia ───────────────────────────────────────────────────────
        "editor.cursorStyle" = "line";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.minimap.enabled" = true;
        "editor.minimap.renderCharacters" = false;
        "editor.minimap.showSlider" = "mouseover";
        "editor.stickyScroll.enabled" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.renderWhitespace" = "selection";
        "editor.linkedEditing" = true;
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";
        "editor.overviewRulerBorder" = false;
        "editor.wordWrap" = "wordWrapColumn";
        "editor.wordWrapColumn" = 120;
        "workbench.list.smoothScrolling" = true;
        "workbench.editor.labelFormat" = "short";
        "workbench.editor.tabSizing" = "shrink";
        "workbench.tree.indent" = 16;
        "breadcrumbs.enabled" = true;
        "window.titleBarStyle" = "custom";

        # ─── IntelliSense ─────────────────────────────────────────────────────
        "editor.suggestOnTriggerCharacters" = true;
        "editor.quickSuggestions" = {
          "other" = "on";
          "comments" = "off";
          "strings" = "on";
        };
        "editor.parameterHints.enabled" = true;
        "editor.inlayHints.enabled" = "on";
        "editor.acceptSuggestionOnCommitCharacter" = true;

        # ─── Guardado y formato ───────────────────────────────────────────────
        "files.autoSave" = "off";
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

        # ─── Formateador por lenguaje ─────────────────────────────────────────
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
        "[scss]" = {
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
        "[python]" = {
          "editor.codeActionsOnSave" = {
            "source.fixAll" = "explicit";
            "source.organizeImports" = "explicit";
          };
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.wordWrap" = "on";
        };

        # ─── Terminal integrada ───────────────────────────────────────────────
        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.smoothScrolling" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";

        # ─── Vue / Volar ──────────────────────────────────────────────────────
        "vue.server.hybridMode" = true;
        "vue.inlayHints.inlineHandlerLeadingComments" = true;

        # ─── TypeScript ───────────────────────────────────────────────────────
        "typescript.preferences.quoteStyle" = "double";
        "typescript.preferences.importModuleSpecifier" = "relative";
        "typescript.suggest.autoImports" = true;
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "javascript.updateImportsOnFileMove.enabled" = "always";

        # ─── ESLint ───────────────────────────────────────────────────────────
        "eslint.validate" = [ "javascript" "typescript" "vue" ];
        "eslint.useFlatConfig" = true;

        # ─── Tailwind ─────────────────────────────────────────────────────────
        "tailwindCSS.emmetCompletions" = true;
        "tailwindCSS.includeLanguages" = {
          "vue" = "html";
        };
        "tailwindCSS.experimental.classRegex" = [
          [ "clsx\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
          [ "cn\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
        ];

        # ─── Python / Ruff ────────────────────────────────────────────────────
        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;
        "ruff.lint.enable" = true;
        "ruff.format.enable" = true;

        # ─── Git ──────────────────────────────────────────────────────────────
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "gitlens.currentLine.enabled" = true;
        "gitlens.hovers.currentLine.over" = "line";

        # ─── Error Lens ───────────────────────────────────────────────────────
        "errorLens.enabledDiagnosticLevels" = [ "error" "warning" ];
        "errorLens.gutterIconsEnabled" = true;
        "errorLens.followCursor" = "allLines";

        # ─── Better Comments ──────────────────────────────────────────────────
        "better-comments.tags" = [
          { "tag" = "!";    "color" = "#ed8796"; "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
          { "tag" = "?";    "color" = "#8aadf4"; "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = false; }
          { "tag" = "//";   "color" = "#565f89"; "strikethrough" = true;  "underline" = false; "backgroundColor" = "transparent"; "bold" = false; }
          { "tag" = "todo"; "color" = "#e0af68"; "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
          { "tag" = "*";    "color" = "#c4a7e7"; "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
        ];

        # ─── Todo Tree ────────────────────────────────────────────────────────
        "todo-tree.highlights.defaultHighlight" = {
          "foreground" = "#1a1b26";
          "background" = "#c4a7e7";
          "iconColour" = "#c4a7e7";
          "type" = "tag";
        };

        # ─── Code Runner ──────────────────────────────────────────────────────
        "code-runner.runInTerminal" = true;
        "code-runner.saveFileBeforeRun" = true;

        # ─── Spell Checker ────────────────────────────────────────────────────
        "cSpell.language" = "en,es";

        # ─── Explorer y archivos ──────────────────────────────────────────────
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.compactFolders" = false;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.exclude" = {
          "**/.git" = true;
          "**/node_modules" = true;
          "**/__pycache__" = true;
          "**/.ruff_cache" = true;
        };

        # ─── Nix IDE ──────────────────────────────────────────────────────────
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # ─── Telemetría ───────────────────────────────────────────────────────
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
