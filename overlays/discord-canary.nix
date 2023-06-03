final: prev: {
  discord-canary = prev.discord-canary.override {
    withOpenASAR = true;
    withTTS = true;
    withVencord = true;
    nss = final.nss_latest;
  };
}
