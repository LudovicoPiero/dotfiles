{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # use vscode because copilot no worky :(
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      kamadorueda.alejandra
      kamikillerto.vscode-colorize # css background
      catppuccin.catppuccin-vsc # Color theme
      github.copilot
      pkief.material-icon-theme
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss
    ];
    # userSettings = {
    #   "emmet.triggerExpansionOnTab" = true;
    #   "emmet.includeLanguages" = {
    #     "javascript" = "javascriptreact";
    #     "vue-html" = "html";
    #     "razor" = "html";
    #     "plaintext" = "jade";
    #   };
    #   "files.autoSave" = "afterDelay";
    #   "workbench.editorAssociations" = {"*.ipynb" = "jupyter-notebook";};
    #   "workbench.iconTheme" = "material-icon-theme";
    #   "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
    #   "editor.letterSpacing" = 1.1;
    #   "editor.lineHeight" = 22;
    #   "editor.fontLigatures" = "'cv01', 'cv02', 'cv12', 'ss05', 'ss04', 'ss03', 'cv31', 'cv29', 'cv24', 'cv25', 'cv26', 'ss07', 'zero', 'onum'";
    #   "editor.codeActionsOnSave" = {"source.nix" = true;};
    #   "editor.minimap.enabled" = false;
    #   "material-icon-theme.folders.theme" = "specific";
    #   "material-icon-theme.folders.color" = "#7cb342";
    #   "workbench.startupEditor" = "newUntitledFile";
    #   "git.autofetch" = true;
    #   "notebook.cellToolbarLocation" = {
    #     "default" = "right";
    #     "jupyter-notebook" = "left";
    #   };
    #   "editor.fontSize" = 14;
    #   "git.enableSmartCommit" = true;
    #   "git.confirmSync" = false;
    #   "security.workspace.trust.untrustedFiles" = "open";
    #   "security.workspace.trust.startupPrompt" = "never";
    #   "editor.inlineSuggest.enabled" = true;
    #   "gitlens.defaultTimeFormat" = null;
    #   "github.copilot.enable" = {"*" = true;};
    #   "javascript.updateImportsOnFileMove.enabled" = "always";
    #   "security.workspace.trust.enabled" = false;
    #   "editor.multiCursorModifier" = "ctrlCmd";
    #   "editor.cursorBlinking" = "phase";
    #   "editor.cursorStyle" = "block";
    #   "editor.cursorSmoothCaretAnimation" = true;
    #   "editor.smoothScrolling" = true;
    #   "terminal.integrated.defaultProfile.windows" = "PowerShell";
    #   "workbench.colorTheme" = "Catppuccin Mocha";
    #   "html.completion.attributeDefaultValue" = "singlequotes";
    #   "javascript.preferences.quoteStyle" = "single";
    #   "typescript.preferences.quoteStyle" = "single";
    #   "typescript.tsdk" = "./node_modules/typescript/lib";
    #   "explorer.confirmDelete" = false;
    #   "editor.bracketPairColorization.enabled" = true;
    #   "editor.guides.bracketPairs" = "active";
    #   "editor.codeLensFontFamily" = "FiraCode Nerd Font";
    #   "workbench.sideBar.location" = "right";
    #   "editor.insertSpaces" = false;
    #   "editor.detectIndentation" = false;
    #   "window.menuBarVisibility" = "compact";
    #   "editor.formatOnSave" = true;
    #   "[jsonc]" = {
    #     "editor.defaultFormatter" = "vscode.json-language-features";
    #   };
    #   "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
    #   "[css]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
    #   "[scss]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
    #   "[typescriptreact]" = {
    #     "editor.defaultFormatter" = "esbenp.prettier-vscode";
    #   };
    #   "[nix]" = {};
    #   "vscord.status.idle.check" = false;
    #   "vscord.status.problems.enabled" = false;
    #   "vscord.status.button.active.url" = "https=//www.youtube.com/watch?v=dQw4w9WgXcQ";
    #   "vscord.status.state.text.editing" = "Working on {file_name}{file_extension}";
    #   "remote.SSH.defaultExtensions" = ["gitpod.gitpod-remote-ssh"];
    #   "git.ignoreMissingGitWarning" = true;
    #   "explorer.confirmDragAndDrop" = false;
    #   "terminal.integrated.fontFamily" = "monospace";
    #   "diffEditor.ignoreTrimWhitespace" = false;
    #   "workbench.editor.tabSizing" = "shrink";
    #   "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
    #   "workbench.preferredHighContrastLightColorTheme" = "Catppuccin Latte";
    #   "breadcrumbs.enabled" = false;
    # };
  };
}
