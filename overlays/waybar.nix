final: prev: {
  waybar = prev.waybar.overrideAttrs (o: {
    src = final.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "41164905351436db3a124207261f9dd759c6fa1b";
      hash = "sha256-aogiOj4pe2AJYxQFh8Dw6xQ2Tb6v4W9zwbGX4t2mStI=";
    };
    mesonFlags = o.mesonFlags ++ ["-Dexperimental=true"];
    patchPhase = ''
      substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
    '';
  });
}
