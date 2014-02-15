/*
 *   Copyright 2012-2014 Andrea Scarpino <scarpino@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Lesser General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {
    id: main

    property int minimumWidth: row.implicitWidth
    property int minimumHeight: text.paintedHeight

    property bool show_application_icon: false
    property bool show_window_title: false
    property int show_activity_name: 1
    property bool use_fixed_width: false
    property bool use_maximum_width: false

    Component.onCompleted: {
        plasmoid.addEventListener("ConfigChanged", configChanged)
    }

    function configChanged() {
        show_application_icon = plasmoid.readConfig("showApplicationIcon")
        show_window_title = plasmoid.readConfig("showWindowTitle")
        show_activity_name = plasmoid.readConfig("showActivityName")
        use_fixed_width = plasmoid.readConfig("fixedWidth")
        use_maximum_width = plasmoid.readConfig("maximumWidth")

        text.font.family = plasmoid.readConfig("font").toString().split(',')[0]
        text.font.italic = plasmoid.readConfig("italic")
        text.font.underline = plasmoid.readConfig("underline")
        text.color = plasmoid.readConfig("color")

        if (plasmoid.readConfig("bold") === true) {
            text.font.weight = Font.Bold
        } else {
            text.font.weight = Font.Normal
        }
    }

    PlasmaCore.DataSource {
        id: tasksSource
        engine: "tasks"
        interval: 0

        onSourceAdded: {
            connectSource(source)
        }

        Component.onCompleted: {
            connectedSources = sources
        }

        onDataChanged: {
            // Reset texts
            text.text = ""
            iconItem.icon = ""
            tooltip.mainText = ""
            tooltip.subText = ""
            tooltip.image = ""

            if (show_activity_name !== 2) {
                var activityId = activitySource.data["Status"]["Current"]

                text.text = activitySource.data[activityId]["Name"]
                iconItem.icon = activitySource.data[activityId]["Icon"]

                tooltip.mainText = text.text
                tooltip.subText = ""
                tooltip.image = iconItem.icon
            }

            if (show_activity_name !== 0) {
                for ( var i in data ) {
                    if (data[i].active) {
                        iconItem.icon = data[i].icon

                        if (show_window_title) {
                            text.text = data[i].name
                        } else {
                            text.text = data[i].classClass
                        }

                        tooltip.mainText = data[i].classClass
                        tooltip.subText = data[i].name
                        tooltip.image = iconItem.icon

                        break
                     }
                }
            }

            if (use_fixed_width) {
                main.width = plasmoid.readConfig("fixedWidthPx")
                if (show_application_icon) {
                    text.width = main.width - row.spacing - iconItem.width
                } else {
                    text.width = main.width
                }
                text.elide = Text.ElideRight
            } else {
                if (show_application_icon) {
                    main.width = iconItem.width + row.spacing + text.paintedWidth
                } else {
                    main.width = text.paintedWidth
                }

                text.elide = Text.ElideNone

                var maximumWidth = plasmoid.readConfig("maximumWidthPx")
                if (use_maximum_width) {
                    if (main.width > maximumWidth) {
                        text.width = maximumWidth - row.spacing - iconItem.width
                        text.elide = Text.ElideRight
                    }
                }

                text.width = text.paintedWidth
            }
        }
    }

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        interval: 0

        onSourceAdded: {
            connectSource(source)
        }

        Component.onCompleted: {
            connectedSources = sources
        }
    }

    PlasmaCore.ToolTip {
        id: tooltip
        target: main
    }

    Row {
        id: row
        spacing: 3
        anchors.centerIn: parent

        QtExtraComponents.QIconItem {
            id: iconItem
            height: text.paintedHeight
            width: height
            visible: show_application_icon
            anchors.verticalCenter: text.verticalCenter
        }

        PlasmaComponents.Label {
            id: text
        }
    }
}
