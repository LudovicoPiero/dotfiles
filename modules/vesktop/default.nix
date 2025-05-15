#NOTE: GOOD LUCK SCROLLING :P
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    types
    mkOption
    ;

  cfg = config.myOptions.vesktop;
in
{
  options.myOptions.vesktop = {
    enable = mkEnableOption "Vesktop";

    package = mkPackageOption pkgs "vesktop" {
      example = "pkgs.vesktop.override { withTTS = false; }";
    };

    themeLinks = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      files = {
        ".config/vesktop/settings.json".text = builtins.toJSON {
          arRPC = true;
          discordBranch = "canary";
          enableMenu = false;
          firstLaunch = false;
          hardwareAcceleration = true;
          minimizeToTray = false;
          splashBackground = "rgb(49, 51, 56)";
          splashColor = "rgb(219, 222, 225)";
          staticTitle = false;
        };

        ".config/vesktop/settings/settings.json".text = builtins.toJSON {
          # See https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
          autoUpdate = false;
          autoUpdateNotification = false;
          useQuickCss = true;
          notifyAboutUpdates = false;
          enableReactDevtools = false;
          enabledThemes = [ ];
          themeLinks = cfg.themeLinks;

          /*
            NOTE:
            See https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
            for available options
          */
          plugins = {
            ChatInputButtonAPI = {
              enabled = true;
            };
            CommandsAPI = {
              enabled = true;
            };
            DynamicImageModalAPI = {
              enabled = false;
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
              enabled = false;
            };
            MessageUpdaterAPI = {
              enabled = true;
            };
            ServerListAPI = {
              enabled = false;
            };
            UserSettingsAPI = {
              enabled = true;
            };
            AccountPanelServerProfile = {
              enabled = false;
            };
            AlwaysAnimate = {
              enabled = false;
            };
            AlwaysExpandRoles = {
              enabled = false;
            };
            AlwaysTrust = {
              enabled = false;
            };
            AnonymiseFileNames = {
              enabled = true;
            };
            AppleMusicRichPresence = {
              enabled = false;
            };
            "WebRichPresence (arRPC)" = {
              enabled = false;
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
            BetterGifPicker = {
              enabled = false;
            };
            BetterNotesBox = {
              enabled = false;
            };
            BetterRoleContext = {
              enabled = false;
            };
            BetterRoleDot = {
              enabled = false;
            };
            BetterSessions = {
              enabled = false;
            };
            BetterSettings = {
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
            ClientTheme = {
              enabled = false;
            };
            ColorSighted = {
              enabled = false;
            };
            ConsoleJanitor = {
              enabled = false;
            };
            ConsoleShortcuts = {
              enabled = false;
            };
            CopyEmojiMarkdown = {
              enabled = false;
            };
            CopyFileContents = {
              enabled = false;
            };
            CopyUserURLs = {
              enabled = false;
            };
            CrashHandler = {
              enabled = true;
            };
            CtrlEnterSend = {
              enabled = false;
            };
            CustomRPC = {
              enabled = false;
            };
            CustomIdle = {
              enabled = false;
            };
            Dearrow = {
              enabled = false;
            };
            Decor = {
              enabled = false;
            };
            DisableCallIdle = {
              enabled = false;
            };
            DontRoundMyTimestamps = {
              enabled = false;
            };
            EmoteCloner = {
              enabled = false;
            };
            Experiments = {
              enabled = false;
            };
            F8Break = {
              enabled = false;
            };
            FakeNitro = {
              enabled = true;
              enableStickerBypass = true;
              enableStreamQualityBypass = true;
              enableEmojiBypass = true;
              transformEmojis = true;
              transformStickers = true;
              transformCompoundSentence = false;
            };
            FakeProfileThemes = {
              enabled = false;
            };
            FavoriteEmojiFirst = {
              enabled = false;
            };
            FavoriteGifSearch = {
              enabled = false;
            };
            FixCodeblockGap = {
              enabled = false;
            };
            FixImagesQuality = {
              enabled = false;
            };
            FixSpotifyEmbeds = {
              enabled = false;
            };
            FixYoutubeEmbeds = {
              enabled = false;
            };
            ForceOwnerCrown = {
              enabled = false;
            };
            FriendInvites = {
              enabled = false;
            };
            FriendsSince = {
              enabled = false;
            };
            FullSearchContext = {
              enabled = false;
            };
            GameActivityToggle = {
              enabled = false;
            };
            GifPaste = {
              enabled = false;
            };
            GreetStickerPicker = {
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
            ImageLink = {
              enabled = false;
            };
            ImageZoom = {
              enabled = false;
            };
            ImplicitRelationships = {
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
            MentionAvatars = {
              enabled = false;
            };
            MessageClickActions = {
              enabled = false;
            };
            MessageLatency = {
              enabled = false;
            };
            MessageLinkEmbeds = {
              enabled = false;
            };
            MessageLogger = {
              enabled = true;
              collapseDeleted = false;
              deleteStyle = "text";
              ignoreBots = true;
              ignoreSelf = true;
              logEdits = true;
              logDeletes = true;
            };
            MessageTags = {
              enabled = false;
            };
            MoreCommands = {
              enabled = false;
            };
            MoreKaomoji = {
              enabled = false;
            };
            MoreUserTags = {
              enabled = false;
            };
            Moyai = {
              enabled = false;
            };
            MutualGroupDMs = {
              enabled = false;
            };
            NewGuildSettings = {
              enabled = false;
            };
            NoBlockedMessages = {
              enabled = false;
            };
            NoDevtoolsWarning = {
              enabled = false;
            };
            NoF1 = {
              enabled = false;
            };
            NoMaskedUrlPaste = {
              enabled = false;
            };
            NoMosaic = {
              enabled = false;
            };
            NoOnboardingDelay = {
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
              inverseShiftReply = true;
            };
            NoScreensharePreview = {
              enabled = false;
            };
            NoServerEmojis = {
              enabled = false;
            };
            NoTypingAnimation = {
              enabled = true;
            };
            NoUnblockToJump = {
              enabled = false;
            };
            NormalizeMessageLinks = {
              enabled = false;
            };
            NotificationVolume = {
              enabled = false;
            };
            NSFWGateBypass = {
              enabled = false;
            };
            OnePingPerDM = {
              enabled = false;
            };
            oneko = {
              enabled = false;
            };
            OpenInApp = {
              enabled = false;
            };
            OverrideForumDefaults = {
              enabled = false;
            };
            PartyMode = {
              enabled = false;
            };
            PauseInvitesForever = {
              enabled = false;
            };
            PermissionFreeWill = {
              enabled = false;
            };
            PermissionsViewer = {
              enabled = false;
            };
            petpet = {
              enabled = false;
            };
            PictureInPicture = {
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
            PreviewMessage = {
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
            ReplaceGoogleSearch = {
              enabled = false;
            };
            ReplyTimestamp = {
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
            SecretRingToneEnabler = {
              enabled = false;
            };
            Summaries = {
              enabled = false;
            };
            SendTimestamps = {
              enabled = false;
            };
            ServerInfo = {
              enabled = false;
            };
            ServerListIndicators = {
              enabled = false;
            };
            ShikiCodeblocks = {
              enabled = true;
              theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/dracula.json";
              tryHljs = "SECONDARY";
              useDevIcon = "GREYSCALE";
              bgOpacity = 100;
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
            ShowHiddenThings = {
              enabled = false;
            };
            ShowMeYourName = {
              enabled = false;
            };
            ShowTimeoutDuration = {
              enabled = false;
            };
            SilentMessageToggle = {
              enabled = false;
            };
            SilentTyping = {
              enabled = true;
            };
            SortFriendRequests = {
              enabled = true;
              showDates = false;
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
            StickerPaste = {
              enabled = false;
            };
            StreamerModeOnStream = {
              enabled = false;
            };
            SuperReactionTweaks = {
              enabled = false;
            };
            TextReplace = {
              enabled = false;
            };
            ThemeAttributes = {
              enabled = false;
            };
            Translate = {
              enabled = false;
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
            UnlockedAvatarZoom = {
              enabled = false;
            };
            UnsuppressEmbeds = {
              enabled = false;
            };
            UserMessagesPronouns = {
              enabled = false;
            };
            UserVoiceShow = {
              enabled = false;
            };
            USRBG = {
              enabled = false;
            };
            ValidReply = {
              enabled = false;
            };
            ValidUser = {
              enabled = true;
            };
            VoiceChatDoubleClick = {
              enabled = false;
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
            VoiceDownload = {
              enabled = false;
            };
            VoiceMessages = {
              enabled = false;
            };
            VolumeBooster = {
              enabled = false;
            };
            WebKeybinds = {
              enabled = true;
            };
            WebScreenShareFixes = {
              enabled = true;
            };
            WhoReacted = {
              enabled = false;
            };
            XSOverlay = {
              enabled = false;
            };
            YoutubeAdblock = {
              enabled = true;
            };
            NoTrack = {
              enabled = true;
              disableAnalytics = true;
            };
            WebContextMenus = {
              enabled = true;
              addBack = true;
            };
            Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
            };
            SupportHelper = {
              enabled = true;
            };
          };
        };
      };
    };
  };
}
