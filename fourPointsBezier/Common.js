.pragma library

var scope = {
}

function point2point(x1, x2, y1, y2)
{
    return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

}

function calFourControlPoint(clickNodes, offset)
{
    var length = clickNodes.length
    var dist =point2point(clickNodes[0].x, clickNodes[1].x, clickNodes[0].y, clickNodes[1].y) / offset
    var controlNodes = []
    controlNodes.push(clickNodes[0])
    controlNodes.push({x:clickNodes[0].x + dist *Math.cos(clickNodes[0].yaw),
                              y:clickNodes[0].y + dist * Math.sin(clickNodes[0].yaw),
                              yaw:0

                             })
    controlNodes.push({x:clickNodes[1].x - dist *Math.cos(clickNodes[1].yaw),
                              y:clickNodes[1].y - dist * Math.sin(clickNodes[1].yaw),
                              yaw:0
                             })
    controlNodes.push(clickNodes[1])
    return controlNodes

}

function factorial(num){
    if (num <= 1) {
            return 1;
        } else {
            return num * factorial(num - 1);
        }
}

function bezier(t, controlNodes){
    var x = 0,
        y = 0,
        bezierCtrlNodesArr = controlNodes,
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

function getBezier(controlNodes)
{
    var bezierArr = []
    for(var i = 0; i < 1; i+=0.005)
    {
        bezierArr.push(bezier(i,controlNodes))
    }
    return bezierArr

}


