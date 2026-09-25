import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "DesignTokens.js" as DesignTokens
import "OsdModel.js" as OsdModel

Item {
  id: root

  property bool opened: false
  property string icon: ""
  property string message: ""
  property string iconKey: ""
  property int value: 0
  property int maxValue: 100
  property bool hasProgress: true
  property int duration: 1200

  readonly property bool mediaOsd: iconKey.indexOf("media") === 0 || iconKey.indexOf("player") === 0

  // OSD density is independent from shared PopupCard padding: this compact,
  // transient control wants a low vertical profile and more lateral air.
  readonly property int paddingX: DesignTokens.number(Color.shellValues, "spacing.osd-padding-x", 20)
  readonly property int paddingY: DesignTokens.number(Color.shellValues, "spacing.osd-padding-y", 10)
  // Row geometry, track, and readout type come from the generated [osd] and
  // [font] theme sections (White Pill Studio recipe.osd); the fallbacks are
  // the same values for themes that don't ship them.
  readonly property int gap: Style.space(DesignTokens.number(Color.shellValues, "osd.gap", 16))
  // A glyph next to a message reads airier than it measures: the icon outline
  // and the letterforms both fall away from their ink extremes, so the space
  // between them opens up well past the nominal gap. Text takes two thirds of
  // it; the progress bar's hard edge keeps the full gap.
  readonly property int messageGap: Math.round(root.gap * 2 / 3)
  readonly property int barWidth: Style.space(DesignTokens.number(Color.shellValues, "osd.track-length", 142))
  readonly property int trackHeight: Style.space(DesignTokens.number(Color.shellValues, "osd.track-height", 5))
  readonly property real trackRadius: DesignTokens.number(Color.shellValues, "osd.track-radius", 999)
  readonly property color trackColor: Util.alpha(DesignTokens.color(Color.shellValues, "osd.track", Color.popups.text),
                                                 DesignTokens.number(Color.shellValues, "osd.track-alpha", 0.14))
  readonly property color fillColor: DesignTokens.color(Color.shellValues, "osd.fill", Color.accent)
  readonly property int iconSize: DesignTokens.number(Color.shellValues, "osd.icon-size", Style.font.displayLarge)
  readonly property int maxMessageWidth: root.mediaOsd ? Style.space(325) : Style.space(190)

  // Nerd Font glyphs draw well outside their monospace cell, so the icon
  // column is measured by ink rather than by advance width. Progress OSDs pin
  // it to the widest glyph the model can return, so the bar doesn't shift when
  // volume crosses an icon threshold.
  readonly property int iconInkWidth: Math.ceil(iconMetrics.tightBoundingRect.width)
  readonly property int iconWidth: root.hasProgress
    ? Math.max(root.iconInkWidth, Math.ceil(widestIconMetrics.tightBoundingRect.width))
    : root.iconInkWidth
  // Same idea for the readout: it is as wide as the longest percentage so the
  // digits don't jitter between 9% and 100%.
  readonly property int valueWidth: Math.ceil(Math.max(valueMetrics.advanceWidth, messageMetrics.advanceWidth))
  readonly property int messageWidth: Math.min(Math.ceil(messageMetrics.advanceWidth), root.maxMessageWidth)
  readonly property int contentWidth: root.hasProgress
    ? root.iconWidth + root.gap + root.barWidth + root.gap + root.valueWidth
    : (root.message === "" ? root.iconWidth : root.iconWidth + root.messageGap + root.messageWidth)
  readonly property var surfaceShadow: DesignTokens.shadow(Color.shellValues, "popups")
  readonly property var surfaceInnerBorder: DesignTokens.innerBorder(Color.shellValues, "popups")

  function iconFor(name, percent) {
    return OsdModel.iconFor(name, percent)
  }

  function show(iconName, rawMessage, rawValue, rawMax, rawProgressText, rawDuration) {
    var next = OsdModel.stateForShow(iconName, rawMessage, rawValue, rawMax, rawProgressText, rawDuration)
    // Update before opening so a fresh OSD starts at its new value; only
    // subsequent updates while it remains open animate the progress bar.
    iconKey = next.iconKey
    maxValue = next.maxValue
    hasProgress = next.hasProgress
    value = next.value
    message = next.message
    icon = next.icon
    duration = next.duration
    opened = true
    if (duration > 0) hideTimer.restart()
    else hideTimer.stop()
  }

  function open(payloadJson) {
    try {
      var p = JSON.parse(payloadJson || "{}")
      show(p.icon || "", p.message || "", p.value === undefined ? "" : String(p.value), p.max === undefined ? "100" : String(p.max), p.progressText || "", p.duration === undefined ? "1200" : String(p.duration))
    } catch (e) {}
  }

  function close() { opened = false }

  Timer {
    id: hideTimer
    interval: root.duration
    onTriggered: root.opened = false
  }

  TextMetrics {
    id: messageMetrics
    // The popup title role: semibold with slightly tightened tracking.
    font.family: DesignTokens.color(Color.shellValues, "font.ui-family", "Inter")
    font.weight: DesignTokens.number(Color.shellValues, "font.title-weight", 600)
    font.pixelSize: Style.font.title
    font.letterSpacing: Style.font.title * DesignTokens.number(Color.shellValues, "font.title-tracking", -0.01)
    text: root.message
  }

  TextMetrics {
    id: valueMetrics
    font: messageMetrics.font
    text: "100%"
  }

  TextMetrics {
    id: iconMetrics
    font.family: DesignTokens.color(Color.shellValues, "font.icon-family", Style.font.family)
    font.pixelSize: root.iconSize
    text: root.icon
  }

  TextMetrics {
    id: widestIconMetrics
    font: iconMetrics.font
    text: OsdModel.widestIcon
  }

  IpcHandler {
    target: "osd"
    function show(payloadJson: string): string {
      root.open(payloadJson)
      return "ok"
    }
    function close(): string { root.close(); return "ok" }
    function state(): string { return root.opened ? "open" : "closed" }
    function ping(): string { return "ok" }
  }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "omarchy-osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore
    // Visual-only surface: keep the layer-shell input region empty so the OSD
    // never blocks clicks to the desktop below it.
    mask: Region {}

    BorderSurface {
      id: card
      width: card.borderLeft + root.paddingX + root.contentWidth + root.paddingX + card.borderRight
      height: card.borderTop + root.paddingY + root.iconSize + root.paddingY + card.borderBottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: Style.space(67)
      color: Color.popups.background
      borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, 0.5)
      radius: Style.cornerRadius
      opacity: root.opened ? 1 : 0
      layer.enabled: true
      layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Util.alpha(root.surfaceShadow.color, root.surfaceShadow.alpha)
        shadowBlur: 1.0
        shadowHorizontalOffset: root.surfaceShadow.x
        shadowVerticalOffset: root.surfaceShadow.y
        blurMax: root.surfaceShadow.blur
      }

      BorderSurface {
        anchors.fill: parent
        anchors.margins: card.borderTop
        color: "transparent"
        borderSpec: Border.flat(Util.alpha(root.surfaceInnerBorder.color, root.surfaceInnerBorder.alpha), root.surfaceInnerBorder.width)
        radius: Math.max(0, card.radius - card.borderTop)
      }

      Row {
        anchors.fill: parent
        anchors.topMargin: card.borderTop + root.paddingY
        anchors.rightMargin: card.borderRight + root.paddingX
        anchors.bottomMargin: card.borderBottom + root.paddingY
        anchors.leftMargin: card.borderLeft + root.paddingX
        spacing: root.hasProgress ? root.gap : root.messageGap
        Item {
          width: root.iconWidth
          height: parent.height
          Text {
            textFormat: Text.PlainText
            // Sit the glyph's ink flush in the column, centered when the
            // column is wider than this particular glyph.
            x: Math.round((root.iconWidth - root.iconInkWidth) / 2 - iconMetrics.tightBoundingRect.x)
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            font: iconMetrics.font
            color: Color.popups.text
          }
        }
        Rectangle {
          visible: root.hasProgress
          width: root.barWidth
          height: root.trackHeight
          radius: Math.min(height / 2, root.trackRadius)
          anchors.verticalCenter: parent.verticalCenter
          color: root.trackColor
          Rectangle {
            height: parent.height
            radius: parent.radius
            width: parent.width * (root.hasProgress ? root.value / root.maxValue : 0)
            color: root.fillColor

            Behavior on width {
              enabled: root.opened
              NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
            }
          }
        }
        Text {
          textFormat: Text.PlainText
          visible: root.message !== ""
          width: root.hasProgress ? root.valueWidth : root.messageWidth
          // The readout hugs the card edge so a short percentage doesn't leave
          // a hole in the padding; the slack lands in the gap after the bar.
          horizontalAlignment: root.hasProgress ? Text.AlignRight : Text.AlignLeft
          anchors.verticalCenter: parent.verticalCenter
          text: root.message
          font: messageMetrics.font
          color: Color.popups.text
          elide: Text.ElideRight
          maximumLineCount: 1
        }
      }
    }
  }
}
