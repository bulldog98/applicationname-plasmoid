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

Item {
    property int minimumWidth: frame.width
    property int minimumHeight: frame.height

    property bool show_window_title: false
    property bool use_fixed_width: false

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
    }

    function configChanged() {
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
            var applicationName = activitySource.data[activityId]["Name"]

            for ( var i in data ) {
                if (data[i].active) {
                    if (show_window_title)
                        applicationName = data[i].name
                    else
                        applicationName = data[i].classClass

                    break
                }
            }

            text.text = applicationName
            if (use_fixed_width) {
                frame.width = plasmoid.readConfig("width") + 10
                text.elide = Text.ElideRight
            } else {
                frame.width = text.paintedWidth + 10
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
        width: text.width + 10
        height: text.paintedHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        PlasmaComponents.Label {
            id: text
            elide: Text.ElideNone
            font.bold: false
            font.italic: false
            color: theme.textColor
            anchors.horizontalCenter: frame.horizontalCenter
        }
    }
}
