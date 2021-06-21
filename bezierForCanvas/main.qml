import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    id: my_window
    Canvas{
        anchors.fill: parent
        id:canvas

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
        property bool isDrawBezierBtn: false

        function factorial(num){
            if (num <= 1) {
                    return 1;
                } else {
                    return num * this.factorial(num - 1);
                }
        }

        function bezier(t){
            var x = 0,
                y = 0,
                bezierCtrlNodesArr = canvas.clickNodes,
                n = bezierCtrlNodesArr.length - 1
            bezierCtrlNodesArr.forEach(function(item, index) {
                   if(!index) {
                       x += item.x * Math.pow(( 1 - t ), n - index) * Math.pow(t, index)
                       y += item.y * Math.pow(( 1 - t ), n - index) * Math.pow(t, index)
                   } else {
                       x += factorial(n) / factorial(index) / factorial(n - index) * item.x * Math.pow(( 1 - t ), n - index) * Math.pow(t, index)
                       y += factorial(n) / factorial(index) / factorial(n - index) * item.y * Math.pow(( 1 - t ), n - index) * Math.pow(t, index)
                   }
               })
               return {
                   x: x,
                   y: y
               }

        }


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
                ctx.arc(x, y, 8, 0, Math.PI * 2, false)
                ctx.fill()
                ctx.beginPath()
                ctx.moveTo(startX, startY)
                ctx.lineTo(x, y)
                ctx.strokeStyle = '#696969'
                ctx.stroke()
                if (index) {
                    var startX = canvas.clickNodes[index - 1].x,
                    startY = canvas.clickNodes[index - 1].y
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    ctx.lineTo(x, y)
                    ctx.stroke()
                }
            })

            if(canvas.num == 0){
                return
            }

            if( canvas.isDrawBezierBtn){
                canvas.isPrinting = true
//                drawBezier_(ctx, canvas.clickNodes)
                console.log("canvas.clickNodes size " + canvas.clickNodes.length)
                if(canvas.clickNodes.length)
                {
                    var bezierArr = []
                    for(var i = 0; i < 1; i+=0.005)
                    {
                        bezierArr.push(bezier(i))
                    }
                }
                console.log(bezierArr.length)
                bezierArr.forEach(function(obj, index) {
                            if (index) {
                                var startX = bezierArr[index - 1].x,
                                    startY = bezierArr[index - 1].y,
                                    x = obj.x,
                                    y = obj.y
                                ctx.beginPath()
                                ctx.moveTo(startX, startY)
                                ctx.lineTo(x, y)
                                ctx.strokeStyle = "blue"
                                ctx.stroke()
                            }
                        })
            }
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
                        console.log("choose " + index)
                    }

                })
            }

            onReleased: {
                if(canvas.isDragNode)
                {
                    canvas.clickNodes[canvas.dragIndex].x = mouseX
                    canvas.clickNodes[canvas.dragIndex].y = mouseY
                    canvas.requestPaint()

                }
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
                        canvas.clickNodes.push({x:x,y:y
                                               })
                    }

                    canvas.requestPaint()
                }
            }

            Button {
                id: drawBezier
                x: 485
                text: qsTr("drawBezier")
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.rightMargin: 5
                onPressed: {
                    canvas.isDrawBezierBtn = true

            }
                onReleased: {
                    canvas.requestPaint()
                }
                }

            Button {
                id: stopDraw
                x: 485
                text: qsTr("stopDraw")
                anchors.right: drawBezier.left
                anchors.top: drawBezier.bottom
                anchors.topMargin: 10
                anchors.rightMargin: -100
                onPressed:{
                    canvas.isDrawBezierBtn = false
                }
            }

        }
    }
}
