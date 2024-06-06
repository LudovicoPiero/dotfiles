{
  programs.nixvim = {
    autoCmd = [
      {
        # jumps to the line of the last edit
        event = [ "BufReadPost" ];
        pattern = [ "*" ];
        command = ''
          " Check if the current file is a Git commit message
          if !exists('b:git_commit')
            if line("'\"") > 1 && line("'\"") <= line("$")
              exe "normal! g`\""
            endif
          endif
        '';
      }
    ];
  };
}
