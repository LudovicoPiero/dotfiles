final: prev: {
  discord-canary = prev.discord-canary.override {
    nss = final.nss_latest;
    withOpenASAR = true;
    withTTS = true;
    withVencord = true;
  };
}
