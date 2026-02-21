{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc-icons

        vue.volar
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode

        ms-python.python
        ms-python.vscode-pylance

        jnoortheen.nix-ide

        ms-azuretools.vscode-docker

        eamodio.gitlens

        christian-kohler.path-intellisense
        redhat.vscode-yaml

        usernamehw.errorlens
        streetsidesoftware.code-spell-checker
        aaron-bond.better-comments
        gruntfuggly.todo-tree
        mikestead.dotenv
        formulahendry.code-runner
      ];

      userSettings = {
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.iconTheme" = "catppuccin-mocha";

        "editor.semanticHighlighting.enabled" = false;

        "workbench.colorCustomizations" = {
          "editor.background"                 = c.base;
          "editor.foreground"                 = c.text;
          "editorCursor.foreground"           = c.oro;
          "editorLineNumber.foreground"       = c.surface2;
          "editorLineNumber.activeForeground" = c.subtext;
          "editor.selectionBackground"        = "${c.surface1}88";
          "editor.wordHighlightBackground"    = "${c.surface1}44";
          "editorBracketMatch.border"         = c.oro;
          "editorBracketMatch.background"     = "${c.surface0}44";
          "editorIndentGuide.background"      = c.surface0;
          "editorIndentGuide.activeBackground" = c.surface1;

          "sideBar.background"               = c.mantle;
          "sideBar.foreground"               = c.text;
          "sideBarTitle.foreground"           = c.subtext;
          "sideBarSectionHeader.background"   = c.surface0;
          "sideBarSectionHeader.foreground"   = c.text;

          "activityBar.background"            = c.mantle;
          "activityBar.foreground"            = c.oro;
          "activityBar.inactiveForeground"    = c.subtext;
          "activityBarBadge.background"       = c.oro;
          "activityBarBadge.foreground"       = c.base;

          "titleBar.activeBackground"         = c.mantle;
          "titleBar.activeForeground"         = c.text;
          "titleBar.inactiveBackground"       = c.mantle;
          "titleBar.inactiveForeground"       = c.subtext;

          "tab.activeBackground"              = c.base;
          "tab.activeBorderTop"               = c.oro;
          "tab.activeForeground"              = c.text;
          "tab.inactiveBackground"            = c.mantle;
          "tab.inactiveForeground"            = c.subtext;
          "tab.border"                        = c.mantle;
          "tab.hoverBackground"              = c.surface0;
          "editorGroupHeader.tabsBackground"  = c.mantle;

          "statusBar.background"              = c.sangre;
          "statusBar.foreground"              = c.text;
          "statusBar.debuggingBackground"     = c.ambar;
          "statusBar.debuggingForeground"     = c.base;
          "statusBar.noFolderBackground"      = c.surface0;

          "terminal.background"               = c.base;
          "terminal.foreground"               = c.text;
          "terminalCursor.foreground"         = c.oro;

          "panel.background"                  = c.base;
          "panel.border"                      = c.surface1;
          "panelTitle.activeBorder"           = c.oro;
          "panelTitle.activeForeground"       = c.text;
          "panelTitle.inactiveForeground"     = c.subtext;

          "list.activeSelectionBackground"    = "${c.surface1}aa";
          "list.activeSelectionForeground"    = c.text;
          "list.hoverBackground"              = "${c.surface0}88";
          "list.focusOutline"                 = c.oro;
          "list.inactiveSelectionBackground"  = "${c.surface0}88";
          "list.highlightForeground"          = c.oro;

          "input.background"                  = c.surface0;
          "input.border"                      = c.surface1;
          "input.foreground"                  = c.text;
          "input.placeholderForeground"       = c.subtext;
          "focusBorder"                       = c.oro;

          "badge.background"                  = c.oro;
          "badge.foreground"                  = c.base;

          "scrollbarSlider.background"        = "${c.surface1}66";
          "scrollbarSlider.hoverBackground"   = "${c.surface2}88";
          "scrollbarSlider.activeBackground"  = "${c.surface2}aa";

          "editorWidget.background"           = c.surface0;
          "editorWidget.border"               = c.surface1;
          "editorWidget.foreground"           = c.text;

          "editorSuggestWidget.background"    = c.surface0;
          "editorSuggestWidget.border"        = c.surface1;
          "editorSuggestWidget.foreground"    = c.text;
          "editorSuggestWidget.highlightForeground" = c.oro;
          "editorSuggestWidget.selectedBackground"  = c.surface1;

          "dropdown.background"               = c.surface0;
          "dropdown.border"                   = c.surface1;
          "dropdown.foreground"               = c.text;

          "commandCenter.background"          = c.surface0;
          "commandCenter.border"              = c.surface1;
          "commandCenter.foreground"          = c.text;

          "breadcrumb.background"             = c.base;
          "breadcrumb.foreground"             = c.subtext;
          "breadcrumb.focusForeground"        = c.text;
          "breadcrumb.activeSelectionForeground" = c.oro;

          "notificationCenterHeader.background" = c.surface0;
          "notifications.background"            = c.surface0;
          "notifications.border"                = c.surface1;
          "notifications.foreground"            = c.text;

          "editorGutter.addedBackground"      = c.oliva;
          "editorGutter.modifiedBackground"   = c.ambar;
          "editorGutter.deletedBackground"    = c.rojo;

          "gitDecoration.addedResourceForeground"       = c.oliva;
          "gitDecoration.modifiedResourceForeground"    = c.ambar;
          "gitDecoration.deletedResourceForeground"     = c.rojo;
          "gitDecoration.untrackedResourceForeground"   = c.oliva;

          "minimap.background"                = c.base;
          "editorOverviewRuler.border"        = c.surface1;

          "peekView.border"                   = c.oro;
          "peekViewEditor.background"         = c.surface0;
          "peekViewResult.background"         = c.mantle;
          "peekViewTitle.background"          = c.surface0;

          "editorError.foreground"            = c.rojo;
          "editorWarning.foreground"          = c.ambar;
          "editorInfo.foreground"             = c.oro;

          "button.background"                 = c.oro;
          "button.foreground"                 = c.base;
          "button.hoverBackground"            = c.ambar;
          "button.secondaryBackground"        = c.surface1;
          "button.secondaryForeground"        = c.text;

          "selection.background"              = "${c.oro}44";

          "quickInput.background"             = c.surface0;
          "quickInput.foreground"             = c.text;
          "quickInputList.focusBackground"    = c.surface1;
          "quickInputList.focusForeground"    = c.text;
        };

        "editor.tokenColorCustomizations" = {
          "textMateRules" = [
            { "scope" = [ "keyword" "keyword.control" "keyword.operator.new" "keyword.operator.expression" "storage.type" "storage.modifier" ];
              "settings" = { "foreground" = c.rojo; }; }
            { "scope" = [ "entity.name.function" "support.function" "meta.function-call" ];
              "settings" = { "foreground" = c.oro; }; }
            { "scope" = [ "entity.name.type" "entity.name.class" "support.type" "support.class" ];
              "settings" = { "foreground" = c.oro; }; }
            { "scope" = [ "string" "string.quoted" "string.template" ];
              "settings" = { "foreground" = c.oliva; }; }
            { "scope" = [ "constant.numeric" ];
              "settings" = { "foreground" = c.ambar; }; }
            { "scope" = [ "constant.language" "variable.language" "variable.language.this" ];
              "settings" = { "foreground" = c.rojo; }; }
            { "scope" = [ "variable" "variable.other" "variable.parameter" ];
              "settings" = { "foreground" = c.text; }; }
            { "scope" = [ "variable.other.property" "meta.property-name" "support.type.property-name" ];
              "settings" = { "foreground" = c.ambar; }; }
            { "scope" = [ "comment" "comment.line" "comment.block" "punctuation.definition.comment" ];
              "settings" = { "foreground" = c.surface2; "fontStyle" = "italic"; }; }
            { "scope" = [ "entity.name.tag" ];
              "settings" = { "foreground" = c.rojo; }; }
            { "scope" = [ "entity.other.attribute-name" ];
              "settings" = { "foreground" = c.ambar; }; }
            { "scope" = [ "punctuation" "meta.brace" "punctuation.definition.tag" ];
              "settings" = { "foreground" = c.subtext; }; }
            { "scope" = [ "keyword.operator" "keyword.operator.assignment" ];
              "settings" = { "foreground" = c.arena; }; }
            { "scope" = [ "entity.name.module" "support.module" "entity.name.namespace" ];
              "settings" = { "foreground" = c.oro; }; }
            { "scope" = [ "markup.heading" "entity.name.section" ];
              "settings" = { "foreground" = c.oro; "fontStyle" = "bold"; }; }
            { "scope" = [ "string.regexp" ];
              "settings" = { "foreground" = c.ambar; }; }
            { "scope" = [ "constant.character.escape" ];
              "settings" = { "foreground" = c.arena; }; }
            { "scope" = [ "meta.import" "keyword.control.import" "keyword.control.from" ];
              "settings" = { "foreground" = c.rojo; }; }
            { "scope" = [ "entity.other.inherited-class" ];
              "settings" = { "foreground" = c.oro; }; }
            { "scope" = [ "meta.decorator" "punctuation.decorator" ];
              "settings" = { "foreground" = c.ambar; }; }
          ];
        };

        "editor.fontFamily" = "'FiraCode Nerd Font', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;

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

        "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
        "editorBracketPairGuide.activeBackground1" = c.oro;
        "editorBracketPairGuide.activeBackground2" = c.ambar;
        "editorBracketPairGuide.activeBackground3" = c.rojo;

        "editor.suggestOnTriggerCharacters" = true;
        "editor.quickSuggestions" = {
          "other" = "on";
          "comments" = "off";
          "strings" = "on";
        };
        "editor.parameterHints.enabled" = true;
        "editor.inlayHints.enabled" = "on";
        "editor.acceptSuggestionOnCommitCharacter" = true;

        "files.autoSave" = "off";
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

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

        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.smoothScrolling" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";

        "vue.server.hybridMode" = true;
        "vue.inlayHints.inlineHandlerLeadingComments" = true;

        "typescript.preferences.quoteStyle" = "double";
        "typescript.preferences.importModuleSpecifier" = "relative";
        "typescript.suggest.autoImports" = true;
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "javascript.updateImportsOnFileMove.enabled" = "always";

        "eslint.validate" = [ "javascript" "typescript" "vue" ];
        "eslint.useFlatConfig" = true;

        "tailwindCSS.emmetCompletions" = true;
        "tailwindCSS.includeLanguages" = {
          "vue" = "html";
        };
        "tailwindCSS.experimental.classRegex" = [
          [ "clsx\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
          [ "cn\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
        ];

        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;
        "ruff.lint.enable" = true;
        "ruff.format.enable" = true;

        "git.autofetch" = true;
        "git.confirmSync" = false;
        "gitlens.currentLine.enabled" = true;
        "gitlens.hovers.currentLine.over" = "line";

        "errorLens.enabledDiagnosticLevels" = [ "error" "warning" ];
        "errorLens.gutterIconsEnabled" = true;
        "errorLens.followCursor" = "allLines";

        "better-comments.tags" = [
          { "tag" = "!";    "color" = c.rojo;     "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
          { "tag" = "?";    "color" = c.cobre;     "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = false; }
          { "tag" = "//";   "color" = c.surface2; "strikethrough" = true;  "underline" = false; "backgroundColor" = "transparent"; "bold" = false; }
          { "tag" = "todo"; "color" = c.oro;      "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
          { "tag" = "*";    "color" = c.oro;      "strikethrough" = false; "underline" = false; "backgroundColor" = "transparent"; "bold" = true; }
        ];

        "todo-tree.highlights.defaultHighlight" = {
          "foreground" = c.base;
          "background" = c.oro;
          "iconColour" = c.oro;
          "type" = "tag";
        };

        "code-runner.runInTerminal" = true;
        "code-runner.saveFileBeforeRun" = true;

        "cSpell.language" = "en,es";

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

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
