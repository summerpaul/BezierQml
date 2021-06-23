import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "Common.js" as Util
import "Draw.js" as Draw

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
        property var clickNodeRadius: 4 //绘制点圆的半径
        property var controlNodeRadius: 3
        property var keyNodeRadius: 8
        property bool isMultiBezier: false
        property bool isFourBezier: false
        property var offset: 3.0
        onPaint: {//绘制点与曲线
            if(num ==0)
            {
                return
            }
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            Draw.drawNodes(ctx, clickNodes,clickNodeRadius, 1, "blue", "blue",false)//绘制点击点
            Draw.drawNodes(ctx, controlNodes,controlNodeRadius, 1, "green", "green",false)//绘制控制点
            var bezierNodes = Util.getBezier(controlNodes);//绘制bezier曲线
            Draw.drawLine(ctx, bezierNodes, 1, "red")
            Draw.drawNodes(ctx, keyNodes, keyNodeRadius, 2, "blue", "red", true)//绘制关键点
        }//paint
        MouseArea{ //鼠标操作
            id:mouseArea
            anchors.fill: parent
            onPressed: { // 单击鼠标的操作
                parent.isDrag = true // 表示进入拖拽或绘制点
                parent.clickon = new Date().getTime()//鼠标单击时候的时间戳
                parent.currentNodeX = mouseX
                parent.currentNodeY = mouseY
                parent.clickNodes.forEach(function(item, index){
                    var absX = Math.abs(item.x - mouseX)
                    var absY = Math.abs(item.y - mouseY)
                    if(absX < parent.keyNodeRadius && absY < parent.keyNodeRadius) // 确定拖拽的点
                    {
                        parent.isDragNode = true
                        parent.dragIndex = index //拖拽点的id
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
                    if(!parent.isDragNode)//没有拖拽操作的时候增减新的点击点
                    {
                        if(parent.clickoff - parent.clickon < 200)
                        {
                            parent.num++
                            parent.clickNodes.push({x:parent.currentNodeX,
                                                       y:parent.currentNodeY,
                                                       yaw:0
                                                   })
                            parent.requestPaint()
                        }
                        else{
                            parent.num++
                            var yaw =Math.atan2(mouseY- canvas.currentNodeY, mouseX - canvas.currentNodeX)
                            yaw = Util.getYaw(yaw)

                            parent.clickNodes.push({x:parent.currentNodeX,
                                                       y:parent.currentNodeY,
                                                       yaw:yaw
                                                   })
                            parent.requestPaint()
                        }
                    }
                }
                if(parent.isMultiBezier && !parent.isFourBezier)
                {
                    parent.controlNodes = parent.clickNodes
                    parent.keyNodes=[]
                    var length = parent.clickNodes.length
                    parent.keyNodes.push(parent.clickNodes[0])
                    parent.keyNodes.push(parent.clickNodes[length-1])
                }
                else if(parent.isFourBezier && !parent.isMultiBezier)
                {
                    if(parent.num < 2)
                    {
                        return;
                    }
                    parent.controlNodes = Util.calFourControlPoint(parent.clickNodes, offset.value * 10)
                    parent.keyNodes = parent.clickNodes
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
                if(parent.isFourBezier)
                {
                    text=qsTr("drawFourBezier")
                }
                else
                {
                    text=qsTr("fourBezier")
                }
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
            onClicked: {
                parent.clickNodes=[] //鼠标点击的点
                parent.controlNodes= [] // bezier中的控制点
                parent.keyNodes= [] //bezier中的关键点
                parent.num = 0 // bezier控制点的数目
                parent.requestPaint()
            }
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
                    if(parent.num < 2)
                    {
                        return
                    }
                    parent.controlNodes = Util.calFourControlPoint(parent.clickNodes, value * 10)
                    parent.requestPaint()
                }
            }
        }
    }//Canvas
}//window
