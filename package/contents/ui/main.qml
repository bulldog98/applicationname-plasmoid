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
    id: main

    property int minimumWidth: text.paintedWidth
    property int minimumHeight: text.paintedHeight

    property bool show_window_title: false

    property string visibleText: ''

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
    }

    function configChanged() {
        show_window_title = plasmoid.readConfig("showWindowTitle");
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
            activityId = activitySource.data["Status"]["Current"]
            visibleText = activitySource.data[activityId]["Name"]

            for ( var i in data ) {
                if (data[i].active) {
                    if (show_window_title)
                        visibleText = data[i].name
                    else
                        visibleText = data[i].classClass

                    break
                }
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
        width: text.paintedWidth + 10
        height: text.paintedHeight
        anchors.verticalCenter: main.verticalCenter
        anchors.horizontalCenter: main.horizontalCenter

        PlasmaComponents.Label {
            id: text
            text: visibleText
            anchors.verticalCenter: frame.verticalCenter
            anchors.horizontalCenter: frame.horizontalCenter
        }
    }
}
