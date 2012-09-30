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

    property int minimumWidth: frame.width
    property int minimumHeight: frame.height

    property bool show_window_title: false
    property bool use_fixed_width: false
    property bool font_bold: false
    property bool font_italic: false
    property string font_color: theme.textColor
    property string label_effect: "Sunken"

    property int text_width: text.paintedWidth
    property string visibleText: ''
    property int text_elide: Text.ElideNone

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
    }

    function configChanged() {
        show_window_title = plasmoid.readConfig("showWindowTitle");
        use_fixed_width = plasmoid.readConfig("fixedWidth");
        font_bold = plasmoid.readConfig("bold");
        font_italic = plasmoid.readConfig("italic");
        font_color = plasmoid.readConfig("color");

        var selected_effect = plasmoid.readConfig("effect");
        if (selected_effect == 0)
            label_effect = "Plain";
        else if (selected_effect == 1)
            label_effect = "Raised";
        else
            label_effect = "Sunken";
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

            if (use_fixed_width) {
                text_width = plasmoid.readConfig("width");
                text_elide = Text.ElideRight
            } else {
                text_width = text.paintedWidth
                text_elide = Text.ElideNone
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
        frameShadow: label_effect
        width: text_width + 10
        height: text.paintedHeight
        anchors.verticalCenter: main.verticalCenter
        anchors.horizontalCenter: main.horizontalCenter

        PlasmaComponents.Label {
            id: text
            text: visibleText
            elide: text_elide
            font.bold: font_bold
            font.italic: font_italic
            color: font_color
            anchors.top: frame.top
            anchors.left: frame.left
            anchors.leftMargin: 5
            anchors.right: frame.right
            anchors.bottom: frame.bottom
        }
    }
}
