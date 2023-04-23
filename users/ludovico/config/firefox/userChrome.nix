''
        * {
    box-shadow: none !important;
    border: 0px solid !important;
  }
  #tabbrowser-tabs {
    --user-tab-rounding: 8px;
  }
  .tab-background {
    border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important; /* Connected */
    margin-block: 1px 0 !important; /* Connected */
  }
  #scrollbutton-up,
  #scrollbutton-down {
    /* 6/10/2021 */
    border-top-width: 1px !important;
    border-bottom-width: 0 !important;
  }
  .tab-background:is([selected], [multiselected]):-moz-lwtheme {
    --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;
    border-bottom-color: transparent !important;
  }
  [brighttext="true"]
    .tab-background:is([selected], [multiselected]):-moz-lwtheme {
    --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;
    border-bottom-color: transparent !important;
  } /* Container color bar visibility */
  .tabbrowser-tab[usercontextid]
    > .tab-stack
    > .tab-background
    > .tab-context-line {
    margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;
  }
  #TabsToolbar,
  #tabbrowser-tabs {
    --tab-min-height: 29px !important;
  }
  #main-window[sizemode="true"] #toolbar-menubar[autohide="true"] + #TabsToolbar,
  #main-window[sizemode="true"]
    #toolbar-menubar[autohide="true"]
    + #TabsToolbar
    #tabbrowser-tabs {
    --tab-min-height: 30px !important;
  }
  #scrollbutton-up,
  #scrollbutton-down {
    border-top-width: 0 !important;
    border-bottom-width: 0 !important;
  }
  #TabsToolbar,
  #TabsToolbar > hbox,
  #TabsToolbar-customization-target,
  #tabbrowser-arrowscrollbox {
    max-height: calc(var(--tab-min-height) + 1px) !important;
  }
  #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon,
  #TabsToolbar-customization-target .toolbarbutton-text,
  #TabsToolbar-customization-target .toolbarbutton-badge-stack,
  #scrollbutton-up,
  #scrollbutton-down {
    padding-top: 7px !important;
    padding-bottom: 6px !important;
  }
''
