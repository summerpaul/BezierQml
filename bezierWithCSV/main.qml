import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import sunny.QmlInterface 1.0
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property var csvPoints: []
    property var vscLanes: []
    QmlInterface{
        id: interFace
    }
    MenuBar{
        id: menuBar
        Menu{
            id: fileMenu
            title: qsTr("File")
            Action{
                text: qsTr("Node File")
                onTriggered: {
                    console.log("clicked Node File")
                    nodeDialog.open()
                }
            }
            Action{
                text: qsTr("Lane File")
                onTriggered: {
                    console.log("clicked Lane File")
                    laneDialog.open()
                }
            }
        }
    }
        FileDialog{
            id:nodeDialog
            title: "Please choose a node file"
            folder: "./Roadmap"
            onAccepted: {
                console.log("You choose: " + fileUrl)
                if(Qt.platform.os == "linux")
                {
                    interFace.setNodePath(fileUrl.toString().substring(7))
                    console.log(interFace.getPoints().length())
                }
                else if(Qt.platform.os == "windows")
                {
                    interFace.setNodePath(fileUrl.toString().substring(8))

                }


            }
        }
        FileDialog{
            id:laneDialog
            title: "please choose a lane file"
            folder: "../AGV_Route/Roadmap"
            onAccepted: {
                console.log("You choose: " + fileUrl)
                if(Qt.platform.os == "linux")
                {
                    interFace.setLanePath(fileUrl.toString().substring(7))
                }
                else if(Qt.platform.os == "windows")
                {
                    interFace.setLanePath(fileUrl.toString().substring(8))

                }


            }
        }
}
