//function for path lsl
function lsl(csl, cgl, start, goal, r) {
    var theta = (Math.PI / 2);
    theta = theta + Math.atan2(cgl[1] - csl[1], cgl[0] - csl[0]);
    var xT1 = (Number(csl[0]) + r * Math.cos(theta));
    var yT1 = Number(csl[1]) + r * Math.sin(theta);

    var xT2 = xT1 + (cgl[0] - csl[0]);
    var yT2 = yT1 + (cgl[1] - csl[1]);

    var arc1 = arclength(csl, start, [xT1, yT1], -1, r);
    var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
    var arc2 = arclength(cgl, [xT2, yT2], goal, -1, r);
    var total_length = arc1 + straight + arc2;
    var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2), straight.toFixed(2)]; // x,y of tangents
    return tangents;
}

//function for calculating arc lengths
function arclength(center, start1, end1, dir, r) {
    var theta = Math.atan2(Number(end1[1]) - Number(center[1]), Number(end1[0]) - Number(center[0])) - Math.atan2(start1[1] - center[1], start1[0] - center[0]);
    if (theta < 0 && dir > 0) {//dir>0 for right
        theta = theta + 2 * Math.PI;
    }
    else if (theta > 0 && dir < 0) {
        theta = theta - 2 * Math.PI;
    }
    var length = Math.abs(theta * r);
    return length;
}


//function for right circle
function rightcircle(array, r) {
    var x = array[0] + r * Math.sin(array[2] + (Math.PI / 2));
    var y = array[1] + r * Math.cos(array[2] + (Math.PI / 2));
    var coordinates = [x.toFixed(2), y.toFixed(2)];
    return coordinates;
}

//function for left circle
function leftcircle(array, r) {
    var x = array[0] + r * Math.sin(array[2] - (Math.PI / 2));
    var y = array[1] + r * Math.cos(array[2] - (Math.PI / 2));
    var coordinates = [x.toFixed(2), y.toFixed(2)];
    return coordinates;
}


//function for drawing polygon on canvas
    //sign is -1 when not inverted, +1 when inverted
    //TODO: draw a polygon some other way
    function drawPolygon(xcoord, ycoord, lineangle, color, sign,ctx) {
        ctx.beginPath();
        ctx.moveTo(xcoord, ycoord);
        ctx.lineTo(xcoord + 35.16 * Math.cos(lineangle + sign * (1.081)), ycoord + 35.16 * Math.sin(lineangle + sign * (1.081)));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283)));
        ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)) + 35.16 * Math.cos(lineangle + sign * (5.202)), (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283)) + 35.16 * Math.sin(lineangle + sign * (5.202)));
        //ctx.closePath();
        ctx.strokeStyle = color;
        ctx.stroke();

        var polygon_pts = [{ x: xcoord, y: ycoord },
        { x: xcoord + 35.16 * Math.cos(lineangle + sign * (1.081)), y: ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))},
        { x: xcoord + 35.16 * Math.cos(lineangle + sign * (1.081)) + 102 * Math.cos(lineangle + 0), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0)},
        { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142))},
        { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142))},
        { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712))},
        { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283))},
        { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)) + 35.16 * Math.cos(lineangle + sign * (5.202)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283)) + 35.16 * Math.sin(lineangle + sign * (5.25))}
        ];

        return polygon_pts;

    }

