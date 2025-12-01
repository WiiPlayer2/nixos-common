{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  colors = config.lib.stylix.colors;
  cfg = config.programs.vscode;
in
{
  home.packages = mkIf cfg.enable (
    with pkgs;
    [
      nil
      nixfmt-rfc-style
    ]
  );

  programs.vscode = {
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        wakatime.vscode-wakatime
        jnoortheen.nix-ide
        jgclark.vscode-todo-highlight
        gruntfuggly.todo-tree
      ];
      userSettings = {
        "files.autoSave" = "afterDelay";
        "git.enableSmartCommit" = true;
        "explorer.confirmDelete" = false;
        "git.confirmSync" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.suggestSelection" = "first";
        "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
        "files.insertFinalNewline" = true;
        "explorer.confirmDragAndDrop" = false;
        "platformio-ide.disablePIOHomeStartup" = true;
        "workbench.editorAssociations" = {
          "*.ipynb" = "jupyter-notebook";
        };
        "editor.fontLigatures" = true;
        "workbench.startupEditor" = "none";
        "files.associations" = {
          "*.gotmpl" = "helm";
        };
        "[json]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "omnisharp.enableRoslynAnalyzers" = true;
        "omnisharp.path" = "latest";
        "diffEditor.ignoreTrimWhitespace" = false;
        "[python]" = {
          "editor.formatOnType" = true;
        };
        "editor.accessibilitySupport" = "off";
        "debug.onTaskErrors" = "showErrors";
        "security.workspace.trust.untrustedFiles" = "open";
        "accessibility.signals.terminalBell" = {
          "sound" = "on";
        };
        "terminal.integrated.enableVisualBell" = true;
        "git.blame.editorDecoration.enabled" = true;
        "git.openRepositoryInParentFolders" = "always";
        "git-assistant.checkConfigVariables" = "disabled";
        "editor.tokenColorCustomizations" = {
          "[Stylix]" = {
            "comments" = "#${colors.base07}";
          };
        };
        "nix.enableLanguageServer" = true;
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };
        "chat.agent.enabled" = false;
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
      };
    };
  };
}
