{ pkgs, lib, ... }:
let
  _ = lib.getExe;
in
{
  programs.fish.enable = true;
  users.users.rei.shell = pkgs.fish;

  hm = {
    home.packages = with pkgs; [
      fzf
      eza
      bat
      zoxide
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        # Disable greeting
        function fish_greeting
        end

        set -gx EDITOR nvim

        ${_ pkgs.starship} init fish | source
        ${_ pkgs.nix-your-shell} fish | source
        ${_ pkgs.any-nix-shell} fish --info-right | source
        ${_ pkgs.zoxide} init fish | source
        ${_ pkgs.direnv} hook fish | source

        set -p fish_function_path ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_functions.d
        set -p fish_complete_path ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_completions.d
        source ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_conf.d/fzf.fish

        if functions -q fzf_configure_bindings
          fzf_configure_bindings --directory=\eF --git_log=\cg --history=\cr --variables=\cv
        end

        # Key bindings (Old fish behavior)
        bind alt-backspace backward-kill-word
        bind ctrl-alt-h backward-kill-word
        bind ctrl-backspace backward-kill-token
        bind alt-delete kill-word
        bind ctrl-delete kill-token
      '';

      shellAliases = {
        v = "nvim";
        c = "cd $HOME/Code/dotfiles/";

        l = "${pkgs.eza}/bin/eza --icons=always --git -l";
        t = "${pkgs.eza}/bin/eza --icons=always --git --tree";
        ls = "${pkgs.eza}/bin/eza --icons=always --git";
        la = "${pkgs.eza}/bin/eza --icons=always --git -a";
        ll = "${pkgs.eza}/bin/eza --icons=always --git -l";
        lt = "${pkgs.eza}/bin/eza --icons=always --git --tree";

        # Git shortcuts
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gb = "git branch";
        gc = "git commit -v";
        gcm = "git commit -m";
        gco = "git checkout";
        gd = "git diff";
        gf = "git fetch";
        gl = "git log --oneline --graph --decorate";
        gp = "git push";
        gpl = "git pull";
        gst = "git status";
      };

      functions = {
        fe = {
          body = ''
            set pattern (or $argv[1] "")
            set selected_file ( ${pkgs.ripgrep}/bin/rg --no-heading --line-number "$pattern" | \
                ${pkgs.fzf}/bin/fzf --delimiter : --with-nth 1,2,3 \
                    --preview "${pkgs.bat}/bin/bat --style=numbers --color=always {1} --highlight-line {2}" )

            if test -n "$selected_file"
                set file (string split -f1 ":" $selected_file)
                set line (string split -f2 ":" $selected_file)
                nvim +$line $file
            end
          '';
        };

        fef = {
          body = ''
            set dir (or $argv[1] .)
            set selected_file ( ${pkgs.ripgrep}/bin/rg --files $dir \
                | ${pkgs.fzf}/bin/fzf --preview "${pkgs.bat}/bin/bat --style=numbers --color=always {}" )

            if test -n "$selected_file"
                nvim $selected_file
            end
          '';
        };
      };
    };
  };
}
