{
  lib,
  pkgs,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.vscode;
in
{
  options.myOptions.vscode = {
    enable = mkEnableOption "vscode" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      {
        programs.vscode = {
          enable = true;

          profiles.default = {
            extensions =
              with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
                # C++
                ms-vscode.cmake-tools
                llvm-vs-code-extensions.vscode-clangd
                vadimcn.vscode-lldb

                # Python
                ms-python.python
                (ms-python.vscode-pylance.override { meta.license = [ ]; })
                njpwerner.autodocstring

                # Rust
                rust-lang.rust-analyzer
                (fill-labs.dependi.override { meta.license = [ ]; })
                tamasfe.even-better-toml
                lorenzopirro.rust-flash-snippets

                # Nix
                jnoortheen.nix-ide
                arrterian.nix-env-selector

                # Themes, etc
                catppuccin.catppuccin-vsc
                pkief.material-icon-theme
                leonardssh.vscord # Discord RPC
                (github.copilot.override { meta.license = [ ]; })
                eamodio.gitlens # Gitlens
                aaron-bond.better-comments
              ];

            userSettings = {
              "editor.minimap.enabled" = false;
              "editor.rulers" = [ 100 ];
              "files.autoGuessEncoding" = true;
              "update.mode" = "none";
              "telemetry.telemetryLevel" = "off";

              # C++
              "clangd.path" = ''${lib.getExe' pkgs.clang-tools "clangd"}'';
              "cmake.cmakePath" = "${lib.getExe pkgs.cmake}";

              # Python
              "python.analysis.autoImportCompletions" = true;
              "python.analysis.typeCheckingMode" = "standard";
              "python.defaultInterpreterPath" = ''${lib.getExe' pkgs.python3 "python"}'';
              "python.formatting.blackPath" = "${pkgs.black}/bin/black";
              "python.formatting.provider" = "black";

              # Rust
              "rust-analyzer.server.path" = "${lib.getExe pkgs.rust-analyzer}";
              "rust-analyzer.check.command" = "${lib.getExe pkgs.clippy}";
              "rust-analyzer.inlayHints.typeHints.enable" = false;
              "rust-analyzer.rustfmt.overrideCommand" = [ (lib.getExe pkgs.rustPackages.rustfmt) ];
              "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";

              # Nix
              "nixEnvSelector.suggestion" = false;
              "nix.enableLanguageServer" = true;
              "nix.formatterPath" = "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}";
              "nix.serverPath" = "${lib.getExe pkgs.nixd}";
              "nix.serverSettings" = {
                nixd = {
                  formatting = {
                    command = [ "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}" ];
                  };
                  options =
                    let
                      getFlake = ''(builtins.getFlake "${self}")'';
                    in
                    {
                      nixos.expr = ''${getFlake}.nixosConfigurations.sforza.options'';
                      nixvim.expr = ''${getFlake}.packages.${pkgs.stdenv.hostPlatform.system}.nvim.options'';
                      home-manager.expr = ''${getFlake}.homeConfigurations."airi@sforza".options'';
                      flake-parts.expr = ''let flake = ${getFlake}; in flake.debug.options // flake.currentSystem.options'';
                    };
                };
              };

              "editor.formatOnSave" = true;
              "explorer.confirmDragAndDrop" = false;
              "editor.fontFamily" = "'${osConfig.vars.mainFont}', 'Material Design Icons', monospace";
              "editor.fontSize" = 15;

              "workbench.colorCustomizations" = null;
              "workbench.colorTheme" = "${config.colorScheme.name}";
              "workbench.iconTheme" = "material-icon-theme";
            };
          };
        };
      }; # For Home-Manager options
  };
}
