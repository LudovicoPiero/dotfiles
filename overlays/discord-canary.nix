final: prev: {
  discord-canary = prev.discord-canary.override {
    withOpenASAR = true;
    withTTS = true;
    nss = final.nss_latest;
  };
}
