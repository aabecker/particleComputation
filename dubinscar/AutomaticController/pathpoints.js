function pathpoints(start, goal, r, a, b, d, e, straight) {
    //array for saving the points
    var path_points = [
        { x: 'LSL', y: arc_lsl, angle: 0 },
       // { }
    ];

    //points along the starting arc
    var division_factor = 0.2;
    var leftcircle_x = Number((leftcircle(start, r))[0]);
    var leftcircle_y = Number((leftcircle(start, r))[1]);
    var startAngle = Math.atan2(b - leftcircle_y, a - leftcircle_x);
    var endAngle = Math.atan2(start[1] - leftcircle_y, start[0] - leftcircle_x);

    if (endAngle < startAngle) {
        endAngle += 2 * Math.PI;
    }
    var angle_diff = endAngle - startAngle;
    var angle_ratio = Math.floor(angle_diff / division_factor);
    var angle = endAngle;
    for (i = 0; i <= angle_ratio; i++) {
        var xcoord_pt2 = center_x + r * Math.cos(angle);
        var ycoord_pt2 = center_y + r * Math.sin(angle);
        //var polygon_pts = rodPolygonPoints(xcoord_pt2, ycoord_pt2, angle, sign);
        angle = angle - division_factor;
    }

    //points along the end arc
    var leftcircle_x = Number((leftcircle(goal, r))[0]);
    var leftcircle_y = Number((leftcircle(goal, r))[1]);
    var startAngle = Math.atan2(goal[1] - leftcircle_y, goal[0] - leftcircle_x);
    var endAngle = Math.atan2(e - leftcircle_y, d - leftcircle_x);
    if (endAngle < startAngle) {
        endAngle += 2 * Math.PI;
    }
    var angle_diff = endAngle - startAngle;
    var angle_ratio = Math.floor(angle_diff / division_factor);
    var angle = endAngle;
    for (i = 0; i <= angle_ratio; i++) {
        var xcoord_pt2 = center_x + r * Math.cos(angle);
        var ycoord_pt2 = center_y + r * Math.sin(angle);
        //var polygon_pts = rodPolygonPoints(xcoord_pt2, ycoord_pt2, angle, sign);
        angle = angle - division_factor;
    }

    //points along the straight segment
    var ratio = Math.floor(Number(straight) * 5 / r);
    //var lineangle = -(Math.atan2(Number(d) - Number(a), Number(e) - Number(b)));
    var t = 0;
    while (t <= 1) {
        var xcoord = Number(a) * (1 - t) + Number(d) * t;
        var ycoord = Number(b) * (1 - t) + Number(e) * t;
        t = t + 1 / ratio;
    }
}