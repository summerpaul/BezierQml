function drawNodes(ctx, nodes, circleRarius, lineWidth, lineColor, circleColor, isKeyNodes)
{
    nodes.forEach(function(item, index){
        var x = item.x,
        y = item.y,
        yaw = item.yaw
        ctx.lineWidth = lineWidth
        ctx.strokeStyle = lineColor
        ctx.beginPath()
        ctx.arc(x, y, circleRarius, 0, Math.PI * 2,  true)
        ctx.fillStyle = circleColor
        ctx.fill()

        if(isKeyNodes)
        {
            ctx.beginPath()
            ctx.moveTo(x, y)
            ctx.lineTo(x + circleRarius * Math.cos(yaw), y + circleRarius* Math.sin(yaw))
        }
        ctx.stroke()
    })
}

function drawLine(ctx, nodes, lineWidth, lineColor)
{
    nodes.forEach(function(item, index){
        var x = item.x,
        y = item.y,
        yaw = item.yaw
        if (index) {
            var startX = nodes[index - 1].x,
            startY = nodes[index - 1].y
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = lineColor
            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.lineTo(x, y)
            ctx.stroke()
        }
    })

}

