{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  vesktopWrapped = pkgs.vesktop.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/vesktop \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer --enable-wayland-ime=true"
      '';
  });

  cfg = config.myOptions.discord;
in
{
  options.myOptions.discord = {
    enable = mkEnableOption "discord" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      programs.vesktop = {
        enable = true;
        package = vesktopWrapped;

        settings = {
          # See https://github.com/Vencord/Vesktop/blob/main/src/shared/settings.d.ts
          discordBranch = "canary";
          firstLaunch = false;
          minimizeToTray = false;
          arRPC = true;
          splashColor = "rgb(219, 222, 225)";
          splashBackground = "rgb(49, 51, 56)";
          enableMenu = false;
          staticTitle = false;
          hardwareAcceleration = true;
        };

        vencord = {
          themes = {
            "fix-ui" = ''
              &>main[class^="container_"],
              &>div[class^="shop__"],
              &>div>div[class^="homeWrapperNormal__"] {
                border-top: none;
              }

              /* hide app launcher */
              div[class^="channelAppLauncher_"] {
                display: none !important;
              }

              /* hide help button */
              div[class^="trailing_"]>a[class^="anchor"] {
                display: none;
              }

              /* user box */
              section[class^="panels_"] {
                border-radius: 0px !important;
                width: 100% !important;
                left: 0 !important;
                bottom: 0px !important;
              }

              /* rightclick menu */
              .separator_c1e9c4 {
                margin: 2px;
              }

              /* make it darker */
              .menu_c1e9c4 {
                background-color: #121214;
                /* edit me */
              }

              /* Hide invite button */
              .inviteButton_f37cb1 {
                display: none !important;
              }

              .guildDropdown_f37cb1 {
                width: 100% !important;
              }

              /* i fucking hate avatar decorations */
              [class*="avatarDecoration"] {
                display: none;
              }

              [class^="profileEffects"] {
                display: none;
              }

              .avatarDecoration__44b0c {
                display: none;
              }

              .container__4bbc6 {
                display:none!important;
              }

              /* move typing list to top right */
              .visual-refresh [class^="chatContent_"]>form[class^="form"] {
                --custom-chat-input-margin-bottom: 8px;
                --custom-channel-textarea-text-area-height: 44px;

                margin-top: 8px;
                display: flex;
                flex-direction: column-reverse;
                column-gap: 0px;

                >div[class^="typing"] {
                  position: relative;
                  justify-self: end;
                  margin-left: auto;
                  margin-right: 20px;
                  margin-top: -22px;
                  row-gap: 4px;

                  svg {
                    margin-top: -3px;
                  }

                  div>span>strong {
                    margin-top: 0px !important;
                  }
                }
              }

              /* Remove top bar, keep inbox icon */
              .visual-refresh {

                div[class^="subtitleContainer_"],
                main[class^="container__"] section[class*="container__"] {
                  position-anchor: --vr-header-trailing;
                  background-color: rgba(0, 0, 0, .25);
                }

                div[class^="toolbar__"]>div[class^="search__"] {
                  padding-right: 50px;
                }

                div[class^="page_"] {
                  &:not(:has(> div[class^="chat_"])) {
                    anchor-name: --vr-header-snippet;
                  }

                  &>div[class^="chat_"] {
                    anchor-name: --vr-header-snippet;
                    border-top: none;
                  }

                  &>main[class^="container_"],
                  &>div[class^="shop__"],
                  &>div>div[class^="homeWrapperNormal__"] {
                    border-top: none;
                  }
                }

                div[class^="base_"] {
                  grid-template-rows: auto;

                  &>div[class^="bar_"] {
                    position: absolute;
                    position-anchor: --vr-header-snippet;
                    top: 0;
                    right: anchor(right);
                    width: anchor-size(width);
                    padding: 0;

                    div[class^="title_"] {
                      display: none;
                    }
                  }

                  & div[class^="trailing_"] {
                    anchor-name: --vr-header-trailing;
                    border: none;
                    margin-top: 8px;
                    height: 39px;
                    margin-right: 20px;
                    z-index: 1000;

                    /* hide help button */
                    >a[class^="anchor"] {
                      display: none;
                    }
                  }

                  /* fix discord icon glued to the window's border */
                  /* can't use generic selector because there's a more than 1 with just the id being different */
                  .tutorialContainer__1f388 {
                    padding-top: 15px;
                  }
                }
              }
            '';
          };
          settings = {
            # See https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
            autoUpdate = false;
            autoUpdateNotification = false;
            useQuickCss = true;
            notifyAboutUpdates = false;
            enableReactDevtools = false;
            enabledThemes = [ "fix-ui.css" ];
            # themeLinks = [
            #   "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
            # ];
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
    }; # For Home-Manager options
  };
}
