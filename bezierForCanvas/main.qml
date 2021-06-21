import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    id: my_window





    Canvas{
        property var t : 0 //贝塞尔函数涉及的占比比例，0<=t<=1
        property var clickNodes : [] //点击的控制点对象数组
        property var bezierNodes : [] //绘制内部控制点的数组
        property bool isPrinted : false //当前存在绘制的曲线
        property bool isPrinting : false //正在绘制中
        property int num : 0 //控制点数
        property bool isDrag : false //是否进入拖拽行为
        property bool isDragNode : false //是否点击到了控制点
        property int dragIndex : 0 //被拖拽的点的索引
        property var clickon : 0 //鼠标按下时间戳
        property var clickoff : 0 //鼠标抬起

        property var currentNodeX
        property var currentNodeY
        anchors.fill: parent
        id:canvas

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            canvas.clickNodes.forEach(function(item, index) {
                var x = item.x,
                y = item.y,
                i = parseInt(index, 10) + 1
                ctx.fillText("p" + i, x, y + 20)
                ctx.fillText("p" + i + ': ('+ x +', '+ y +')', 10, i * 20)
                ctx.beginPath()
                ctx.arc(x, y, 4, 0, Math.PI * 2, false)
                ctx.fill()
                ctx.beginPath()
                ctx.moveTo(startX, startY)
                ctx.lineTo(x, y)
                ctx.strokeStyle = '#696969'
                ctx.stroke()
                if (index) {
                    var startX = clickNodes[index - 1].x,
                    startY = clickNodes[index - 1].y
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    ctx.lineTo(x, y)
                    ctx.stroke()
                }
            })





        }

        MouseArea{
            id: mouseArea
            anchors.fill: parent
            onPressed: {
                canvas.isDrag = true
                canvas.clickon = new Date().getTime()
                var x = mouseX
                var y = mouseY

                canvas.clickNodes.forEach(function(item, index){
                    var absX = Math.abs(item.x - x)
                    var absY = Math.abs(item.y - y)

                    if(absX < 5 && absY < 5){
                        canvas.isDragNode = true
                        canvas.dragIndex = index
                    }

                }
                )


            }

            onReleased: {
                canvas.isDrag = false
                canvas.isDragNode = false
                canvas.clickoff = new Date().getTime()

                if (canvas.clickoff - canvas.clickon < 200){

                    var x = mouseX
                    var y = mouseY
                    canvas.currentNodeX = x
                    canvas.currentNodeY = y
                    if(!canvas.isPrinted && !canvas.isDragNode){
                        canvas.num++
                        console.log("add new point")
                        canvas.clickNodes.push({x:x,
                                                   y:y
                                               })
                    }


                    canvas.requestPaint()
                }


            }

            Button {
                id: button
                x: 485
                y: 57
                text: qsTr("Button")
            }

            Button {
                id: button1
                x: 485
                y: 117
                text: qsTr("Button")
            }






        }



    }
}
