//var start = [100, 210, 4.7]; //starting point: x,y,angle
//var goal = [220, 100, 3.9];  //ending point: x,y,angle
var goal = [100, 210, 4.7]; //starting point: x,y,angle
var start = [320, 200, 2.34];  //ending point: x,y,angle
var r = 40; //radius of curvature

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
var csl = leftcircle(start, r);
var cgl = leftcircle(goal, r);
var csr = rightcircle(start, r);
var cgr = rightcircle(goal, r);
//document.write("\nCoordinates are " + csl);
//document.write("\nCoordinates are " + csr);

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

//Draw the start and end on the canvas
var canvas = document.querySelector('canvas');
canvas.width = 500;
canvas.height = 500;
var c = canvas.getContext('2d');

c.beginPath();  //red start point
c.arc(start[0], start[1], 4, 0, Math.PI * 2, false);
c.fillStyle = 'rgb(200, 10, 10)';
c.fill();

c.beginPath();  //green end point
c.arc(goal[0], goal[1], 4, 0, Math.PI * 2, false);
c.fillStyle = 'rgb(0, 200, 10)';
c.fill();


//draw arrow at start
var xcoord = start[0];
var ycoord = start[1];
var length =  50;
var lineangle = -(start[2]+1.5708);
c.beginPath();
c.moveTo(xcoord, ycoord);
c.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
c.lineTo((xcoord + length * Math.cos(lineangle)) + 20*Math.cos(lineangle+2.356), (ycoord + length * Math.sin(lineangle))+20*Math.sin(lineangle+2.356));
c.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
c.lineTo((xcoord + length * Math.cos(lineangle)) + 20*Math.cos(lineangle-2.356), (ycoord + length * Math.sin(lineangle))+20*Math.sin(lineangle-2.356));
c.strokeStyle = 'rgb(220, 0, 0)';
c.stroke();

//draw arrow at goal
var xcoord = goal[0];
var ycoord = goal[1];
var length =  50;
var lineangle = -(goal[2]+1.5708);
c.beginPath();
c.moveTo(xcoord, ycoord);
c.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
c.lineTo((xcoord + length * Math.cos(lineangle)) + 20*Math.cos(lineangle+2.356), (ycoord + length * Math.sin(lineangle))+20*Math.sin(lineangle+2.356));
c.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
c.lineTo((xcoord + length * Math.cos(lineangle)) + 20*Math.cos(lineangle-2.356), (ycoord + length * Math.sin(lineangle))+20*Math.sin(lineangle-2.356));
c.strokeStyle = 'rgb(0, 220, 0)';
c.stroke();


c.beginPath();
c.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(0, 0, 220)';
c.stroke();

c.beginPath();
c.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(0, 0, 220)';
c.stroke();

c.beginPath();
c.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(0, 0, 220)';
c.stroke();

c.beginPath();
c.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(0, 0, 220)';
c.stroke();


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

//document.write("\nTangent points are " + lsl(csl, cgl, start, goal, r));
var a = lsl(csl, cgl, start, goal, r)[0];
var b = lsl(csl, cgl, start, goal, r)[1];
var d = lsl(csl, cgl, start, goal, r)[2];
var e = lsl(csl, cgl, start, goal, r)[3];


var startAngle = Math.atan2(b - ((leftcircle(start, r))[1]), a - ((leftcircle(start, r))[0]));
var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
//document.write("\nstart angle is " + startAngle);
//document.write("\nend angle is " + endAngle);
c.beginPath();
c.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
//c.arc((leftcircle(cst, r))[0], (leftcircle(cst, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(220, 0, 220)';
c.stroke();


var startAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
var endAngle = Math.atan2(e - ((leftcircle(goal, r))[1]), d - ((leftcircle(goal, r))[0]));
c.beginPath();
c.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, startAngle, endAngle, false);
//c.arc((leftcircle(cet, r))[0], (leftcircle(cet, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(220, 0, 220)';
c.stroke();


c.beginPath();
c.moveTo(a, b);
c.lineTo(d, e);
c.strokeStyle = 'rgb(220, 0, 220)';
c.stroke(); //Drawing lsl path ends here 


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

//document.write("\nTangent points are " + rsr(csr, cgr, start, goal, r));
var a = rsr(csr, cgr, start, goal, r)[0];
var b = rsr(csr, cgr, start, goal, r)[1];
var d = rsr(csr, cgr, start, goal, r)[2];
var e = rsr(csr, cgr, start, goal, r)[3];


var endAngle = Math.atan2(Number(b) - ((rightcircle(start, r))[1]), Number(a) - ((rightcircle(start, r))[0]));
var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
c.beginPath();
c.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
//c.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(220, 220, 0)';
c.stroke();


var endAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
var startAngle = Math.atan2(e - ((rightcircle(goal, r))[1]), d - ((rightcircle(goal, r))[0]));
c.beginPath();
c.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, startAngle, endAngle, false);
//c.arc((leftcircle(cet, r))[0], (leftcircle(cet, r))[1], r, 0, 2 * Math.PI, false);
c.strokeStyle = 'rgb(220, 220, 0)';
c.stroke();


c.beginPath();
c.moveTo(a, b);
c.lineTo(d, e);
c.strokeStyle = 'rgb(220, 220, 0)';
c.stroke(); //drawing rsr path ends here 


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

if (rsl(csr, cgl, start, goal, r) !== 0) {
    var a = rsl(csr, cgl, start, goal, r)[0];
    var b = rsl(csr, cgl, start, goal, r)[1];
    var d = rsl(csr, cgl, start, goal, r)[2];
    var e = rsl(csr, cgl, start, goal, r)[3];
    var endAngle = Math.atan2(b - ((rightcircle(start, r))[1]), a - ((rightcircle(start, r))[0]));
    var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
    c.beginPath();
    c.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
    //c.arc((leftcircle(cst, r))[0], (leftcircle(cst, r))[1], r, 0, 2 * Math.PI, false);
    c.strokeStyle = 'rgb(0, 220, 220)';
    c.stroke();


    var startAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
    var endAngle = Math.atan2(e - ((leftcircle(goal, r))[1]), d - ((leftcircle(goal, r))[0]));
    c.beginPath();
    c.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, startAngle, endAngle, false);
    //c.arc((leftcircle(cet, r))[0], (leftcircle(cet, r))[1], r, 0, 2 * Math.PI, false);
    c.strokeStyle = 'rgb(0, 220, 220)';
    c.stroke();


    c.beginPath();
    c.moveTo(a, b);
    c.lineTo(d, e);
    c.strokeStyle = 'rgb(0, 220, 220)';
    c.stroke();

} //drawing rsl path ends here 

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



if (lsr(csl, cgr, start, goal, r) !== 0) {
    var a = lsr(csl, cgr, start, goal, r)[0];
    var b = lsr(csl, cgr, start, goal, r)[1];
    var d = lsr(csl, cgr, start, goal, r)[2];
    var e = lsr(csl, cgr, start, goal, r)[3];
    var startAngle = Math.atan2(b - ((leftcircle(start, r))[1]), a - ((leftcircle(start, r))[0]));
    var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
    c.beginPath();
    c.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
    //c.arc((leftcircle(cst, r))[0], (leftcircle(cst, r))[1], r, 0, 2 * Math.PI, false);
    c.strokeStyle = 'rgb(20, 15, 22)';
    c.stroke();


    var endAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
    var startAngle = Math.atan2(e - ((rightcircle(goal, r))[1]), d - ((rightcircle(goal, r))[0]));
    c.beginPath();
    c.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, startAngle, endAngle, false);
    //c.arc((leftcircle(cet, r))[0], (leftcircle(cet, r))[1], r, 0, 2 * Math.PI, false);
    c.strokeStyle = 'rgb(20, 15, 22)';
    c.stroke();


    c.beginPath();
    c.moveTo(a, b);
    c.lineTo(d, e);
    c.strokeStyle = 'rgb(20, 15, 22)';
    c.stroke();

} //drawing for lsr path ends here 


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

//document.write("\nTangent points are " + lrl(csl, cgl, start, goal, r)[6]);
if (lrl(csl, cgl, start, goal, r) !== 0) {
    var a = lrl(csl, cgl, start, goal, r)[0];
    var b = lrl(csl, cgl, start, goal, r)[1];
    var d = lrl(csl, cgl, start, goal, r)[2];
    var e = lrl(csl, cgl, start, goal, r)[3];
    var f = lrl(csl, cgl, start, goal, r)[4];
    var g = lrl(csl, cgl, start, goal, r)[5];




    var startAngle = Math.atan2(Number(g) - ((leftcircle(goal, r))[1]), Number(f) - ((leftcircle(goal, r))[0]));
    var endAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
    c.beginPath();
    //c.arc((leftcircle(cet, r))[0], (leftcircle(cet, r))[1], r, 0, 2 * Math.PI, false);
    c.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, endAngle, startAngle, false);
    c.strokeStyle = 'rgb(220, 0, 0)';
    c.stroke();

    var startAngle = Math.atan2(Number(e) - ((leftcircle(start, r))[1]), Number(d) - ((leftcircle(start, r))[0]));
    var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
    c.beginPath();
    //c.arc((leftcircle(cst, r))[0], (leftcircle(cst, r))[1], r, 0, 2 * Math.PI, false);
    c.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
    c.strokeStyle = 'rgb(220, 0, 0)';
    c.stroke();

    var startAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
    var endAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
    c.beginPath();
    c.arc(Number(a), Number(b), r, startAngle, endAngle, false);
    c.strokeStyle = 'rgb(220, 0, 0)';
    c.stroke();

} //drawing for lrl path ends here

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

if (rlr(csr, cgr, start, goal, r) !== 0) {
    var a = rlr(csr, cgr, start, goal, r)[0];
    var b = rlr(csr, cgr, start, goal, r)[1];
    var d = rlr(csr, cgr, start, goal, r)[2];
    var e = rlr(csr, cgr, start, goal, r)[3];
    var f = rlr(csr, cgr, start, goal, r)[4];
    var g = rlr(csr, cgr, start, goal, r)[5];




    var endAngle = Math.atan2(Number(g) - ((rightcircle(goal, r))[1]), Number(f) - ((rightcircle(goal, r))[0]));
    var startAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
    c.beginPath();
    c.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, endAngle, startAngle, false);
    c.strokeStyle = 'rgb(0, 220, 0)';
    c.stroke();

    var endAngle = Math.atan2(Number(e) - ((rightcircle(start, r))[1]), Number(d) - ((rightcircle(start, r))[0]));
    var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
    c.beginPath();
    c.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
    c.strokeStyle = 'rgb(0, 220, 0)';
    c.stroke();

    var endAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
    var startAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
    c.beginPath();
    c.arc(Number(a), Number(b), r, startAngle, endAngle, false);
    c.strokeStyle = 'rgb(0, 220, 0)';
    c.stroke();

} //drawing for rlr ends here


//Find the shortest path
var arc_lsl = lsl(csl,cgl,start,goal,r)[4];
var arc_rsr = rsr(csr,cgr,start,goal,r)[4];
if(rsl(csr,cgl,start,goal,r)===0){
var arc_rsl = 4000;}
else{
var arc_rsl = rsl(csr,cgl,start,goal,r)[4];
}
if(lsr(csl,cgr,start,goal,r)===0){
var arc_rsl = 4000;}
else{
var arc_lsr = lsr(csl,cgr,start,goal,r)[4];
}
if (lrl(csl,cgl,start,goal,r)===0){
var arc_lrl = 4000;}
else{
var arc_lrl = lrl(csl,cgl,start,goal,r)[6];
}
if(rlr(csr,cgr,start,goal,r)===0){
var arc_rlr=4000;
}
else{
var arc_rlr = rlr(csr,cgr,start,goal,r)[6];
}
//var minimum = Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr);
//document.write("\nMinimum is " + arc_lsr);

if(arc_lsl == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)){
    document.write("\nShortest path is LSL");
}
else if (arc_rsr == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)){
    document.write("\nShortest path is RSR");
}
else if (arc_rsl == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)){
    document.write("\nShortest path is RSL");
}
else if (arc_lsr == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)) {
    document.write("\nShortest path is LSR");
}
else if (arc_lrl == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)){
    document.write("\nShortest path is LRL");
}
else if (arc_rlr == Math.min(arc_lsl,arc_rsr,arc_rsl,arc_lsr,arc_lrl,arc_rlr)){
    document.write("\nShortest path is RLR");
    
}

