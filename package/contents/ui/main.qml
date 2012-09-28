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

Item {
    property int minimumWidth: text.paintedWidth
    property int minimumHeight: text.paintedHeight

    property string windowTitle: ''

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
             windowTitle = 'Desktop'

             for ( var i in data ) {
                 if (data[i].active) {
                     windowTitle = data[i].classClass
                     break
                 }
             }
         }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: text
            text: windowTitle
            color: theme.textColor
        }
    }
}
