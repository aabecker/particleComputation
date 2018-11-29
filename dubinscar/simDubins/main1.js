function init() {
    var world;
    var ctx;
    var canvas_width = 1120 * 2;
    var canvas_height = 630 * 2;
    var mouse_pressed = false;
    var mouse_joint = false;
    var mouse_x, mouse_y;
    var threshold_collision = 40; //threshold for detecting intersected polygons area

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
            var startx = ((r1.GetPosition().x) * scale).toFixed(2);
            var starty = ((r1.GetPosition().y) * scale).toFixed(2);
            var starta = (r1.GetAngle()).toFixed(2);
            ctx.fillText(startx, 50, 70);
            ctx.fillText(starty, 200, 70);
            ctx.fillText(starta, 350, 70);

            //ctx.fillText(c.GetAngle(), 350, 100);

            var goalx = ((r2.GetPosition().x) * scale).toFixed(2);
            var goaly = ((r2.GetPosition().y) * scale).toFixed(2);
            var goala = (r2.GetAngle()).toFixed(2);

            var start = [Number(startx), 1260 - Number(starty), Number(starta) + 1.5708];
            var goal = [Number(goalx), 1260 - Number(goaly), Number(goala) + 1.5708];
            var r = 180; //radius of curvature

            //measure the distance between goal and start. print assembled
            var distance = Math.sqrt(Math.pow((goal[1] - start[1]), 2) + Math.pow((goal[0] - start[0]), 2));
            if (distance < 10) {
                ctx.textAlign = 'left';
                //ctx.fillText(distance.toFixed(2), 50, 100);
                ctx.fillText('ASSEMBLED!', 50, 100);
            }

            var max_radius = 240;
            var noRadiusChange = false;
            while (r <= max_radius) {
                var path = 0;
                var csl = leftcircle(start, r);
                var cgl = leftcircle(goal, r);
                var csr = rightcircle(start, r);
                var cgr = rightcircle(goal, r);

                ctx.beginPath();  //green end point
                ctx.arc(goal[0], goal[1], 8, 0, Math.PI * 2, false);
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
                //TODO: access the vertices and then draw the polygon

                //draw arrow at goal
                var xcoord = goal[0];
                var ycoord = goal[1];
                var lineangle = -(goal[2] + 1.5708);
                DrawArrow(xcoord, ycoord, lineangle, ctx, "green");

                //draw the mirrored rod on canvas
                var lineangle = -goal[2];
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

                /*ctx.beginPath();
                ctx.moveTo(0,0);
                ctx.lineTo(2240,0);
                ctx.lineTo(2240,10);
                ctx.lineTo(0,10);
                ctx.lineTo(0,0);
                ctx.strokeStyle = 'rgb(20, 20, 20)';
                ctx.stroke();*/

                //save the mirrored rod points
                var mirrored_rod = mirroredRodPoints(xcoord, ycoord, lineangle);
                //draw the left and right circles at the start and goal
                LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(goal, r))[0], (leftcircle(goal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(goal, r))[0], (rightcircle(goal, r))[1], ctx, r);

                //begin drawing shortest path
                var arc_lsl = lsl(csl, cgl, start, goal, r)[4];
                var arc_rsr = rsr(csr, cgr, start, goal, r)[4];
                if (rsl(csr, cgl, start, goal, r) === 0) {
                    var arc_rsl = 40000;
                }
                else {
                    var arc_rsl = rsl(csr, cgl, start, goal, r)[4];
                }
                if (lsr(csl, cgr, start, goal, r) === 0) {
                    var arc_lsr = 40000;
                }
                else {
                    var arc_lsr = lsr(csl, cgr, start, goal, r)[4];
                }

                ctx.textAlign = 'center';
                ctx.fillStyle = 'rgb(220, 0, 220)';
                ctx.fillText("LSL = " + arc_lsl, canvas_width / 2 - 300, 100);
                ctx.fillStyle = 'rgb(220, 220, 0)';
                ctx.fillText("RSR = " + arc_rsr, canvas_width / 2 - 160, 100);
                ctx.fillStyle = 'rgb(0, 220, 220)';
                ctx.fillText("RSL = " + arc_rsl, canvas_width / 2 - 20, 100);
                ctx.fillStyle = 'rgb(20, 15, 22)';
                ctx.fillText("LSR = " + arc_lsr, canvas_width / 2 + 120, 100);
                ctx.fillStyle = 'rgb(20, 15, 22)';
                ctx.fillText("Radius = " + r, canvas_width / 2 + 300, 100);

                //sort the paths
                var sorted_paths = [
                    { path: 'LSL', value: arc_lsl },
                    { path: 'RSR', value: arc_rsr },
                    { path: 'RSL', value: arc_rsl },
                    { path: 'LSR', value: arc_lsr }
                ];

                var sorted_paths1 = sorted_paths.sort(function (a, b) {
                    return a.value - b.value;
                });

                //var path = 0;
                //var max_radius = 240;
                //var noRadiusChange = false;
                //while (r <= max_radius) {
                //for (var path = 0; path < sorted_paths1.length; path++) {
                while (path < sorted_paths1.length) {
                    if (sorted_paths1[path]["path"] === 'LSL') {
                        var lslpath = lsl(csl, cgl, start, goal, r);
                        var a = lslpath[0];  //start circle tangent x 
                        var b = lslpath[1];  //start circle tangent y
                        var d = lslpath[2];  //goal circle tangent x
                        var e = lslpath[3];   //goal circle tangent y
                        var straight = lslpath[5];

                        var intersect = detectIntersectionLSL(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod);
                        //console.log(intersect);
                        if (intersect === 0) {
                            LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(goal, r))[0], (leftcircle(goal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(goal, r))[0], (rightcircle(goal, r))[1], ctx, r);
                            drawLSL(a, b, d, e, straight, start, goal, r, ctx);
                            noRadiusChange = true;
                            break;
                            //path = sorted_paths1.length;
                        }

                    }
                    else if (sorted_paths1[path]["path"] === 'RSR') {
                        var rsrpath = rsr(csr, cgr, start, goal, r);
                        var a = rsrpath[0];
                        var b = rsrpath[1];
                        var d = rsrpath[2];
                        var e = rsrpath[3];
                        var straight = rsrpath[5];
                        var intersect = detectIntersectionRSR(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod);
                        //console.log(intersect);
                        if (intersect === 0) {
                            LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(goal, r))[0], (leftcircle(goal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(goal, r))[0], (rightcircle(goal, r))[1], ctx, r);
                            drawRSR(a, b, d, e, straight, start, goal, r, ctx);
                            noRadiusChange = true;
                            break;
                            //path = sorted_paths1.length;
                        }
                    }
                    else if (sorted_paths1[path]["path"] === 'RSL' && sorted_paths1[path]["value"] !== 40000) {
                        var rslpath = rsl(csr, cgl, start, goal, r);
                        var a = rslpath[0];  //start circle tangent x 
                        var b = rslpath[1];  //start circle tangent y
                        var d = rslpath[2];  //goal circle tangent x
                        var e = rslpath[3];   //goal circle tangent y
                        var straight = rslpath[5];
                        var intersect = detectIntersectionRSL(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod);
                        //console.log(intersect);
                        if (intersect === 0) {
                            LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(goal, r))[0], (leftcircle(goal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(goal, r))[0], (rightcircle(goal, r))[1], ctx, r);
                            drawRSL(a, b, d, e, straight, start, goal, r, ctx);
                            noRadiusChange = true;
                            break;
                            //path = sorted_paths1.length;
                        }
                    }

                    else if (sorted_paths1[path]["path"] === 'LSR' && sorted_paths1[path]["value"] !== 40000) {
                        var lsrpath = lsr(csl, cgr, start, goal, r);
                        var a = lsrpath[0];  //start circle tangent x 
                        var b = lsrpath[1];  //start circle tangent y
                        var d = lsrpath[2];  //goal circle tangent x
                        var e = lsrpath[3];   //goal circle tangent y
                        var straight = lsrpath[5];
                        var intersect = detectIntersectionLSR(a, b, d, e, threshold_collision, straight, start, goal, r, mirrored_rod);
                        if (intersect === 0) {
                            LeftRightCircles((leftcircle(start, r))[0], (leftcircle(start, r))[1], (leftcircle(goal, r))[0], (leftcircle(goal, r))[1], (rightcircle(start, r))[0], (rightcircle(start, r))[1], (rightcircle(goal, r))[0], (rightcircle(goal, r))[1], ctx, r);
                            drawLSR(a, b, d, e, straight, start, goal, r, ctx);
                            noRadiusChange = true;
                            break;
                            //path = sorted_paths1.length;
                        }
                    }
                    path = path + 1;
                }
                if (noRadiusChange === true) {
                    break;
                }
                else {
                    r = r + 10;
                    console.log(r);
                }
            }
        }

    }



    //Convert coordinates in canvas to box2d world
    function get_real(p) {
        return new b2Vec2(p.x + 0, canvas_height_m - p.y);
    }

    function GetBodyAtMouse(includeStatic) {
        var mouse_p = new b2Vec2(mouse_x, mouse_y);

        var aabb = new b2AABB();
        aabb.lowerBound.Set(mouse_x - 0.001, mouse_y - 0.001);
        aabb.upperBound.Set(mouse_x + 0.001, mouse_y + 0.001);

        var body = null;

        // Query the world for overlapping shapes.
        function GetBodyCallback(fixture) {
            var shape = fixture.GetShape();

            if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic) {
                var inside = shape.TestPoint(fixture.GetBody().GetTransform(), mouse_p);

                if (inside) {
                    body = fixture.GetBody();
                    return false;
                }
            }

            return true;
        }

        world.QueryAABB(GetBodyCallback, aabb);
        return body;
    }

    // main entry point
    $(function () {
        //first create the world
        world = createWorld();

        var canvas = $('#canvas');
        ctx = canvas.get(0).getContext('2d');

        //get internal dimensions of the canvas
        canvas_width = parseInt(canvas.attr('width'));
        canvas_height = parseInt(canvas.attr('height'));
        canvas_height_m = canvas_height / scale;

        //If mouse is moving over the thing
        $(canvas).mousemove(function (e) {
            var p = get_real(new b2Vec2(e.pageX / scale, e.pageY / scale))

            mouse_x = p.x;
            mouse_y = p.y;

            if (mouse_pressed && !mouse_joint) {
                var body = GetBodyAtMouse();

                if (body) {
                    //if joint exists then create
                    var def = new b2MouseJointDef();

                    def.bodyA = ground;
                    def.bodyB = body;
                    def.target = p;

                    def.collideConnected = true;
                    def.maxForce = 1000 * body.GetMass();
                    def.dampingRatio = 0;

                    mouse_joint = world.CreateJoint(def);

                    body.SetAwake(true);
                }
            }
            else {
                //nothing
            }

            if (mouse_joint) {
                mouse_joint.SetTarget(p);
            }
        });

        $(canvas).mousedown(function () {
            //flag to indicate if mouse is pressed or not
            mouse_pressed = true;
        });

        /*
            When mouse button is release, mark pressed as false and delete the mouse joint if it exists
        */
        $(canvas).mouseup(function () {
            mouse_pressed = false;

            if (mouse_joint) {
                world.DestroyJoint(mouse_joint);
                mouse_joint = false;
            }
        });

        //start stepping
        step(world, ctx);
    });

};