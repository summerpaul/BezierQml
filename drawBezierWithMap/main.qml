import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Image {
        id: map
        source: "maps/room.pgm"
        property var x_offset:-15.400000
        property var y_offset:-12.200000
        property var resolution: 0.050000

        MouseArea{
            anchors.fill: parent
            onPressed:{
                console.log("x = " + mouseX + " y = " + mouseY)
                console.log("map width is " + map.width + " map height is " + map.height)
            }
        }

    }
}
