import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "Common.js" as Util


Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")



    Canvas{

        anchors.fill: parent
        id:canvas
        property var clickNodes: [] //鼠标点击的点
        property var controlNodes: [] // bezier中的控制点
        property var keyNodes: [] //bezier中的关键点
        property var num: 0 // bezier控制点的数目
        property bool isDrag : false //是否进入拖拽行为（包括绘制点）
        property bool isDragNode : false //是否点击到了控制点
        property int dragIndex : 0 //被拖拽的点的索引
        property var clickon : 0 //鼠标按下时间戳
        property var clickoff : 0 //鼠标抬起

        property var currentNodeX //获取鼠标点击时刻的x坐标
        property var currentNodeY //获取鼠标点击时刻的Y坐标
        property var nodeRadius: 8 //绘制点圆的半径
        property bool isMultiBezier: false
        property bool isFourBezier: false
        property var offset: 3.0

        onPaint: {//绘制点与曲线
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            //绘制控制点
            clickNodes.forEach(function(item, index){
                var x = item.x,
                y = item.y,
                yaw = item.yaw
                ctx.beginPath()
                ctx.arc(x, y, 8, 0, Math.PI * 2,  true)
                ctx.fillStyle = 'blue'
                ctx.fill()
                ctx.stroke()
                ctx.closePath()
                if (index) {
                    var startX = clickNodes[index - 1].x,
                    startY = clickNodes[index - 1].y
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    ctx.lineTo(x, y)
                    ctx.stroke()
                }
//

            })

            //绘制关键点
//            var ctx2 = getContext("2d")
            controlNodes.forEach(function(item, index){
                var x = item.x,
                y = item.y,
                yaw = item.yaw
                ctx.beginPath()
//                ctx.strokeStyle = "blue"
                ctx.arc(x, y, nodeRadius +2 , 0, Math.PI * 2,  true)
                ctx.fillStyle = 'green'
                ctx.fill()
                ctx.stroke()
                if (index) {
                    var startX = controlNodes[index - 1].x,
                    startY = controlNodes[index - 1].y
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    ctx.lineTo(x, y)
                    ctx.stroke()
                }

            })
            ctx.closePath()

            //绘制bezier曲线
            var bezierNodes = Util.getBezier(controlNodes);
            bezierNodes.forEach(function(item, index){
                var x = item.x,
                y = item.y,
                yaw = item.yaw
                if (index) {
                    var startX = bezierNodes[index - 1].x,
                    startY = bezierNodes[index - 1].y
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    ctx.lineTo(x, y)
                    ctx.stroke()
                }

            })



        }//paint


        MouseArea{ //鼠标操作
            id:mouseArea
            anchors.fill: parent

            onPressed: { // 单击鼠标的操作
                //
                parent.isDrag = true // 表示进入拖拽或绘制点
                parent.clickon = new Date().getTime()//鼠标单击时候的时间戳
                parent.currentNodeX = mouseX
                parent.currentNodeY = mouseY
                console.log("click on " + parent.clickon)

                parent.clickNodes.forEach(function(item, index){
                    var absX = Math.abs(item.x - mouseX)
                    var absY = Math.abs(item.y - mouseY)

                    if(absX < parent.nodeRadius && absY < parent.nodeRadius) // 确定拖拽的点
                    {
                        parent.isDragNode = true
                        parent.dragIndex = index //拖拽点的id
                        console.log("drag index is " + index)

                    }
                })

            }// onPress
            onReleased: {// 释放鼠标时的操作
                if(parent.isDragNode)//拖动鼠标时，移动对应的点
                {
                    parent.clickNodes[parent.dragIndex].x = mouseX
                    parent.clickNodes[parent.dragIndex].y = mouseY
                    if(parent.isFourBezier)
                    {
                        parent.controlNodes = Util.calFourControlPoint(parent.clickNodes, offset.value * 10)

                    }

                    parent.requestPaint()//完成拖拽后绘制拖拽后的点
                }
                if(parent.isMultiBezier || (parent.isFourBezier && parent.num < 2))
                {

                    parent.clickoff = new Date().getTime()//鼠标释放时刻的时间戳
                    console.log("click off " + parent.clickoff )
                    if(!parent.isDragNode)//没有拖拽操作的时候增减新的点击点
                    {
                        console.log(parent.clickoff - parent.clickon)
                        if(parent.clickoff - parent.clickon < 200)
                        {
                            parent.num++
                            parent.clickNodes.push({x:parent.currentNodeX,
                                                       y:parent.currentNodeY,
                                                       yaw:0
                                                   })
                            console.log("add common point")
                            parent.requestPaint()
                        }
                        else{
                            parent.num++
                            var yaw =Math.atan2(mouseY- canvas.currentNodeY, mouseX - canvas.currentNodeX)
                            if(-Math.PI* 0.25 < yaw && yaw <=Math.PI * 0.25)
                            {
                                yaw =0
                            }

                            parent.clickNodes.push({x:parent.currentNodeX,
                                                       y:parent.currentNodeY,
                                                       yaw:yaw
                                                   })
                            parent.requestPaint()
                            console.log("add point with yaw")
                        }
                    }

                }



                if(parent.isMultiBezier)
                {
                    parent.controlNodes = parent.clickNodes
                }
                else if(parent.isFourBezier)
                {
                    console.log("in isFourBezier")
                    if(parent.num < 2)
                    {
                        return;
                    }
                    parent.controlNodes = Util.calFourControlPoint(parent.clickNodes, offset.value * 10)
                }

                parent.isDrag = false
                parent.isDragNode = false
                parent.requestPaint()
            }

       //onRelease
        }//MouseArea

        Button {
            id: fourBezierBtn
            x: 524
            y: 19
            text: qsTr("4Bezier")
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 16
            anchors.topMargin: 19
            onClicked: {
                parent.isFourBezier = !parent.isFourBezier
                console.log(parent.isFourBezier)
                if(parent.isFourBezier)
                {
                    text=qsTr("drawFourBezier")
                }
                else
                {
                    text=qsTr("fourBezier")

                }
                console.log(parent.num)

            }
        }

        Button {
            id: clearBtn
            x: 524
            y: 133
            text: qsTr("clear")
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 16
            anchors.topMargin: 133
        }

        Button {
            id: multiBezierBtn
            x: 524
            y: 74
            text: qsTr("multiBezier")
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 16
            anchors.topMargin: 74
            onClicked: {
                parent.isMultiBezier = !parent.isMultiBezier
                console.log(parent.isMultiBezier)
                if(parent.isMultiBezier)
                {
                    text=qsTr("drawMultiBezier")
                }
                else
                {
                    text=qsTr("multiBezier")

                }

            }
        }
        Slider {
            id: offset
            x: 558
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 192
            anchors.rightMargin: 42
            orientation: Qt.Vertical
            value: 0.5
            onValueChanged: {
                if(parent.isFourBezier)
                {

                    parent.controlNodes = Util.calFourControlPoint(parent.clickNodes, value * 10)
                    parent.requestPaint()

                }


            }
        }
    }//Canvas
}//window
