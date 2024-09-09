# https://github.com/n3oney/nixus/blob/main/modules/programs/discord/discord.nix
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.vesktop.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./__readonlyFix.patch ];
      postFixup =
        old.postFixup
        + ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer --enable-wayland-ime"
        '';
    }))
  ];

  xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
    discordBranch = "canary";
    firstLaunch = false;
    minimizeToTray = false;
    arRPC = "on";
    splashColor = "rgb(219, 222, 225)";
    splashBackground = "rgb(49, 51, 56)";
    enableMenu = false;
    staticTitle = false;
  };

  xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
    notifyAboutUpdates = false;
    autoUpdate = false;
    autoUpdateNotification = false;
    useQuickCss = true;
    enabledThemes = [
      "#https://luckfire.github.io/amoled-cord/src/amoled-cord.css"
      "#https://raw.githubusercontent.com/tsukki9696/oxocarbon-discord/main/oxocarbondiscord.theme.css"
    ];
    enableReactDevtools = false;
    frameless = false;
    transparent = false;
    winCtrlQ = false;
    disableMinSize = false;
    winNativeTitleBar = false;
    plugins = {
      BadgeAPI = {
        enabled = true;
      };
      CommandsAPI = {
        enabled = true;
      };
      ContextMenuAPI = {
        enabled = true;
      };
      MemberListDecoratorsAPI = {
        enabled = false;
      };
      MessageAccessoriesAPI = {
        enabled = true;
      };
      MessageDecorationsAPI = {
        enabled = false;
      };
      MessageEventsAPI = {
        enabled = true;
      };
      MessagePopoverAPI = {
        enabled = true;
      };
      NoticesAPI = {
        enabled = true;
      };
      ShikiCodeblocks = {
        enabled = true;
        theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/packages/tm-themes/themes/everforest-dark.json";
        tryHljs = "SECONDARY";
        useDevIcon = "COLOR";
        bgOpacity = 100;
      };
      ServerListAPI = {
        enabled = false;
      };
      SettingsStoreAPI = {
        enabled = false;
      };
      NoTrack = {
        enabled = true;
      };
      Settings = {
        enabled = true;
        settingsLocation = "aboveActivity";
      };
      AlwaysAnimate = {
        enabled = false;
      };
      AlwaysTrust = {
        enabled = false;
      };
      AnonymiseFileNames = {
        enabled = true;
        method = 2;
        randomisedLength = 7;
        consistent = "image";
      };
      "WebRichPresence (arRPC)" = {
        enabled = true;
      };
      BANger = {
        enabled = false;
      };
      BetterFolders = {
        enabled = false;
      };
      BetterGifAltText = {
        enabled = false;
      };
      BetterNotesBox = {
        enabled = false;
      };
      BetterRoleDot = {
        enabled = false;
      };
      BetterUploadButton = {
        enabled = false;
      };
      BiggerStreamPreview = {
        enabled = false;
      };
      BlurNSFW = {
        enabled = false;
      };
      CallTimer = {
        enabled = false;
      };
      ClearURLs = {
        enabled = false;
      };
      ColorSighted = {
        enabled = false;
      };
      ConsoleShortcuts = {
        enabled = false;
      };
      CrashHandler = {
        enabled = true;
      };
      CustomRPC = {
        enabled = false;
        type = 0;
        timestampMode = 0;
      };
      DisableDMCallIdle = {
        enabled = false;
      };
      EmoteCloner = {
        enabled = false;
      };
      Experiments = {
        enabled = true;
      };
      F8Break = {
        enabled = false;
      };
      FakeNitro = {
        enabled = true;
        enableEmojiBypass = true;
        enableStickerBypass = true;
        enableStreamQualityBypass = true;
        transformStickers = true;
        transformEmojis = true;
        transformCompoundSentence = false;
        stickerSize = 160;
      };
      FakeProfileThemes = {
        enabled = false;
      };
      FavoriteEmojiFirst = {
        enabled = false;
      };
      FixInbox = {
        enabled = false;
      };
      ForceOwnerCrown = {
        enabled = false;
      };
      FriendInvites = {
        enabled = false;
      };
      GameActivityToggle = {
        enabled = false;
      };
      GifPaste = {
        enabled = false;
      };
      HideAttachments = {
        enabled = false;
      };
      iLoveSpam = {
        enabled = false;
      };
      IgnoreActivities = {
        enabled = false;
      };
      ImageZoom = {
        enabled = false;
      };
      InvisibleChat = {
        enabled = false;
      };
      KeepCurrentChannel = {
        enabled = false;
      };
      LastFMRichPresence = {
        enabled = false;
      };
      LoadingQuotes = {
        enabled = false;
      };
      MemberCount = {
        enabled = false;
      };
      MessageClickActions = {
        enabled = false;
      };
      MessageLinkEmbeds = {
        enabled = true;
        automodEmbeds = "never";
        listMode = "blacklist";
        idList = "";
      };
      MessageLogger = {
        enabled = true;
        deleteStyle = "text";
        ignoreBots = true;
        ignoreSelf = true;
        ignoreUsers = "";
        ignoreChannels = "";
        ignoreGuilds = "";
      };
      MessageTags = {
        enabled = false;
      };
      MoreCommands = {
        enabled = false;
      };
      MoreKaomoji = {
        enabled = true;
      };
      MoreUserTags = {
        enabled = false;
      };
      Moyai = {
        enabled = false;
      };
      MuteNewGuild = {
        enabled = false;
      };
      MutualGroupDMs = {
        enabled = false;
      };
      NoBlockedMessages = {
        enabled = true;
        ignoreBlockedMessages = true;
      };
      NoDevtoolsWarning = {
        enabled = false;
      };
      NoF1 = {
        enabled = false;
      };
      NoPendingCount = {
        enabled = false;
      };
      NoProfileThemes = {
        enabled = false;
      };
      NoReplyMention = {
        enabled = true;
        userList = "728263018567434281";
        shouldPingListed = true;
        inverseShiftReply = false;
      };
      NoScreensharePreview = {
        enabled = false;
      };
      NoUnblockToJump = {
        enabled = false;
      };
      NSFWGateBypass = {
        enabled = false;
      };
      oneko = {
        enabled = false;
      };
      OpenInApp = {
        enabled = false;
      };
      "Party mode ud83cudf89" = {
        enabled = false;
      };
      PermissionsViewer = {
        enabled = false;
      };
      petpet = {
        enabled = false;
      };
      PinDMs = {
        enabled = false;
      };
      PlainFolderIcon = {
        enabled = false;
      };
      PlatformIndicators = {
        enabled = false;
      };
      PronounDB = {
        enabled = false;
      };
      QuickMention = {
        enabled = false;
      };
      QuickReply = {
        enabled = false;
      };
      ReactErrorDecoder = {
        enabled = false;
      };
      ReadAllNotificationsButton = {
        enabled = false;
      };
      RelationshipNotifier = {
        enabled = false;
      };
      RevealAllSpoilers = {
        enabled = false;
      };
      ReverseImageSearch = {
        enabled = false;
      };
      ReviewDB = {
        enabled = false;
      };
      RoleColorEverywhere = {
        enabled = false;
      };
      SearchReply = {
        enabled = false;
      };
      SendTimestamps = {
        enabled = false;
      };
      ServerListIndicators = {
        enabled = false;
      };
      ShowAllMessageButtons = {
        enabled = false;
      };
      ShowConnections = {
        enabled = false;
      };
      ShowHiddenChannels = {
        enabled = false;
      };
      ShowMeYourName = {
        enabled = false;
      };
      SilentMessageToggle = {
        enabled = false;
      };
      SilentTyping = {
        enabled = false;
      };
      SortFriendRequests = {
        enabled = false;
      };
      SpotifyControls = {
        enabled = false;
      };
      SpotifyCrack = {
        enabled = false;
      };
      SpotifyShareCommands = {
        enabled = false;
      };
      StartupTimings = {
        enabled = false;
      };
      SupportHelper = {
        enabled = true;
      };
      TextReplace = {
        enabled = false;
      };
      TimeBarAllActivities = {
        enabled = false;
      };
      Translate = {
        enabled = true;
        autoTranslate = false;
      };
      TypingIndicator = {
        enabled = false;
      };
      TypingTweaks = {
        enabled = false;
      };
      Unindent = {
        enabled = false;
      };
      UnsuppressEmbeds = {
        enabled = false;
      };
      UrbanDictionary = {
        enabled = false;
      };
      UserVoiceShow = {
        enabled = false;
      };
      USRBG = {
        enabled = false;
      };
      UwUifier = {
        enabled = false;
      };
      ValidUser = {
        enabled = true;
      };
      VoiceChatDoubleClick = {
        enabled = true;
      };
      VcNarrator = {
        enabled = false;
      };
      VencordToolbox = {
        enabled = false;
      };
      ViewIcons = {
        enabled = false;
      };
      ViewRaw = {
        enabled = false;
      };
      WebContextMenus = {
        enabled = false;
        addBack = true;
      };
      GreetStickerPicker = {
        enabled = false;
      };
      WhoReacted = {
        enabled = false;
      };
      Wikisearch = {
        enabled = false;
      };
      FavoriteGifSearch = {
        enabled = false;
      };
      SecretRingToneEnabler = {
        enabled = false;
      };
      VoiceMessages = {
        enabled = true;
        noiseSuppression = true;
        echoCancellation = true;
      };
      "AI Noise Suppression" = {
        enabled = true;
        isEnabled = true;
      };
      CopyUserURLs = {
        enabled = false;
      };
      NormalizeMessageLinks = {
        enabled = false;
      };
      PreviewMessage = {
        enabled = false;
      };
      Dearrow = {
        enabled = false;
      };
      FixSpotifyEmbeds = {
        enabled = false;
      };
      OnePingPerDM = {
        enabled = false;
      };
      PermissionFreeWill = {
        enabled = false;
      };
      PictureInPicture = {
        enabled = false;
      };
      ServerProfile = {
        enabled = false;
      };
      ShowTimeouts = {
        enabled = false;
      };
      ThemeAttributes = {
        enabled = false;
      };
      WebKeybinds = {
        enabled = true;
      };
      NoMosaic = {
        enabled = false;
      };
      NoTypingAnimation = {
        enabled = false;
      };
      ClientTheme = {
        enabled = false;
      };
      FixImagesQuality = {
        enabled = false;
      };
      SuperReactionTweaks = {
        enabled = false;
      };
    };
    notifications = {
      timeout = 5000;
      position = "bottom-right";
      useNative = "always";
      logLimit = 50;
    };
    cloud = {
      authenticated = false;
      url = "https://api.vencord.dev/";
      settingsSync = false;
      settingsSyncVersion = 1682768329526;
    };
    macosTranslucency = false;
  };
}
