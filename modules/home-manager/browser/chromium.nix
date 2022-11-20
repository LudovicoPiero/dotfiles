{
  programs.chromium = {
    enable = true;
    #package = pkgs.ungoogled-chromium;
    commandLineArgs = [ "--force-dark-mode" ];
    extensions = [
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; # Ublock Origin
      }
      {
        id = "nngceckbapebfimnlniiiahkandclblb"; # bitwarden - password manager
      }
      {
        id = "aleakchihdccplidncghkekgioiakgal"; # h264ify
      }
      {
        id = "knegaeodgehajemjpfbhlgjdcloklkal"; # Myanimelist Redesign
      }
    ];
  };
}
