{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.vscode;
in
{
  imports = [ ./modules.nix ];
  options.myOptions.vscode = {
    enable = mkEnableOption "vscode" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles =
        let
          defaultExtensions =
            with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
              # Themes, etc
              catppuccin.catppuccin-vsc
              pkief.material-icon-theme
              leonardssh.vscord # Discord RPC
              (github.copilot.override { meta.license = [ ]; })
              eamodio.gitlens # Gitlens
              aaron-bond.better-comments
            ];

          defaultUserSettings = {
            "editor.minimap.enabled" = false;
            "editor.formatOnSave" = true;
            "explorer.confirmDragAndDrop" = false;
            "workbench.colorTheme" = "Catppuccin Mocha";
            "workbench.iconTheme" = "material-icon-theme";
            "editor.rulers" = [ 100 ];
            "files.autoGuessEncoding" = true;
            "update.mode" = "none";
            "telemetry.telemetryLevel" = "off";
            "catppuccin.bracketMode" = "neovim";
            "vscord.app.name" = "VSCodium";
            "git.alwaysSignOff" = true;
            "github.gitProtocol" = "ssh";
            "merge-conflict.autoNavigateNextConflict.enabled" = true;

            # Fonts
            "editor.fontLigatures" = false;
            "editor.fontSize" = config.myOptions.fonts.size;
            "editor.fontFamily" =
              "'${config.myOptions.fonts.terminal.name} Semibold', '${config.myOptions.fonts.icon.name}', monospace";
            "editor.inlayHints.fontFamily" =
              "'${config.myOptions.fonts.terminal.name} Semibold', '${config.myOptions.fonts.icon.name}', monospace";
            "terminal.integrated.fontFamily" =
              "'${config.myOptions.fonts.terminal.name} Semibold', '${config.myOptions.fonts.icon.name}', monospace";
            "gitlens.blame.fontFamily" =
              "'${config.myOptions.fonts.terminal.name} Semibold', '${config.myOptions.fonts.icon.name}', monospace";
            "notebook.outpout.fontFamily" =
              "'${config.myOptions.fonts.terminal.name} Semibold', '${config.myOptions.fonts.icon.name}', monospace";
          };
        in
        {
          cpp = {
            extensions =
              with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
              defaultExtensions
              ++ [
                # C++
                ms-vscode.cmake-tools
                llvm-vs-code-extensions.vscode-clangd
                vadimcn.vscode-lldb
              ];
            userSettings = defaultUserSettings // {
              "clangd.path" = ''${lib.getExe' pkgs.clang-tools "clangd"}'';
              "cmake.cmakePath" = "${lib.getExe pkgs.cmake}";
            };
          };

          nix = {
            extensions =
              with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
              defaultExtensions
              ++ [
                jnoortheen.nix-ide
                arrterian.nix-env-selector
              ];

            userSettings = defaultUserSettings // {
              "nixEnvSelector.useFlakes" = true;
              "nixEnvSelector.suggestion" = false;
              "nix.enableLanguageServer" = true;
              "nix.formatterPath" = "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}";
              "nix.serverPath" = "${lib.getExe pkgs.nixd}";
              "nix.serverSettings" = {
                nixd = {
                  formatting = {
                    command = [ "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}" ];
                  };
                  nixpkgs = {
                    "expr" = "import <nixpkgs> {  }";
                  };
                  options = {
                    nixos.expr = ''(builtins.getFlake \"${inputs.self}\").nixosConfigurations.sforza.options'';
                  };
                };
              };
            };
          };

          python = {
            extensions =
              with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
              defaultExtensions
              ++ [
                ms-python.python
                (ms-python.vscode-pylance.override { meta.license = [ ]; })
                njpwerner.autodocstring
              ];

            userSettings = defaultUserSettings // {
              "python.analysis.autoFormatStrings" = true;
              "python.analysis.autoImportCompletions" = true;
              "python.analysis.completeFunctionParens" = true;
              "python.analysis.typeCheckingMode" = "standard";
              "python.defaultInterpreterPath" = ''${lib.getExe' pkgs.python3 "python"}'';
              "python.formatting.blackPath" = "${pkgs.black}/bin/black";
              "python.formatting.provider" = "black";
            };
          };

          rust = {
            extensions =
              with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
              defaultExtensions
              ++ [
                rust-lang.rust-analyzer
                (fill-labs.dependi.override { meta.license = [ ]; })
                tamasfe.even-better-toml
                lorenzopirro.rust-flash-snippets
              ];

            userSettings = defaultUserSettings // {
              "rust-analyzer.server.path" = "${lib.getExe pkgs.rust-analyzer}";
              "rust-analyzer.check.command" = "${lib.getExe pkgs.clippy}";
              "rust-analyzer.inlayHints.typeHints.enable" = false;
              "rust-analyzer.rustfmt.overrideCommand" = [ (lib.getExe pkgs.rustPackages.rustfmt) ];
              "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";
            };
          };

          default = {
            extensions = defaultExtensions;
            userSettings = defaultUserSettings;
          };
        };
    };
  };
}
