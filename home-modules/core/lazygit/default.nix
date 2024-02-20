{ config, lib, ... }:
let
  cfg = config.mine.lazygit;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.lazygit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable lazygit and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          windowSize = "normal";
          scrollHeight = 2;
          scrollPastBottom = true;
          scrollOffMargin = 2;
          scrollOffBehavior = "margin";
          sidePanelWidth = 0.3333;
          expandFocusedSidePanel = false;
          mainPanelSplitMode = "flexible";
          enlargedSideViewLocation = "left";
          language = "auto";
          timeFormat = "02 Jan 06";
          shortTimeFormat = "3:04PM";
          theme = {
            activeBorderColor = [
              "green"
              "bold"
            ];
            inactiveBorderColor = [ "white" ];
            searchingActiveBorderColor = [
              "cyan"
              "bold"
            ];
            optionsTextColor = [ "blue" ];
            selectedLineBgColor = [ "blue" ];
            cherryPickedCommitBgColor = [ "cyan" ];
            cherryPickedCommitFgColor = [ "blue" ];
            unstagedChangesColor = [ "red" ];
            defaultFgColor = [ "default" ];
          };
          commitLength = {
            show = true;
          };
          mouseEvents = true;
          skipDiscardChangeWarning = false;
          skipStashWarning = false;
          showFileTree = true;
          showListFooter = true;
          showRandomTip = true;
          showBranchCommitHash = false;
          showBottomLine = true;
          showPanelJumps = true;
          showCommandLog = true;
          showIcons = false;
          nerdFontsVersion = "";
          showFileIcons = true;
          commandLogSize = 8;
          splitDiff = "auto";
          skipRewordInEditorWarning = false;
          border = "rounded";
          animateExplosion = true;
          portraitMode = "auto";
        };
        git = {
          paging = {
            colorArg = "always";
            useConfig = false;
          };
          commit = {
            signOff = true;
          };
          merging = {
            manualCommit = false;
            args = "";
          };
          log = {
            order = "topo-order";
            showGraph = "always";
            showWholeGraph = false;
          };
          skipHookPrefix = "WIP";
          mainBranches = [
            "master"
            "main"
          ];
          autoFetch = true;
          autoRefresh = true;
          fetchAll = true;
          branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
          allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
          overrideGpg = false;
          disableForcePushing = false;
          parseEmoji = false;
        };
        os = {
          editPreset = "nvim";
          open = "xdg-open {{filename}} >/dev/null";
        };
        refresher = {
          refreshInterval = 10;
          fetchInterval = 60;
        };
        update = {
          method = "prompt";
          days = 14;
        };
        confirmOnQuit = false;
        quitOnTopLevelReturn = false;
        disableStartupPopups = false;
        notARepository = "prompt";
        promptToReturnFromSubprocess = true;
      };
    };
  };
}
