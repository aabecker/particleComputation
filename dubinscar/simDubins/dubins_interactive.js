var rSlider, xSlider, ySlider;
var goal = [300, 310, 4.7]; //starting point: x,y,angle
var start = [420, 300, 2.34];  //ending point: x,y,angle
var r = 40; //radius of curvature



function setup() {
    // create canvas
    createCanvas(900, 600);
    textSize(15);
    noStroke();

    // create sliders
    rSlider = createSlider(0, 50, 40);
    rSlider.position(20, 20);
    xSlider = createSlider(50, 850, 300);
    xSlider.position(20, 50);
    ySlider = createSlider(200, 500, 310);
    ySlider.position(20, 80);


}

function draw() {
    var radius = rSlider.value();
    var xcoord = xSlider.value();
    var ycoord = ySlider.value();
    background(150, 150, 150);
    // Set colors
    fill(0, 0, 0);
    noStroke();
    text("radius", rSlider.x * 2 + rSlider.width, 35);
    text("goal xcoordinate", xSlider.x * 2 + xSlider.width, 65);
    text("goal ycoordinate", ySlider.x * 2 + ySlider.width, 95);
    text("LSL path is black, RSR is light blue, RSL is pink,",400,30);
    text("LSR is yellow, LRL is red, RLR is green",400,50);

    // Green Dot at the goal
    fill(0, 220, 0);
    stroke(0, 220, 0);
    ellipse(xcoord, ycoord, 8, 8);
    var cgl = leftcircle([xcoord, ycoord, 4.7], radius);
    var cgr = rightcircle([xcoord, ycoord, 4.7], radius);

    //right and left circles at the goal
    noFill();
    stroke(0, 0, 220);
    ellipse(cgl[0], cgl[1], radius * 2, radius * 2);
    ellipse(cgr[0], cgr[1], radius * 2, radius * 2);

    //right and left circles at the start
    var csl = leftcircle(start, radius);
    var csr = rightcircle(start, radius);
    noFill();
    stroke(0, 0, 220);
    ellipse(csl[0], csl[1], radius * 2, radius * 2);
    ellipse(csr[0], csr[1], radius * 2, radius * 2);

    //Dot at the start
    fill(220, 0, 0);
    stroke(220, 0, 0);
    ellipse(start[0], start[1], 8, 8);


    //start drawing path LSL
    var a = lsl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[0];
    var b = lsl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[1];
    var d = lsl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[2];
    var e = lsl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[3];
    var startAngle = Math.atan2(b - ((leftcircle(start, radius))[1]), a - ((leftcircle(start, radius))[0]));
    var endAngle = Math.atan2(start[1] - ((leftcircle(start, radius))[1]), start[0] - ((leftcircle(start, radius))[0]));
    noFill();
    stroke(0, 0, 0);
    //arc(Number(csl[0]), Number(csl[1]), radius * 2, radius * 2, 0, PI);
    arc(Number(csl[0]), Number(csl[1]), radius * 2, radius * 2, startAngle, endAngle);
    line(a, b, d, e);
    var startAngle = Math.atan2(ycoord - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), xcoord - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
    var endAngle = Math.atan2(e - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), d - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
    arc(Number(cgl[0]), Number(cgl[1]), radius * 2, radius * 2, startAngle, endAngle);

    //start drawing path RSR
    var a = rsr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[0];
    var b = rsr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[1];
    var d = rsr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[2];
    var e = rsr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[3];
    noFill();
    stroke(0, 220, 220);
    line(a, b, d, e);
    var endAngle = Math.atan2(Number(b) - ((rightcircle(start, radius))[1]), Number(a) - ((rightcircle(start, radius))[0]));
    var startAngle = Math.atan2(start[1] - ((rightcircle(start, radius))[1]), start[0] - ((rightcircle(start, radius))[0]));
    arc(Number(csr[0]), Number(csr[1]), radius * 2, radius * 2, startAngle, endAngle);
    var endAngle = Math.atan2([xcoord, ycoord, 4.7][1] - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), [xcoord, ycoord, 4.7][0] - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
    var startAngle = Math.atan2(e - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), d - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
    arc(Number(cgr[0]), Number(cgr[1]), radius * 2, radius * 2, startAngle, endAngle);

    //start drawing path LSR
    if (lsr(csl, cgr, start, [xcoord, ycoord, 4.7], radius) !== 0) {
        var a = lsr(csl, cgr, start, [xcoord, ycoord, 4.7], radius)[0];
        var b = lsr(csl, cgr, start, [xcoord, ycoord, 4.7], radius)[1];
        var d = lsr(csl, cgr, start, [xcoord, ycoord, 4.7], radius)[2];
        var e = lsr(csl, cgr, start, [xcoord, ycoord, 4.7], radius)[3];
        noFill();
        stroke(220, 220, 0);
        line(a, b, d, e);
        var startAngle = Math.atan2(b - ((leftcircle(start, radius))[1]), a - ((leftcircle(start, radius))[0]));
        var endAngle = Math.atan2(start[1] - ((leftcircle(start, radius))[1]), start[0] - ((leftcircle(start, radius))[0]));
        arc(Number(csl[0]), Number(csl[1]), radius * 2, radius * 2, startAngle, endAngle);
        var endAngle = Math.atan2([xcoord, ycoord, 4.7][1] - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), [xcoord, ycoord, 4.7][0] - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
        var startAngle = Math.atan2(e - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), d - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
        arc(Number(cgr[0]), Number(cgr[1]), radius * 2, radius * 2, startAngle, endAngle);
    }

    //start drawing path RSL
    if (rsl(csr, cgl, start, goal, radius) !== 0) {
        var a = rsl(csr, cgl, start, [xcoord, ycoord, 4.7], radius)[0];
        var b = rsl(csr, cgl, start, [xcoord, ycoord, 4.7], radius)[1];
        var d = rsl(csr, cgl, start, [xcoord, ycoord, 4.7], radius)[2];
        var e = rsl(csr, cgl, start, [xcoord, ycoord, 4.7], radius)[3];
        noFill();
        stroke(220, 0, 220);
        line(a, b, d, e);
        var endAngle = Math.atan2(b - ((rightcircle(start, radius))[1]), a - ((rightcircle(start, radius))[0]));
        var startAngle = Math.atan2(start[1] - ((rightcircle(start, radius))[1]), start[0] - ((rightcircle(start, radius))[0]));
        arc(Number(csr[0]), Number(csr[1]), radius * 2, radius * 2, startAngle, endAngle);
        var startAngle = Math.atan2([xcoord, ycoord, 4.7][1] - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), [xcoord, ycoord, 4.7][0] - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
        var endAngle = Math.atan2(e - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), d - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
        arc(Number(cgl[0]), Number(cgl[1]), radius * 2, radius * 2, startAngle, endAngle);
    }

    //start drawing path LRL
    if (lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius) !== 0) {
        var a = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[0];
        var b = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[1];
        var d = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[2];
        var e = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[3];
        var f = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[4];
        var g = lrl(csl, cgl, start, [xcoord, ycoord, 4.7], radius)[5];
        noFill();
        stroke(220, 0, 0);
        var startAngle = Math.atan2(Number(g) - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), Number(f) - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
        var endAngle = Math.atan2([xcoord, ycoord, 4.7][1] - ((leftcircle([xcoord, ycoord, 4.7], radius))[1]), [xcoord, ycoord, 4.7][0] - ((leftcircle([xcoord, ycoord, 4.7], radius))[0]));
        arc(Number(cgl[0]), Number(cgl[1]), radius * 2, radius * 2, endAngle, startAngle);

        var startAngle = Math.atan2(Number(e) - ((leftcircle(start, radius))[1]), Number(d) - ((leftcircle(start, radius))[0]));
        var endAngle = Math.atan2(start[1] - ((leftcircle(start, radius))[1]), start[0] - ((leftcircle(start, radius))[0]));
        arc(Number(csl[0]), Number(csl[1]), radius * 2, radius * 2, startAngle, endAngle);

        var startAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
        var endAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
        arc(Number(a), Number(b), radius * 2, radius * 2, startAngle, endAngle);
    }

    //start drawing path RLR
    if (rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius) !== 0) {
        var a = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[0];
        var b = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[1];
        var d = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[2];
        var e = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[3];
        var f = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[4];
        var g = rlr(csr, cgr, start, [xcoord, ycoord, 4.7], radius)[5];
        noFill();
        stroke(0, 220, 0);
        var endAngle = Math.atan2(Number(g) - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), Number(f) - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
        var startAngle = Math.atan2([xcoord, ycoord, 4.7][1] - ((rightcircle([xcoord, ycoord, 4.7], radius))[1]), [xcoord, ycoord, 4.7][0] - ((rightcircle([xcoord, ycoord, 4.7], radius))[0]));
        arc(Number(cgr[0]), Number(cgr[1]), radius * 2, radius * 2, endAngle, startAngle);
        var endAngle = Math.atan2(Number(e) - ((rightcircle(start, radius))[1]), Number(d) - ((rightcircle(start, radius))[0]));
        var startAngle = Math.atan2(start[1] - ((rightcircle(start, radius))[1]), start[0] - ((rightcircle(start, radius))[0]));
        arc(Number(csr[0]), Number(csr[1]), radius * 2, radius * 2, startAngle, endAngle);   
        var startAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
        var endAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
        arc(Number(a), Number(b), radius * 2, radius * 2, endAngle, startAngle);
    }
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

//function for calculating arc lengths
function arclength(center, start1, end1, dir, r) {
    var theta = Math.atan2(Number(end1[1]) - Number(center[1]), Number(end1[0]) - Number(center[0])) - Math.atan2(start1[1] - center[1], start1[0] - center[0]);
    if (theta < 0 && dir > 0) {//dir>0 for left
        theta = theta + 2 * Math.PI;
    }
    else if (theta > 0 && dir < 0) {
        theta = theta - 2 * Math.PI;
    }
    var length = Math.abs(theta * r);
    return length;
}

//function for path LSL
function lsl(csl, cgl, start, goal, r) {
    var theta = (Math.PI / 2);
    theta = theta + Math.atan2(cgl[1] - csl[1], cgl[0] - csl[0]);
    var xT1 = (Number(csl[0]) + r * Math.cos(theta));
    var yT1 = Number(csl[1]) + r * Math.sin(theta);

    var xT2 = xT1 + (cgl[0] - csl[0]);
    var yT2 = yT1 + (cgl[1] - csl[1]);

    var arc1 = arclength(csl, [xT1, yT1], start, 1, r);
    var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
    var arc2 = arclength(cgl, goal, [xT2, yT2], 1, r);
    var total_length = arc1 + straight + arc2;
    var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
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

    var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
    return tangents;
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

        var arc1 = arclength(csl, [xT1, yT1], start, 1, r);
        var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
        var arc2 = arclength(cgr, goal, [xT2, yT2], 1, r);
        var total_length = arc1 + straight + arc2;

        var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
        return tangents;
    }
    else {
        return 0;
    }
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
        var arc2 = arclength(cgl, goal, [xT2, yT2], 1, r);
        var total_length = arc1 + straight + arc2;

        var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
        return tangents;
    }
    else {
        return 0;
    }
}

//Function for lrl path
function lrl(csl, cgl, start, goal, r) {
    var compare = Math.sqrt(Math.pow((cgl[1] - csl[1]), 2) + Math.pow((cgl[0] - csl[0]), 2));
    if (compare < 4 * r) {
        var D = Math.sqrt(Math.pow((cgl[1] - csl[1]), 2) + Math.pow((cgl[0] - csl[0]), 2));
        var theta = Math.acos(D / (4 * r));
        theta = theta + Math.atan2(cgl[1] - csl[1], cgl[0] - csl[0]);
        var x = Number(csl[0]) + 2 * r * Math.cos(theta);
        var y = Number(csl[1]) + 2 * r * Math.sin(theta);

        var arc1 = arclength(csl, [(x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2], start, 1, r);
        var arc2 = arclength([x, y], [(x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2], [(x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2], -1, r);
        var arc3 = arclength(csl, [(x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2], goal, 1, r);
        var total_length = arc1 + arc2 + arc3;
        return [Number(x.toFixed(2)), y.toFixed(2), (x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2, (x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2, total_length.toFixed(2)];
    }
    else {
        return 0;
    }
}

//Function for rlr path
function rlr(csr, cgr, start, goal, r) {
    var compare = Math.sqrt(Math.pow((cgr[1] - csr[1]), 2) + Math.pow((cgr[0] - csr[0]), 2));
    if (compare < 4 * r) {
        var D = Math.sqrt(Math.pow((cgr[1] - csr[1]), 2) + Math.pow((cgr[0] - csr[0]), 2));
        var theta = Math.acos(D / (4 * r));
        theta = Math.atan2(cgr[1] - csr[1], cgr[0] - csr[0]) - theta;
        var x = Number(csr[0]) + 2 * r * Math.cos(theta);
        var y = Number(csr[1]) + 2 * r * Math.sin(theta);

        var arc1 = arclength(csr, start, [(x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2], -1, r);
        var arc2 = arclength([x, y], [(x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2], [(x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2], 1, r);
        var arc3 = arclength(csr, goal, [(x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2], -1, r);
        var total_length = arc1 + arc2 + arc3;
        // return theta;
        return [Number(x.toFixed(2)), y.toFixed(2), (x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2, (x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2, total_length.toFixed(2)];
    }
    else {
        return 0;
    }
}
