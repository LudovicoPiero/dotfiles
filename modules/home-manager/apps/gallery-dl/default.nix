{pkgs, ...}: {
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor = {
        base-directory = "~/gallery-dl";
        parent-directory = false;
        postprocessors = null;
        archive = null;
        cookies = null;
        cookies-update = true;
        proxy = null;
        skip = true;

        user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0";
        retries = 3;
        timeout = 30.0;
        verify = true;
        fallback = true;

        twitter = {
          cards = true;
          conversations = true;
          pinned = true;
          quoted = true;
          replies = true;
          retweets = true;
          text-tweets = false;
          twitpic = true;
          users = "timeline";
          videos = true;
        };
      };
    };
  };
}
