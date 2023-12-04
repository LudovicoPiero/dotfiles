{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    };
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "C_Cpp.intelliSenseEngine" = "disabled";
      "editor.cursorBlinking" = "phase";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.fontFamily" = "'Iosevka q', 'Material Design Icons', monospace";
      # "editor.fontLigatures" = "'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig'";
      "editor.fontSize" = 18;
      "editor.formatOnSave" = false;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "none";
      "editor.scrollbar.vertical" = "visible";
      "editor.smoothScrolling" = true;
      "extensions.autoCheckUpdates" = false;
      "files.autoSave" = "onWindowChange";
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${lib.getExe pkgs.nil}";
      # "nix.serverSettings" = {
      #   "formatting" = {
      #     "command" = "${lib.getExe pkgs.alejandra}";
      #   };
      # };
      "update.mode" = "none";
      "vscord.status.details.text.editing" = "In {full_directory_name}";
      "vscord.status.idle.check" = false;
      "vscord.status.problems.enabled" = false;
      "vscord.status.state.text.editing" = "Working on {file_name}{file_extension}";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.limit.value" = 5;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.sideBar.location" = "right";
      "workbench.startupEditor" = "none";
    };
    extensions = with pkgs.vscode-extensions;
      [
        # Theme & flair
        catppuccin.catppuccin-vsc
        pkief.material-icon-theme

        # C/C++
        ms-vscode.cpptools
        llvm-vs-code-extensions.vscode-clangd

        # Nix
        # bbenoist.nix
        jnoortheen.nix-ide
        kamadorueda.alejandra

        # Python
        # ms-python.python

        # Go
        golang.go

        # Lua
        sumneko.lua

        # Rust
        rust-lang.rust-analyzer
        serayuzgur.crates

        # Misc
        usernamehw.errorlens
        eamodio.gitlens
        esbenp.prettier-vscode
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "leonardssh";
          name = "vscord";
          version = "5.1.10";
          sha256 = "1nw3zvlw0bx9yih4z3i20irdw02zz444ncf84xjvjn6h5hw47i3x";
        }
      ];
  };
}
