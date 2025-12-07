{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe'
    makeBinPath
    ;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.quickshell;

  # Binaries
  wpctl = getExe' pkgs.wireplumber "wpctl";
  cat = getExe' pkgs.coreutils "cat";

  # Custom script to safely fetch IP without quoting headaches
  # Usage: get-ip <interface>
  getIp = pkgs.writeShellScript "get-ip" ''
    export PATH=${
      makeBinPath [
        pkgs.iproute2
        pkgs.gawk
      ]
    }:$PATH
    # Find line with 'inet ', take 2nd column (IP/CIDR), split by '/', print IP
    ip -4 addr show "$1" | awk '/inet / {split($2, a, "/"); print a[1]}'
  '';
in
{
  options.mine.quickshell = {
    enable = mkEnableOption "quickshell";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.quickshell ];
      xdg.config.files."quickshell/shell.qml".text = ''
        import QtQuick
        import QtQuick.Layouts
        import Quickshell
        import Quickshell.Wayland
        import Quickshell.Io
        import Quickshell.Hyprland
        import Quickshell.Services.SystemTray

        ShellRoot {
            id: root

            property string netInterface: "wlp4s0"
            property string batInterface: "BAT1"

            property color colBg:     "#${palette.base00}"
            property color colFg:     "#${palette.base05}"
            property color colMuted:  "#${palette.base03}"
            property color colCyan:   "#${palette.base0C}"
            property color colPurple: "#${palette.base0E}"
            property color colRed:    "#${palette.base08}"
            property color colYellow: "#${palette.base0A}"
            property color colBlue:   "#${palette.base0D}"
            property color colGreen:  "#${palette.base0B}"

            property string fontFamily: "${config.mine.fonts.terminal.name}"
            property int fontSize: ${toString config.mine.fonts.size}

            component VertSep: Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                color: root.colMuted
            }

            QtObject {
                id: audio
                property int vol: 0
                property int mic: 0
                property bool muted: false
                property bool micMuted: false

                function toggle() { toggleProc.running = true }

                function scroll(step) {
                    const arg = step > 0 ? "5%+" : "5%-"
                    volProc.command = ["${wpctl}", "set-volume", "@DEFAULT_AUDIO_SINK@", arg]
                    volProc.running = true
                }

                property var _getVol: Process {
                    id: getVolProc
                    command: ["${wpctl}", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                    stdout: StdioCollector {
                        onStreamFinished: {
                            const str = this.text.trim()
                            const parts = str.split(" ")
                            if (parts.length >= 2) {
                                const val = parseFloat(parts[1])
                                if (!isNaN(val)) audio.vol = Math.round(val * 100)
                                audio.muted = str.includes("[MUTED]")
                            }
                        }
                    }
                }

                property var _getMic: Process {
                    id: getMicProc
                    command: ["${wpctl}", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
                    stdout: StdioCollector {
                        onStreamFinished: {
                            const str = this.text.trim()
                            audio.micMuted = str.includes("[MUTED]")

                            const parts = str.split(" ")
                            if (parts.length >= 2) {
                                const val = parseFloat(parts[1])
                                if (!isNaN(val)) audio.mic = Math.round(val * 100)
                            }
                        }
                    }
                }

                property var _toggle: Process {
                    id: toggleProc
                    command: ["${wpctl}", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                }

                property var _setVol: Process {
                    id: volProc
                    command: ["${wpctl}", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
                }

                property var _timer: Timer {
                    interval: 500; running: true; repeat: true; triggeredOnStart: true
                    onTriggered: {
                        getVolProc.running = true
                        getMicProc.running = true
                    }
                }
            }

            QtObject {
                id: netState
                property var lastRx: 0
                property var lastTx: 0
                property string down: "0"
                property string up: "0"
            }

            Variants {
                model: Quickshell.screens

                PanelWindow {
                    property var modelData
                    screen: modelData

                    anchors { top: false; bottom: true; left: true; right: true }
                    implicitHeight: 30
                    color: root.colBg

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item { width: 8 }

                        Repeater {
                            model: 9

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: parent.height
                                color: "transparent"

                                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                                property bool hasWindows: workspace !== null

                                Text {
                                    text: index + 1
                                    color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                                    font.pixelSize: root.fontSize
                                    font.family: root.fontFamily
                                    font.bold: true
                                    anchors.centerIn: parent
                                }

                                Rectangle {
                                    width: 20
                                    height: 3
                                    color: parent.isActive ? root.colPurple : root.colBg
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        RowLayout {
                            spacing: 5
                            Layout.rightMargin: 5
                            Repeater {
                                model: SystemTray.items
                                Image {
                                    Layout.preferredWidth: 14; Layout.preferredHeight: 14
                                    source: modelData.icon
                                    TapHandler { onTapped: modelData.activate() }
                                }
                            }
                        }

                        VertSep {}

                        Text {
                            id: ipText
                            text: "..."
                            color: root.colGreen
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true

                            Timer {
                                interval: 60000; running: true; repeat: true; triggeredOnStart: true
                                onTriggered: ipProc.running = true
                            }

                            Process {
                                id: ipProc
                                // Pass the interface name as argument $1 to the script
                                command: ["${getIp}", root.netInterface]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        const result = this.text.trim()
                                        ipText.text = result !== "" ? "IP Leaked " + result : "No IP"
                                    }
                                }
                            }
                        }

                        VertSep {}

                        RowLayout {
                            Text {
                                text: `DOWN ''${netState.down} UP ''${netState.up}`
                                color: root.colBlue
                                font.pixelSize: root.fontSize
                                font.family: root.fontFamily
                                font.bold: true
                            }

                            Timer {
                                interval: 1000; running: true; repeat: true
                                onTriggered: { rxProc.running = true; txProc.running = true }
                            }
                            Process {
                                id: rxProc
                                command: ["${cat}", `/sys/class/net/''${root.netInterface}/statistics/rx_bytes`]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        const val = parseInt(this.text.trim())
                                        if (!isNaN(val) && netState.lastRx !== 0)
                                            netState.down = ((val - netState.lastRx) * 8 / 1024).toFixed(0) + "k"
                                        netState.lastRx = val
                                    }
                                }
                            }
                            Process {
                                id: txProc
                                command: ["${cat}", `/sys/class/net/''${root.netInterface}/statistics/tx_bytes`]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        const val = parseInt(this.text.trim())
                                        if (!isNaN(val) && netState.lastTx !== 0)
                                            netState.up = ((val - netState.lastTx) * 8 / 1024).toFixed(0) + "k"
                                        netState.lastTx = val
                                    }
                                }
                            }
                        }

                        VertSep {}

                        RowLayout {
                            Text {
                                text: audio.muted ? "VOL Muted" : `VOL ''${audio.vol}%`
                                color: audio.muted ? root.colRed : root.colPurple
                                font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true

                                TapHandler { onTapped: audio.toggle() }
                                WheelHandler {
                                    onWheel: (e) => audio.scroll(e.angleDelta.y > 0 ? 0.05 : -0.05)
                                }
                            }

                            Text {
                                text: audio.micMuted ? "MIC Muted" : `MIC ''${audio.mic}%`
                                color: audio.micMuted ? root.colRed : root.colPurple
                                font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true
                                Layout.leftMargin: 5
                            }
                        }

                        VertSep {}

                        RowLayout {
                            id: batRow
                            property int cap: 0
                            property string stat: ""

                            Text {
                                text: {
                                    let icon = "BAT"
                                    if (batRow.stat === "Charging") icon = "CHG"
                                    return `''${icon} ''${batRow.cap}%`
                                }
                                color: batRow.cap < 20 ? root.colRed : root.colYellow
                                font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true
                            }

                            Timer {
                                interval: 5000; running: true; repeat: true; triggeredOnStart: true
                                onTriggered: { batCap.running = true; batStat.running = true }
                            }
                            Process {
                                id: batCap
                                command: ["${cat}", `/sys/class/power_supply/''${root.batInterface}/capacity`]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        const val = parseInt(this.text.trim())
                                        if (!isNaN(val)) batRow.cap = val
                                    }
                                }
                            }
                            Process {
                                id: batStat
                                command: ["${cat}", `/sys/class/power_supply/''${root.batInterface}/status`]
                                stdout: StdioCollector {
                                    onStreamFinished: batRow.stat = this.text.trim()
                                }
                            }
                        }

                        VertSep {}

                        Text {
                            id: clock
                            text: Qt.formatDateTime(new Date(), "CLOCK hh:mm AP")
                            color: root.colBlue
                            font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true
                            Timer {
                                interval: 1000; running: true; repeat: true
                                onTriggered: parent.text = Qt.formatDateTime(new Date(), "CLOCK hh:mm AP")
                            }
                        }

                        VertSep {}

                        Text {
                            id: dateText
                            property bool showEn: false
                            color: root.colCyan
                            font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true
                            Layout.rightMargin: 8

                            function update() {
                                const d = new Date()
                                if (showEn) text = d.toLocaleDateString(Qt.locale("en_US"), "DATE ddd, MMM d, yyyy")
                                else text = d.toLocaleDateString(Qt.locale("ja_JP"), "DATE yyyy年 M月 d日 (ddd)")
                            }

                            Component.onCompleted: update()
                            Timer { interval: 60000; running: true; repeat: true; onTriggered: parent.update() }
                            TapHandler { onTapped: { parent.showEn = !parent.showEn; parent.update() } }
                        }
                    }
                }
            }
        }
      '';
    };
  };
}
