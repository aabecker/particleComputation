//var top_boundary = [{ x: 0, y: 0 }, { x: 2240, y: 0 }, { x: 2240, y: 10 }, { x: 0, y: 10 }, { x: 0, y: 0 }]; //x,y points of the top boundary

function detectIntersectionLSL(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod) {
    var leftcircle_x = Number((leftcircle(start, r))[0]);
    var leftcircle_y = Number((leftcircle(start, r))[1]);
    var startAngle = Math.atan2(b - leftcircle_y, a - leftcircle_x);
    var endAngle = Math.atan2(start[1] - leftcircle_y, start[0] - leftcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, 1, mirrored_rod, leftcircle_x, leftcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }
    var leftcircle_x = Number((leftcircle(goal, r))[0]);
    var leftcircle_y = Number((leftcircle(goal, r))[1]);
    var startAngle = Math.atan2(goal[1] - leftcircle_y, goal[0] - leftcircle_x);
    var endAngle = Math.atan2(e - leftcircle_y, d - leftcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, 1, mirrored_rod, leftcircle_x, leftcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }
    //detect polygons along the straight line segment of the path
    var detect_intersect = detectIntersectLine(a, b, d, e, straight, -1, mirrored_rod, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }
    return 0; //when no intersection detected

}

function drawLSL(a, b, d, e, straight, start, goal, r, ctx) {
    var leftcircle_x = Number((leftcircle(start, r))[0]);
    var leftcircle_y = Number((leftcircle(start, r))[1]);
    var startAngle = Math.atan2(b - leftcircle_y, a - leftcircle_x);
    var endAngle = Math.atan2(start[1] - leftcircle_y, start[0] - leftcircle_x);
    ctx.beginPath();
    ctx.arc(leftcircle_x, leftcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(220, 0, 220)';
    ctx.stroke();
    //drawPolygonsArc(startAngle, endAngle, 0.2, leftcircle_x, leftcircle_y, r, 1, ctx);

    var leftcircle_x = Number((leftcircle(goal, r))[0]);
    var leftcircle_y = Number((leftcircle(goal, r))[1]);
    var startAngle = Math.atan2(goal[1] - leftcircle_y, goal[0] - leftcircle_x);
    var endAngle = Math.atan2(e - leftcircle_y, d - leftcircle_x);
    ctx.beginPath();
    ctx.arc(leftcircle_x, leftcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(220, 0, 220)';
    ctx.stroke();
    //drawPolygonsArc(startAngle, endAngle, 0.2, leftcircle_x, leftcircle_y, r, 1, ctx);

    ctx.beginPath();
    ctx.moveTo(a, b);
    ctx.lineTo(d, e);
    ctx.strokeStyle = 'rgb(220, 0, 220)';
    ctx.stroke();
    //drawPolygonsLine(a, b, d, e, straight, r, -1, ctx)

}

function detectIntersectionRSR(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod) {
    var rightcircle_x = Number((rightcircle(start, r))[0]);
    var rightcircle_y = Number((rightcircle(start, r))[1]);
    var endAngle = Math.atan2(b - rightcircle_y, a - rightcircle_x);
    var startAngle = Math.atan2(start[1] - rightcircle_y, start[0] - rightcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, -1, mirrored_rod, rightcircle_x, rightcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    var rightcircle_x = Number((rightcircle(goal, r))[0]);
    var rightcircle_y = Number((rightcircle(goal, r))[1]);
    var endAngle = Math.atan2(goal[1] - rightcircle_y, goal[0] - rightcircle_x);
    var startAngle = Math.atan2(e - rightcircle_y, d - rightcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, -1, mirrored_rod, rightcircle_x, rightcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    //detect polygons along the straight line segment of the path
    var detect_intersect = detectIntersectLine(a, b, d, e, straight, -1, mirrored_rod, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }
    return 0;
}

function drawRSR(a, b, d, e, straight, start, goal, r, ctx) {
    var rightcircle_x = Number((rightcircle(start, r))[0]);
    var rightcircle_y = Number((rightcircle(start, r))[1]);
    var endAngle = Math.atan2(b - rightcircle_y, a - rightcircle_x);
    var startAngle = Math.atan2(start[1] - rightcircle_y, start[0] - rightcircle_x);
    ctx.beginPath();
    ctx.arc(rightcircle_x, rightcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(220, 220, 0)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, rightcircle_x, rightcircle_y, r, -1, ctx);

    var rightcircle_x = Number((rightcircle(goal, r))[0]);
    var rightcircle_y = Number((rightcircle(goal, r))[1]);
    var endAngle = Math.atan2(goal[1] - rightcircle_y, goal[0] - rightcircle_x);
    var startAngle = Math.atan2(e - rightcircle_y, d - rightcircle_x);
    ctx.beginPath();
    ctx.arc(rightcircle_x, rightcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(220, 220, 0)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, rightcircle_x, rightcircle_y, r, -1, ctx);

    ctx.beginPath();
    ctx.moveTo(a, b);
    ctx.lineTo(d, e);
    ctx.strokeStyle = 'rgb(220, 220, 0)';
    ctx.stroke();
    drawPolygonsLine(a, b, d, e, straight, r, -1, ctx);

}


function detectIntersectionRSL(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod) {
    var rightcircle_x = Number((rightcircle(start, r))[0]);
    var rightcircle_y = Number((rightcircle(start, r))[1]);
    var endAngle = Math.atan2(b - rightcircle_y, a - rightcircle_x);
    var startAngle = Math.atan2(start[1] - rightcircle_y, start[0] - rightcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, -1, mirrored_rod, rightcircle_x, rightcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    var leftcircle_x = Number((leftcircle(goal, r))[0]);
    var leftcircle_y = Number((leftcircle(goal, r))[1]);
    var startAngle = Math.atan2(goal[1] - leftcircle_y, goal[0] - leftcircle_x);
    var endAngle = Math.atan2(e - leftcircle_y, d - leftcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, 1, mirrored_rod, leftcircle_x, leftcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    //detect polygons along the straight line segment of the path
    var detect_intersect = detectIntersectLine(a, b, d, e, straight, -1, mirrored_rod, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }
    return 0; //when no intersection detected

}

function drawRSL(a, b, d, e, straight, start, goal, r, ctx) {
    var rightcircle_x = Number((rightcircle(start, r))[0]);
    var rightcircle_y = Number((rightcircle(start, r))[1]);
    var endAngle = Math.atan2(b - rightcircle_y, a - rightcircle_x);
    var startAngle = Math.atan2(start[1] - rightcircle_y, start[0] - rightcircle_x);
    ctx.beginPath();
    ctx.arc(rightcircle_x, rightcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(0, 220, 220)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, rightcircle_x, rightcircle_y, r, -1, ctx);

    var leftcircle_x = Number((leftcircle(goal, r))[0]);
    var leftcircle_y = Number((leftcircle(goal, r))[1]);
    var startAngle = Math.atan2(goal[1] - leftcircle_y, goal[0] - leftcircle_x);
    var endAngle = Math.atan2(e - leftcircle_y, d - leftcircle_x);
    ctx.beginPath();
    ctx.arc(leftcircle_x, leftcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(0, 220, 220)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, leftcircle_x, leftcircle_y, r, 1, ctx);

    ctx.beginPath();
    ctx.moveTo(a, b);
    ctx.lineTo(d, e);
    ctx.strokeStyle = 'rgb(0, 220, 220)';
    ctx.stroke();

    drawPolygonsLine(a, b, d, e, straight, r, -1, ctx);

}

function detectIntersectionLSR(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod) {
    var leftcircle_x = Number((leftcircle(start, r))[0]);
    var leftcircle_y = Number((leftcircle(start, r))[1]);
    var startAngle = Math.atan2(b - leftcircle_y, a - leftcircle_x);
    var endAngle = Math.atan2(start[1] - leftcircle_y, start[0] - leftcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, 1, mirrored_rod, leftcircle_x, leftcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    var rightcircle_x = Number((rightcircle(goal, r))[0]);
    var rightcircle_y = Number((rightcircle(goal, r))[1]);
    var endAngle = Math.atan2(goal[1] - rightcircle_y, goal[0] - rightcircle_x);
    var startAngle = Math.atan2(e - rightcircle_y, d - rightcircle_x);
    var detect_intersect = detectIntersectArc(startAngle, endAngle, 0.2, -1, mirrored_rod, rightcircle_x, rightcircle_y, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    //detect polygons along the straight line segment of the path
    var detect_intersect = detectIntersectLine(a, b, d, e, straight, -1, mirrored_rod, r, threshold_collision)
    if (detect_intersect == 1) {
        return 1;

    }

    return 0; //when no intersection detected

}

function drawLSR(a, b, d, e, straight, start, goal, r, ctx) {
    var leftcircle_x = Number((leftcircle(start, r))[0]);
    var leftcircle_y = Number((leftcircle(start, r))[1]);
    var startAngle = Math.atan2(b - leftcircle_y, a - leftcircle_x);
    var endAngle = Math.atan2(start[1] - leftcircle_y, start[0] - leftcircle_x);
    ctx.beginPath();
    ctx.arc(leftcircle_x, leftcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(20, 15, 20)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, leftcircle_x, leftcircle_y, r, 1, ctx);

    var rightcircle_x = Number((rightcircle(goal, r))[0]);
    var rightcircle_y = Number((rightcircle(goal, r))[1]);
    var endAngle = Math.atan2(goal[1] - rightcircle_y, goal[0] - rightcircle_x);
    var startAngle = Math.atan2(e - rightcircle_y, d - rightcircle_x);
    ctx.beginPath();
    ctx.arc(rightcircle_x, rightcircle_y, r, startAngle, endAngle, false);
    ctx.strokeStyle = 'rgb(20, 15, 20)';
    ctx.stroke();
    drawPolygonsArc(startAngle, endAngle, 0.2, rightcircle_x, rightcircle_y, r, -1, ctx);

    ctx.beginPath();
    ctx.moveTo(a, b);
    ctx.lineTo(d, e);
    ctx.strokeStyle = 'rgb(20, 15, 20)';
    ctx.stroke();
    drawPolygonsLine(a, b, d, e, straight, r, -1, ctx);

}

function detectIntersectArc(startAngle, endAngle, division_factor, sign, mirrored_rod, center_x, center_y, r, threshold_collision) {
    if (endAngle < startAngle) {
        endAngle += 2 * Math.PI;
    }
    var angle_diff = endAngle - startAngle;
    var angle_ratio = Math.floor(angle_diff / division_factor);
    var angle = endAngle;
    for (i = 0; i <= angle_ratio; i++) {
        var xcoord_pt2 = center_x + r * Math.cos(angle);
        var ycoord_pt2 = center_y + r * Math.sin(angle);
        var polygon_pts = rodPolygonPoints(xcoord_pt2, ycoord_pt2, angle, sign);
        var colliders = greinerHormann.intersection(polygon_pts, mirrored_rod);
        //var top_colliders = greinerHormann.intersection(polygon_pts, top_boundary);
        if (colliders !== null) {
            var area1 = intersectionarea(colliders); //returns the intersected area
            //console.log(area1);
            if (area1 >= threshold_collision) {
                return 1;
            }
        }
        /*else if (top_colliders !== null) {
            return 1;
        }*/
        angle = angle - division_factor;
    }
    return 0;
}

function detectIntersectLine(a, b, d, e, straight, sign, mirrored_rod, r, threshold_collision) {
    var ratio = Math.floor(Number(straight) * 5 / r); //TODO; Change r to width of the polygon
    var lineangle = -(Math.atan2(Number(d) - Number(a), Number(e) - Number(b)));
    var t = 0;
    while (t <= 1) {
        var xcoord = Number(a) * (1 - t) + Number(d) * t;
        var ycoord = Number(b) * (1 - t) + Number(e) * t;
        var polygon_pts = rodPolygonPoints(xcoord, ycoord, lineangle, sign);
        var colliders = greinerHormann.intersection(polygon_pts, mirrored_rod);
        //var top_colliders = greinerHormann.intersection(polygon_pts, top_boundary);
        if (colliders !== null) {
            area1 = intersectionarea(colliders); //returns the intersected area
            if (area1 >= threshold_collision) {
                return 1;
            }
        }
        /*else if (top_colliders !== null) {
            return 1;
        }*/
        t = t + 1 / ratio;
    }
    return 0;
}

function drawPolygonsArc(startAngle, endAngle, division_factor, center_x, center_y, r, sign, ctx) {
    if (endAngle < startAngle) {
        endAngle += 2 * Math.PI;
    }
    var angle_diff = endAngle - startAngle;
    var angle_ratio = Math.floor(angle_diff / division_factor);
    var angle = endAngle;
    for (i = 0; i <= angle_ratio; i++) {
        var xcoord_pt2 = center_x + r * Math.cos(angle);
        var ycoord_pt2 = center_y + r * Math.sin(angle);
        var polygon_pts = rodPolygonPoints(xcoord_pt2, ycoord_pt2, angle, sign);
        drawPolygon(polygon_pts, "green", ctx);
        angle = angle - division_factor;
    }
}

function drawPolygonsLine(a, b, d, e, straight, r, sign, ctx) {
    var ratio = Math.floor(Number(straight) * 5 / r); //TODO; Change r to width of the polygon
    var lineangle = -(Math.atan2(Number(d) - Number(a), Number(e) - Number(b)));
    var t = 0;
    while (t <= 1) {
        var xcoord = Number(a) * (1 - t) + Number(d) * t;
        var ycoord = Number(b) * (1 - t) + Number(e) * t;
        var polygon_pts = rodPolygonPoints(xcoord, ycoord, lineangle, sign);
        var polygon_pts = rodPolygonPoints(xcoord, ycoord, lineangle, sign);
        drawPolygon(polygon_pts, "green", ctx);
        t = t + 1 / ratio;
    }
}
