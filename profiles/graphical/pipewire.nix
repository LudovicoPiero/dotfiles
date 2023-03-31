{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.etc = {
    "pipewire/pipewire-pulse.conf.d/00-autoswitch.conf".text = ''
      pulse.cmd = [
        { cmd = "load-module" args = "module-always-sink" flags = [ ] }
        { cmd = "load-module" args = "module-switch-on-connect" }
      ]
    '';
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
}
