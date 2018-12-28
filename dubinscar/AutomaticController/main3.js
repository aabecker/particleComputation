function init() {
    var world;
    var ctx;
    var canvas_width = 1120 * 2;
    var canvas_height = 630 * 2;


    //box2d to canvas scale , therefore 1 metre of box2d = 30px of canvas
    var scale = 30;

    /*
        This method will draw the world again and again
        called by settimeout , self looped
    */
    function step() {
        var fps = 60;
        var timeStep = 1.0 / (fps * 0.8);

        //move the box2d world ahead
        world.Step(timeStep, 8, 3);
        world.ClearForces();

        //call this function again after 1/60 seconds or 16.7ms
        setTimeout(step, 1000 / fps);

        //redraw the world
        ctx.save();
        ctx.translate(0, canvas_height);
        ctx.scale(1, -1);
        world.DrawDebugData();
        ctx.restore();

        ctx.font = 'bold 18px arial';
        ctx.textAlign = 'center';
        ctx.fillStyle = '#555';
        ctx.fillText('Box2d MouseJoint example with Dubins paths', canvas_width / 2, 40);
        //ctx.fillText('LSL is pink, RSR is yellow, RSL is light blue, LSR is black, LRL is red, RLR is green ', canvas_width / 2, 70);
        ctx.fillText('Starting point is red and goal point is green', canvas_width / 2, 70);
        ctx.textAlign = 'left';
        ctx.fillText('X Coordinate', 50, 40);
        ctx.fillText('Y Coordinate', 200, 40);
        ctx.fillText('Angle', 350, 40);

        var r1; //rod1
        var r2; //rod2
        for (b = world.GetBodyList(); b; b = b.GetNext()) {
            if (b.GetUserData() == 'rod2') {
                r2 = b;
            }
            if (b.GetUserData() == 'rod1') {
                r1 = b;
            }
        }
        if (r1.GetUserData() == 'rod1' && r2.GetUserData() == 'rod2') {

            //first draw the fixed lsl path
            var FixedStart_x = 20 * scale;
            var FixedStart_y = 18 * scale;
            var FixedStart_o = 3.142 + 1.57;

            var FixedGoal_x = 40 * scale;
            var FixedGoal_y = 24 * scale;
            var FixedGoal_o = 3.50 + 1.57;
            var r = 180; //radius of curvature
            var fixedstart = [FixedStart_x, 1260 - FixedStart_y, FixedStart_o];
            var fixedgoal = [FixedGoal_x, 1260 - FixedGoal_y, FixedGoal_o];

            var csl = leftcircle(fixedstart, r);
            var cgl = leftcircle(fixedgoal, r);
            var arc_lsl = lsl(csl, cgl, fixedstart, fixedgoal, r)[4];

            ctx.textAlign = 'center';
            ctx.fillStyle = 'rgb(220, 0, 220)';
            ctx.fillText("LSL = " + arc_lsl, canvas_width / 2 - 300, 100);
            var lslpath = lsl(csl, cgl, fixedstart, fixedgoal, r);
            var a = lslpath[0];  //start circle tangent x 
            var b = lslpath[1];  //start circle tangent y
            var d = lslpath[2];  //goal circle tangent x
            var e = lslpath[3];   //goal circle tangent y
            var straight = lslpath[5];
            drawLSL(a, b, d, e, straight, fixedstart, fixedgoal, r, ctx);

            //x, y and orientation of the moving rod
            var startx = ((r1.GetPosition().x) * scale).toFixed(2);
            var starty = ((r1.GetPosition().y) * scale).toFixed(2);
            var starta = (r1.GetAngle()).toFixed(2);
            ctx.fillText(startx, 80, 70);
            ctx.fillText(starty, 230, 70);
            ctx.fillText(starta, 380, 70);

            var start = [Number(startx), 1260 - Number(starty), Number(starta) + 1.5708];

            var csl = leftcircle(start, r);
            var cgl = leftcircle(fixedgoal, r);

            //points on the LSL path
            //var points = pathpoints(start,fixedgoal,r,a,b,d,e,straight);
            //console.log(points);

            //measure error of the point from the points on the path
            //var error = (start[0] - point.x)^2 + (start[1] - point.y)^2 + K * arctan(cos(point.angle) - cos(start.angle),sin(point.angle) - sin(start.angle));

            ctx.beginPath();  //green end point
            ctx.arc(fixedgoal[0], fixedgoal[1], 8, 0, Math.PI * 2, false);
            ctx.fillStyle = 'rgb(0, 200, 10)';
            ctx.fill();

            ctx.beginPath();  //red start point
            ctx.arc(start[0], start[1], 8, 0, Math.PI * 2, false);
            ctx.fillStyle = 'rgb(200, 10, 10)';
            ctx.fill();

            //draw arrow at start
            var xcoord = start[0];
            var ycoord = start[1];
            var lineangle = -(start[2] + 1.5708);
            DrawArrow(xcoord, ycoord, lineangle, ctx, "red");

            //draw the rod with notch on canvas
            var lineangle = -start[2];
            ctx.beginPath();
            ctx.moveTo(xcoord, ycoord);
            ctx.lineTo(xcoord + 35.16 * Math.cos(lineangle + 1.081), ycoord + 35.16 * Math.sin(lineangle + 1.081));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + 1.5708), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + 1.5708));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + 1.5708) + 240 * Math.cos(lineangle + 3.142), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + 1.5708) + 240 * Math.sin(lineangle + 3.142));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + 1.5708) + 240 * Math.cos(lineangle + 3.142) + 30 * Math.cos(lineangle + 4.712), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + 1.5708) + 240 * Math.sin(lineangle + 3.142) + 30 * Math.sin(lineangle + 4.712));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + 1.5708) + 240 * Math.cos(lineangle + 3.142) + 30 * Math.cos(lineangle + 4.712) + 102 * Math.cos(lineangle + 6.283), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + 1.5708) + 240 * Math.sin(lineangle + 3.142) + 30 * Math.sin(lineangle + 4.712) + 102 * Math.sin(lineangle + 6.283));
            ctx.lineTo((xcoord + 35.16 * Math.cos(lineangle + 1.081)) + 102 * Math.cos(lineangle + 0) + 30 * Math.cos(lineangle + 1.5708) + 240 * Math.cos(lineangle + 3.142) + 30 * Math.cos(lineangle + 4.712) + 102 * Math.cos(lineangle + 6.283) + 35.16 * Math.cos(lineangle + 5.202), (ycoord + 35.16 * Math.sin(lineangle + 1.081)) + 102 * Math.sin(lineangle + 0) + 30 * Math.sin(lineangle + 1.5708) + 240 * Math.sin(lineangle + 3.142) + 30 * Math.sin(lineangle + 4.712) + 102 * Math.sin(lineangle + 6.283) + 35.16 * Math.sin(lineangle + 5.202));
            ctx.fillStyle = 'rgb(220, 0, 0)';
            ctx.fill();

            //draw arrow at goal
            var xcoord = fixedgoal[0];
            var ycoord = fixedgoal[1];
            var lineangle = -(fixedgoal[2] + 1.5708);
            DrawArrow(xcoord, ycoord, lineangle, ctx, "green");

            //draw the mirrored rod on canvas
            var lineangle = -fixedgoal[2];
            ctx.beginPath();
            ctx.moveTo(xcoord, ycoord);
            ctx.lineTo(xcoord + 37.5 * Math.cos(lineangle + 0.927), ycoord + 37.5 * Math.sin(lineangle + 0.927));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708) + 97.5 * Math.cos(lineangle + 6.283), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708) + 97.5 * Math.sin(lineangle + 6.283));
            ctx.lineTo((xcoord + 37.5 * Math.cos(lineangle + 0.927)) + 97.5 * Math.cos(lineangle + 0) + 60 * Math.cos(lineangle + 4.712) + 240 * Math.cos(lineangle + 3.142) + 60 * Math.cos(lineangle + 1.5708) + 97.5 * Math.cos(lineangle + 6.283) + 37.5 * Math.cos(lineangle + 5.355), (ycoord + 37.5 * Math.sin(lineangle + 0.927)) + 97.5 * Math.sin(lineangle + 0) + 60 * Math.sin(lineangle + 4.712) + 240 * Math.sin(lineangle + 3.142) + 60 * Math.sin(lineangle + 1.5708) + 97.5 * Math.sin(lineangle + 6.283) + 37.5 * Math.sin(lineangle + 5.355));
            ctx.fillStyle = 'rgb(0, 220, 0)';
            ctx.fill();

            //draw the left and right circles at the start and goal
            LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(fixedgoal, r))[0], (leftcircle(fixedgoal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(fixedgoal, r))[0], (rightcircle(fixedgoal, r))[1], ctx, r);

            //mean and variance of the robots
             var sum_position_x = 0;
             var sum_position_y = 0;
             var sum2_x = 0;
             var sum2_y = 0;
             var numrobots = 144;
             var cov_xy = 0;
 
             for (var i = 0; i < numrobots; ++i) {
                 sum_position_x += m_Robot[i].GetPosition().x;
                 sum_position_y += m_Robot[i].GetPosition().y;
             }
             var mean_position_x = sum_position_x / numrobots;
             var mean_position_y = sum_position_y / numrobots;
             for (var i = 0; i < numrobots; ++i) {
                 sum2_x += (m_Robot[i].GetPosition().x - mean_position_x) * (m_Robot[i].GetPosition().x - mean_position_x);
                 sum2_y += (m_Robot[i].GetPosition().y - mean_position_y) * (m_Robot[i].GetPosition().y - mean_position_y);
                 cov_xy = cov_xy + (m_Robot[i].GetPosition().x - mean_position_x) * (m_Robot[i].GetPosition().y - mean_position_y) / numrobots;
             }
             var var_x = sum2_x / numrobots;
             var var_y = sum2_y / numrobots;
             var diffeq = Math.sqrt((var_x - var_y) * (var_x - var_y) / 4 + cov_xy * cov_xy);
             var var_xp = (var_x + var_y) / 2 + diffeq;
             var var_yp = (var_x + var_y) / 2 - diffeq;
 
             //draw ellipse around robots
             ctx.beginPath();
             ctx.ellipse(mean_position_x * scale, 1260 - (mean_position_y * scale), var_xp * scale, var_yp * scale, 0, 0, 2 * Math.PI);
             ctx.strokeStyle = 'rgb(0, 0, 220)';
             ctx.stroke();
 
             //draw circle at mean position
             ctx.beginPath();
             ctx.arc(mean_position_x * scale, 1260 - (mean_position_y * scale), 8, 0, Math.PI * 2, false);
             ctx.fillStyle = 'rgb(0, 0, 220)';
             ctx.fill();
 
 


        }

    }



    // main function
    $(function () {
        //first create the world
        world = createWorld();

        var canvas = $('#canvas');
        ctx = canvas.get(0).getContext('2d');
        // start stepping
        step(world, ctx);
    });

};