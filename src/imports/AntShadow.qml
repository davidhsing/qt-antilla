import QtQuick
import QtQuick.Effects
import Antilla.Basic

MultiEffect {
    shadowEnabled: true
    shadowColor: AntTheme.Primary.colorTextBase
    shadowOpacity: AntTheme.isDark ? 0.4 : 0.2
    shadowScale: AntTheme.isDark ? 1.03 : 1.02
}
