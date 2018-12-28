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

//function for path RSR
function rsr(csr, cgr, start, goal, r) {
    var theta = (Math.PI / 2);
    theta = theta + Math.atan2(cgr[1] - csr[1], cgr[0] - csr[0]) + Math.PI;
    var xT1 = (Number(csr[0]) + r * Math.cos(theta));
    var yT1 = Number(csr[1]) + r * Math.sin(theta);

    var xT2 = xT1 + (cgr[0] - csr[0]);
    var yT2 = yT1 + (cgr[1] - csr[1]);

    var arc1 = arclength(csr, start, [xT1, yT1], 1, r);
    var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
    var arc2 = arclength(cgr, [xT2, yT2], goal, 1, r);
    var total_length = arc1 + straight + arc2;
    //var total_length = straight;

    var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2), straight.toFixed(2)]; // x,y of tangents
    return tangents;
}

//function for path RSL
function rsl(csr, cgl, start, goal, r) {
    var compare = Math.sqrt(Math.pow((cgl[1] - csr[1]), 2) + Math.pow((cgl[0] - csr[0]), 2));
    if (compare > 2 * r) {
        var D = Math.sqrt(Math.pow((cgl[1] - csr[1]), 2) + Math.pow((cgl[0] - csr[0]), 2));
        var theta = Math.acos((2 * r) / D);
        theta = theta * (-1);
        theta = theta + Math.atan2(cgl[1] - csr[1], cgl[0] - csr[0]);
        var xT1 = (Number(csr[0]) + r * Math.cos(theta));
        var yT1 = Number(csr[1]) + r * Math.sin(theta);

        var xT1_tmp = (Number(csr[0]) + 2 * r * Math.cos(theta));
        var yT1_tmp = Number(csr[1]) + 2 * r * Math.sin(theta);

        var xT2 = xT1 + (cgl[0] - xT1_tmp);
        var yT2 = yT1 + (cgl[1] - yT1_tmp);

        var arc1 = arclength(csr, start, [xT1, yT1], 1, r);
        var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
        var arc2 = arclength(cgl, [xT2, yT2], goal, -1, r);
        var total_length = arc1 + straight + arc2;
        //var total_length = straight;

        var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2), straight.toFixed(2)]; // x,y of tangents
        return tangents;
    }
    else {
        return 0;
    }
}


//function for path lsr
function lsr(csl, cgr, start, goal, r) {
    var compare = Math.sqrt(Math.pow((cgr[1] - csl[1]), 2) + Math.pow((cgr[0] - csl[0]), 2));
    if (compare > 2 * r) {
        var D = Math.sqrt(Math.pow((cgr[1] - csl[1]), 2) + Math.pow((cgr[0] - csl[0]), 2));
        var theta = Math.acos((2 * r) / D);
        theta = theta + Math.atan2(cgr[1] - csl[1], cgr[0] - csl[0]);
        var xT1 = (Number(csl[0]) + r * Math.cos(theta));
        var yT1 = Number(csl[1]) + r * Math.sin(theta);

        var xT1_tmp = (Number(csl[0]) + 2 * r * Math.cos(theta));
        var yT1_tmp = Number(csl[1]) + 2 * r * Math.sin(theta);

        var xT2 = xT1 + (cgr[0] - xT1_tmp);
        var yT2 = yT1 + (cgr[1] - yT1_tmp);

        var arc1 = arclength(csl, start, [xT1, yT1], -1, r);
        var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
        var arc2 = arclength(cgr, [xT2, yT2], goal, 1, r);
        var total_length = arc1 + straight + arc2;
        //var total_length = straight;

        var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2), straight.toFixed(2)]; // x,y of tangents
        return tangents;
    }
    else {
        return 0;
    }
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
/*function drawPolygon(xcoord, ycoord, lineangle, color, sign, ctx) {
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
    { x: xcoord + 35.16 * Math.cos(lineangle + sign * (1.081)), y: ycoord + 35.16 * Math.sin(lineangle + sign * (1.081)) },
    { x: xcoord + 35.16 * Math.cos(lineangle + sign * (1.081)) + 102 * Math.cos(lineangle + 0), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) },
    { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) },
    { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) },
    { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) },
    { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283)) },
    { x: (xcoord + 35.16 * Math.cos(lineangle + sign * (1.081))) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + sign * (1.5708)) + 240 * Math.cos(lineangle + sign * (3.142)) + 30 * Math.cos(lineangle + sign * (4.712)) + 102 * Math.cos(lineangle + sign * (6.283)) + 35.16 * Math.cos(lineangle + sign * (5.202)), y: (ycoord + 35.16 * Math.sin(lineangle + sign * (1.081))) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + sign * (1.5708)) + 240 * Math.sin(lineangle + sign * (3.142)) + 30 * Math.sin(lineangle + sign * (4.712)) + 102 * Math.sin(lineangle + sign * (6.283)) + 35.16 * Math.sin(lineangle + sign * (5.25)) }
    ];

    return polygon_pts;

}*/

//TODO: Make a function which can draw the points passed as input arguments

function drawPolygon(polygon_pts, color, ctx) {
    ctx.beginPath();
    ctx.moveTo(polygon_pts[0].x, polygon_pts[0].y);
    for (var i = 1; i < polygon_pts.length; i++) {
        ctx.lineTo(polygon_pts[i].x, polygon_pts[i].y);
    }
    ctx.closePath();
    ctx.strokeStyle = color;
    ctx.stroke();
}

function DrawArrow(xcoord, ycoord, lineangle, ctx, color) {
    //draw arrow at start and goal
    var length = 50;
    ctx.beginPath();
    ctx.moveTo(xcoord, ycoord);
    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle + 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle + 2.356));
    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle - 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle - 2.356));
    ctx.strokeStyle = color;
    ctx.lineWidth = 3;
    ctx.stroke();
}


function LeftRightCircles(leftstartx, leftstarty, leftgoalx, leftgoaly, rightstartx, rightstarty, rightgoalx, rightgoaly, ctx, r) {
    //draw the left and right circles at the start and goal
    ctx.beginPath();
    ctx.arc(leftstartx, leftstarty, r, 0, 2 * Math.PI, false);
    ctx.strokeStyle = 'rgb(0, 0, 220)';
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(leftgoalx, leftgoaly, r, 0, 2 * Math.PI, false);
    ctx.strokeStyle = 'rgb(0, 0, 220)';
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(rightstartx, rightstarty, r, 0, 2 * Math.PI, false);
    ctx.strokeStyle = 'rgb(0, 0, 220)';
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(rightgoalx, rightgoaly, r, 0, 2 * Math.PI, false);
    ctx.strokeStyle = 'rgb(0, 0, 220)';
    ctx.stroke();

}

//function for calculating intersection area
function intersectionarea(colliders) {
    var area = 0;
    for (var ji = 0; ji < colliders.length; ji++) {
        for (var ij = 0; ij < colliders[ji].length - 1; ij++) {
            area += ((colliders[ji][ij].x) * (colliders[ji][ij + 1].y)) - ((colliders[ji][ij].y) * (colliders[ji][ij + 1].x));
        }
    }
    area = Math.abs(area / 2);
    return area;
}

//function for drawing intersected polygon
function drawIntersectedPolygon(colliders, ctx) {
    for (var ii = 0; ii < colliders.length; ii++) {
        ctx.beginPath();
        ctx.moveTo(colliders[ii][0].x, colliders[ii][0].y);
        for (var jj = 0; jj < colliders[ii].length; jj++) {
            ctx.lineTo(colliders[ii][jj].x, colliders[ii][jj].y);
        }
        ctx.fillStyle = "yellow";
        ctx.fill();
    }
}

function mirroredRodPoints(xcoord, ycoord, lineangle) {
    return [{ x: xcoord, y: ycoord },
    { x: xcoord + 37.5 * Math.cos(lineangle + 0.927), y: ycoord + 37.5 * Math.sin(lineangle + 0.927) },
    { x: xcoord + 37.5 * Math.cos(lineangle + 0.927) + 97.5 * Math.cos(lineangle + 0), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) },
    { x: (xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) },
    { x: (xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) },
    { x: (xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708) },
    { x: (xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708) + 97.5 * Math.cos(lineangle + 6.283), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708) + 97.5 * Math.sin(lineangle + 6.283) },
    { x: (xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708) + 97.5 * Math.cos(lineangle + 6.283) + 37.5 * Math.cos(lineangle + 5.355), y: (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708) + 97.5 * Math.sin(lineangle + 6.283) + 37.5 * Math.sin(lineangle + 5.355) }
    ];
}

function rodPolygonPoints(xcoord_pt2, ycoord_pt2, angle, sign) {
    return [{ x: xcoord_pt2, y: ycoord_pt2 },
    { x: xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081)), y: ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081)) },
    { x: xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081)) + 102 * Math.cos(angle + 0), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) },
    { x: (xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081))) + 102 * Math.cos(angle + 0) + 30 * Math.cos(angle + sign * (1.5708)), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) + 30 * Math.sin(angle + sign * (1.5708)) },
    { x: (xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081))) + 102 * Math.cos(angle + 0) + 30 * Math.cos(angle + sign * (1.5708)) + 240 * Math.cos(angle + sign * (3.142)), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) + 30 * Math.sin(angle + sign * (1.5708)) + 240 * Math.sin(angle + sign * (3.142)) },
    { x: (xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081))) + 102 * Math.cos(angle + 0) + 30 * Math.cos(angle + sign * (1.5708)) + 240 * Math.cos(angle + sign * (3.142)) + 30 * Math.cos(angle + sign * (4.712)), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) + 30 * Math.sin(angle + sign * (1.5708)) + 240 * Math.sin(angle + sign * (3.142)) + 30 * Math.sin(angle + sign * (4.712)) },
    { x: (xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081))) + 102 * Math.cos(angle + 0) + 30 * Math.cos(angle + sign * (1.5708)) + 240 * Math.cos(angle + sign * (3.142)) + 30 * Math.cos(angle + sign * (4.712)) + 102 * Math.cos(angle + sign * (6.283)), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) + 30 * Math.sin(angle + sign * (1.5708)) + 240 * Math.sin(angle + sign * (3.142)) + 30 * Math.sin(angle + sign * (4.712)) + 102 * Math.sin(angle + sign * (6.283)) },
    { x: (xcoord_pt2 + 35.16 * Math.cos(angle + sign * (1.081))) + 102 * Math.cos(angle + 0) + 30 * Math.cos(angle + sign * (1.5708)) + 240 * Math.cos(angle + sign * (3.142)) + 30 * Math.cos(angle + sign * (4.712)) + 102 * Math.cos(angle + sign * (6.283)) + 35.16 * Math.cos(angle + sign * (5.202)), y: (ycoord_pt2 + 35.16 * Math.sin(angle + sign * (1.081))) + 102 * Math.sin(angle + 0) + 30 * Math.sin(angle + sign * (1.5708)) + 240 * Math.sin(angle + sign * (3.142)) + 30 * Math.sin(angle + sign * (4.712)) + 102 * Math.sin(angle + sign * (6.283)) + 35.16 * Math.sin(angle + sign * (5.25)) }
    ];
}
