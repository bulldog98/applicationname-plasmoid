/*
 *   Copyright 2012 Andrea Scarpino <andrea@archlinux.org>
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
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {
    property int minimumWidth: frame.width
    property int minimumHeight: frame.height

    property bool show_application_icon: false
    property bool show_window_title: false
    property bool use_fixed_width: false

    property int fixed_width: text.paintedWidth

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
    }

    function configChanged() {
        show_application_icon = plasmoid.readConfig("showApplicationIcon");
        show_window_title = plasmoid.readConfig("showWindowTitle");
        use_fixed_width = plasmoid.readConfig("fixedWidth");

        text.font.bold = plasmoid.readConfig("bold");
        text.font.italic = plasmoid.readConfig("italic");
        text.color = plasmoid.readConfig("color");

        var selected_effect = plasmoid.readConfig("effect");
        if (selected_effect == 0)
            frame.frameShadow = "Plain";
        else if (selected_effect == 1)
            frame.frameShadow = "Raised";
        else
            frame.frameShadow = "Sunken";
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
            var activityId = activitySource.data["Status"]["Current"]

            if (activityId == null)
                return

            text.text = activitySource.data[activityId]["Name"]
            iconItem.icon = activitySource.data[activityId]["Icon"]

            for ( var i in data ) {
                if (data[i].active) {
                    iconItem.icon = data[i].icon
                    if (show_window_title)
                        text.text = data[i].name
                    else
                        text.text = data[i].classClass

                    break
                }
            }

            if (use_fixed_width) {
                row.width = plasmoid.readConfig("width")
                if (show_application_icon)
                    text.width = row.width - iconItem.width
                else
                    text.width = row.width
                text.elide = Text.ElideRight
            } else {
                if (show_application_icon)
                    row.width = iconItem.width + text.paintedWidth
                else
                    row.width = text.paintedWidth
                text.width = text.paintedWidth
                text.elide = Text.ElideNone
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

    PlasmaWidgets.Frame {
        id: frame
        frameShadow: "Sunken"
        width: row.width + 10
        height: row.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            id: row
            width: iconItem.width + text.paintedWidth
            height: text.paintedHeight
            spacing: 5
            anchors.horizontalCenter: frame.horizontalCenter

            QtExtraComponents.QIconItem {
                id: iconItem
                height: text.height - (text.height / 4)
                width: height
                visible: show_application_icon
                anchors.verticalCenter: text.verticalCenter
            }

            PlasmaComponents.Label {
                id: text
                elide: Text.ElideNone
                font.bold: false
                font.italic: false
                color: theme.textColor
            }
        }
    }
}
