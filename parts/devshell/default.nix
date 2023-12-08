# https://github.com/NotAShelf/nyx/blob/main/parts/devShell/default.nix
{
  shellCommands = [
    {
      help = "Lints and suggestions for the nix programming language";
      name = "st";
      command = "statix";
      category = "devos";
    }
    {
      help = "Find and remove unused code in .nix source files";
      name = "ded";
      command = "deadnix";
      category = "devos";
    }
    {
      help = "The Uncompromising Nix Code Formatter";
      name = "ale";
      command = "nixpkgs-fmt";
      category = "devos";
    }
    {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = "treefmt";
      category = "formatter";
    }
    {
      help = "Fetch source from origin";
      name = "pl";
      command = "git pull";
      category = "source control";
    }
    {
      help = "Format source tree and push commited changes to git";
      name = "ps";
      command = "git push";
      category = "source control";
    }
  ];

  env = [
    {
      # make direnv shut up
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
    {
      # Just in case
      name = "EDITOR";
      value = "nvim";
    }
  ];
}
