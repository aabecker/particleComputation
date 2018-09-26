function init() {
    var b2Vec2 = Box2D.Common.Math.b2Vec2
        , b2AABB = Box2D.Collision.b2AABB
        , b2BodyDef = Box2D.Dynamics.b2BodyDef
        , b2Body = Box2D.Dynamics.b2Body
        , b2FixtureDef = Box2D.Dynamics.b2FixtureDef
        , b2Fixture = Box2D.Dynamics.b2Fixture
        , b2World = Box2D.Dynamics.b2World
        , b2MassData = Box2D.Collision.Shapes.b2MassData
        , b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
        , b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
        , b2DebugDraw = Box2D.Dynamics.b2DebugDraw
        , b2MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef
        , b2Shape = Box2D.Collision.Shapes.b2Shape
        , b2Joint = Box2D.Dynamics.Joints.b2Joint
        , b2Settings = Box2D.Common.b2Settings
        ;

    var world;
    var ctx;
    var canvas_width = 1120 * 2;
    var canvas_height = 630 * 2;
    var mouse_pressed = false;
    var mouse_joint = false;
    var mouse_x, mouse_y;

    //box2d to canvas scale , therefore 1 metre of box2d = 30px of canvas :)
    var scale = 30;


    //Create box2d world object
    function createWorld() {
        //Gravity vector x, y - 10 m/s2 - thats earth!!
        //var gravity = new b2Vec2(0, -10);
        var gravity = new b2Vec2(0, 00);

        world = new b2World(gravity, true);

        //setup debug draw
        var debugDraw = new b2DebugDraw();
        debugDraw.SetSprite(document.getElementById("canvas").getContext("2d"));
        debugDraw.SetDrawScale(scale);
        debugDraw.SetFillAlpha(0.5);
        debugDraw.SetLineThickness(1.0);
        debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);

        world.SetDebugDraw(debugDraw);

        //create some objects

        //create the enclosing boundary
        var fixDef = new b2FixtureDef;
        fixDef.density = 1.0;
        fixDef.friction = 1000;
        fixDef.restitution = 0.1;  //bouncing value
        var bodyDef = new b2BodyDef;
        bodyDef.userData = 'obstacle';  // canvas is {1120, 630}
        bodyDef.type = b2Body.b2_staticBody;
        fixDef.shape = new b2PolygonShape;
        fixDef.shape.SetAsBox(canvas_width / scale, 2);//width, height
        bodyDef.position.Set(10, canvas_height / scale + 1.8); //bottom
        ground = world.CreateBody(bodyDef);
        ground.m_angularDamping = 8.0;
        ground.CreateFixture(fixDef);
        bodyDef.position.Set(2, -1.8); //top
        world.CreateBody(bodyDef).CreateFixture(fixDef);
        fixDef.shape.SetAsBox(2, canvas_height / scale);//width, height
        bodyDef.position.Set(-1.8, 13); //left
        world.CreateBody(bodyDef).CreateFixture(fixDef);
        bodyDef.position.Set(canvas_width / scale + 1.8, 13); // right side
        world.CreateBody(bodyDef).CreateFixture(fixDef);

        //Creating the box
        /* bodyDef.type = b2Body.b2_dynamicBody;
         fixDef.density = 1000.0;
         fixDef.friction = 1000.0;
         fixDef.restitution = 0.2;  //bouncing value
         bodyDef.position.Set(30, 30);
         bodyDef.userData = 'moveable';
         bodyDef.angle = 0 * Math.PI / 180;
         fixDef.shape = new b2PolygonShape;
         //fixDef.shape.b2PolygonShape(6.0);
         fixDef.shape.SetAsBox(0.5, 4);
         var obst = world.CreateBody(bodyDef);
         obst.CreateFixture(fixDef);
         obst.m_angularDamping = 8000.0;
         obst.m_linearDamping = 8000.0;*/

        //long rod with a notch
        bodyDef.type = b2Body.b2_dynamicBody;
        bodyDef.position.Set(30, 30);
        bodyDef.userData = 'rod1';
        //bodyDef.angle = 1.67;
        fixDef.density = 1000.0;
        fixDef.friction = 1000.0;
        fixDef.restitution = 0.2;
        var body = world.CreateBody(bodyDef);
        var polys = [
            [{ x: -0.5, y: -0.5 }, { x: 0.5, y: -0.5 }, { x: 0.5, y: 0.5 }, { x: -0.5, y: 0.5 }], // box
            [{ x: 0.5, y: -4.0 }, { x: 1.5, y: -4.0 }, { x: 1.5, y: 4.0 }, { x: 0.5, y: 4.0 }]
        ]

        for (var j = 0; j < polys.length; j++) {
            var points = polys[j];
            var vecs = [];
            for (var i = 0; i < points.length; i++) {
                var vec = new b2Vec2();
                vec.Set(points[i].x, points[i].y);
                vecs[i] = vec;
            }
            fixDef.shape = new b2PolygonShape;
            fixDef.shape.SetAsArray(vecs, vecs.length);
            body.CreateFixture(fixDef);
            body.m_angularDamping = 8000.0;
            body.m_linearDamping = 8000.0;
        }

        //mirrored rod
        bodyDef.type = b2Body.b2_dynamicBody;
        bodyDef.position.Set(20, 25);
        bodyDef.userData = 'rod2';
        fixDef.density = 1000.0;
        fixDef.friction = 1000.0;
        fixDef.restitution = 0.2;
        var body = world.CreateBody(bodyDef);
        var polys = [
            [{ x: 0.5, y: -4.0 }, { x: 1.5, y: -4.0 }, { x: 1.5, y: 4.0 }, { x: 0.5, y: 4.0 }],
            [{ x: 1.5, y: -4.0 }, { x: 2.5, y: -4.0 }, { x: 2.5, y: -0.5 }, { x: 1.5, y: -0.5 }],
            [{ x: 1.5, y: 4.0 }, { x: 2.5, y: 4.0 }, { x: 2.5, y: 0.5 }, { x: 1.5, y: 0.5 }]
        ]

        for (var j = 0; j < polys.length; j++) {
            var points = polys[j];
            var vecs = [];
            for (var i = 0; i < points.length; i++) {
                var vec = new b2Vec2();
                vec.Set(points[i].x, points[i].y);
                vecs[i] = vec;
            }
            fixDef.shape = new b2PolygonShape;
            fixDef.shape.SetAsArray(vecs, vecs.length);
            body.CreateFixture(fixDef);
            body.m_angularDamping = 8000.0;
            body.m_linearDamping = 8000.0;
        }



        return world;
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

        var arc1 = arclength(csl, start, [xT1, yT1], -1, r);
        var straight = Math.sqrt(Math.pow((yT2 - yT1), 2) + Math.pow((xT2 - xT1), 2));
        var arc2 = arclength(cgl, [xT2, yT2], goal, -1, r);
        var total_length = arc1 + straight + arc2;
        //var total_length = straight;
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
        //var total_length = straight;

        var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
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

            var tangents = [xT1.toFixed(2), yT1.toFixed(2), xT2.toFixed(2), yT2.toFixed(2), total_length.toFixed(2)]; // x,y of tangents
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

            var arc1 = arclength(csl, start, [(x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2], -1, r);
            var arc2 = arclength([x, y], [(x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2], [(x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2], 1, r);
            var arc3 = arclength(cgl, [(x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2], goal, -1, r);
            var total_length = arc1 + arc2 + arc3;
            return [Number(x.toFixed(2)), y.toFixed(2), (x + Number(csl[0])) / 2, (y + Number(csl[1])) / 2, (x + Number(cgl[0])) / 2, (y + Number(cgl[1])) / 2, total_length.toFixed(2)];
        }
        else {
            return 0;
        }
    }

    //Function for rlr path
    function rlr(csr, cgr, start, goal, r) {
        var D = Math.sqrt(Math.pow((cgr[1] - csr[1]), 2) + Math.pow((cgr[0] - csr[0]), 2));
        if (D < 4 * r) {
            //var theta = Math.acos(D / (4 * r));
            var theta = Math.atan2(cgr[1] - csr[1], cgr[0] - csr[0]) - Math.acos(D / (4 * r)); //theta is combination of two things
            var x = Number(csr[0]) + 2 * r * Math.cos(theta);
            var y = Number(csr[1]) + 2 * r * Math.sin(theta);

            var arc1 = arclength(csr, start, [(x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2], 1, r);
            var arc2 = arclength([x, y], [(x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2], [(x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2], -1, r);
            var arc3 = arclength(cgr, [(x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2], goal, 1, r);
            var total_length = arc1 + arc2 + arc3;
            // return theta;
            return [Number(x.toFixed(2)), y.toFixed(2), (x + Number(csr[0])) / 2, (y + Number(csr[1])) / 2, (x + Number(cgr[0])) / 2, (y + Number(cgr[1])) / 2, total_length.toFixed(2)];
        }
        else {
            return 0;
        }
    }



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
        ctx.fillText('LSL is pink, RSR is yellow, RSL is light blue, LSR is black, LRL is red, RLR is green ', canvas_width / 2, 70);
        ctx.fillText('Starting point is red and goal point is green', canvas_width / 2, 100);
        ctx.textAlign = 'left';
        ctx.fillText('X Coordinate', 50, 40);
        ctx.fillText('Y Coordinate', 200, 40);
        ctx.fillText('Angle', 350, 40);

        //var startx, starty, starta;
        //var goalx, goaly, goala;

        for (var b = world.GetBodyList(); b; b = b.GetNext()) {
            for (var c = world.GetBodyList(); c; c = c.GetNext()) {
                if (b.GetUserData() == 'rod1' && c.GetUserData() == 'rod2') {
                    var startx = ((b.GetPosition().x) * scale).toFixed(2);
                    var starty = ((b.GetPosition().y) * scale).toFixed(2);
                    var starta = (b.GetAngle()).toFixed(2);
                    ctx.fillText(startx, 50, 70);
                    ctx.fillText(starty, 200, 70);
                    ctx.fillText(starta, 350, 70);

                    var goalx = ((c.GetPosition().x) * scale).toFixed(2);
                    var goaly = ((c.GetPosition().y) * scale).toFixed(2);
                    var goala = (c.GetAngle()).toFixed(2);

                    //var goal = [300, 410, 1.7]; //starting point: x,y,angle
                    var start0 = Number(startx);
                    var start1 = 1260 - Number(starty);
                    var start2 = Number(starta) + 1.5708;
                    //var start00 = ((start0-15)-start0)*Math.cos(start2)+start0;
                    //var start11 = ((start0-15)-start0)*Math.sin(start2)+start1;
                    var start = [start0, start1, start2];
                    var goal = [Number(goalx), 1260 - Number(goaly), Number(goala) + 1.5708];
                    var r = 80; //radius of curvature

                    //measure the distance between goal and start. print assembled
                    var distance = Math.sqrt(Math.pow((goal[1] - start[1]), 2) + Math.pow((goal[0] - start[0]), 2));
                    //var distance = 5+3;
                    if (distance < 70) {
                        ctx.textAlign = 'left';
                        //ctx.fillText(distance.toFixed(2), 50, 100);
                        ctx.fillText('ASSEMBLED!', 50, 100);
                    }

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
                    var length = 50;
                    var lineangle = -(start[2] + 1.5708);
                    ctx.beginPath();
                    ctx.moveTo(xcoord, ycoord);
                    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
                    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle + 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle + 2.356));
                    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
                    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle - 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle - 2.356));
                    ctx.strokeStyle = 'rgb(220, 0, 0)';
                    ctx.stroke();

                    //draw arrow at goal
                    var xcoord = goal[0];
                    var ycoord = goal[1];
                    var length = 50;
                    var lineangle = -(goal[2] + 1.5708);
                    ctx.beginPath();
                    ctx.moveTo(xcoord, ycoord);
                    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
                    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle + 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle + 2.356));
                    ctx.lineTo(xcoord + length * Math.cos(lineangle), ycoord + length * Math.sin(lineangle));
                    ctx.lineTo((xcoord + length * Math.cos(lineangle)) + 20 * Math.cos(lineangle - 2.356), (ycoord + length * Math.sin(lineangle)) + 20 * Math.sin(lineangle - 2.356));
                    ctx.strokeStyle = 'rgb(0, 220, 0)';
                    ctx.stroke();


                    //draw the left and right circles at the start and goal
                    ctx.beginPath();
                    ctx.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, 0, 2 * Math.PI, false);
                    ctx.strokeStyle = 'rgb(0, 0, 220)';
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, 0, 2 * Math.PI, false);
                    ctx.strokeStyle = 'rgb(0, 0, 220)';
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, 0, 2 * Math.PI, false);
                    ctx.strokeStyle = 'rgb(0, 0, 220)';
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, 0, 2 * Math.PI, false);
                    ctx.strokeStyle = 'rgb(0, 0, 220)';
                    ctx.stroke();

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
                    if (lrl(csl, cgl, start, goal, r) === 0) {
                        var arc_lrl = 40000;
                    }
                    else {
                        var arc_lrl = lrl(csl, cgl, start, goal, r)[6];
                    }
                    if (rlr(csr, cgr, start, goal, r) === 0) {
                        var arc_rlr = 40000;
                    }
                    else {
                        var arc_rlr = rlr(csr, cgr, start, goal, r)[6];
                    }

                    ctx.textAlign = 'center';
                    ctx.fillText("LSL, RSR, RSL, LSR, LRL, RLR", canvas_width / 2, 130);
                    ctx.fillText(arc_lsl + " , " + arc_rsr + " , " + arc_rsl + " , " + arc_lsr + " , " + arc_lrl + " , " + arc_rlr, canvas_width / 2, 160);

                    if (arc_lsl == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        //document.write("\nTangent points are " + lsl(csl, cgl, start, goal, r));


                        var a = lsl(csl, cgl, start, goal, r)[0];
                        var b = lsl(csl, cgl, start, goal, r)[1];
                        var d = lsl(csl, cgl, start, goal, r)[2];
                        var e = lsl(csl, cgl, start, goal, r)[3];


                        var startAngle = Math.atan2(b - ((leftcircle(start, r))[1]), a - ((leftcircle(start, r))[0]));
                        var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
                        ctx.beginPath();
                        ctx.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
                        ctx.strokeStyle = 'rgb(220, 0, 220)';
                        ctx.stroke();


                        var startAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
                        var endAngle = Math.atan2(e - ((leftcircle(goal, r))[1]), d - ((leftcircle(goal, r))[0]));
                        ctx.beginPath();
                        ctx.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, startAngle, endAngle, false);
                        ctx.strokeStyle = 'rgb(220, 0, 220)';
                        ctx.stroke();


                        ctx.beginPath();
                        ctx.moveTo(a, b);
                        ctx.lineTo(d, e);
                        ctx.strokeStyle = 'rgb(220, 0, 220)';
                        ctx.stroke(); //Drawing lsl path ends here 
                    }
                    else if (arc_rsr == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        //document.write("\nTangent points are " + rsr(csr, cgr, start, goal, r));
                        var a = rsr(csr, cgr, start, goal, r)[0];
                        var b = rsr(csr, cgr, start, goal, r)[1];
                        var d = rsr(csr, cgr, start, goal, r)[2];
                        var e = rsr(csr, cgr, start, goal, r)[3];


                        var endAngle = Math.atan2(Number(b) - ((rightcircle(start, r))[1]), Number(a) - ((rightcircle(start, r))[0]));
                        var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
                        ctx.beginPath();
                        ctx.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
                        ctx.strokeStyle = 'rgb(220, 220, 0)';
                        ctx.stroke();


                        var endAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
                        var startAngle = Math.atan2(e - ((rightcircle(goal, r))[1]), d - ((rightcircle(goal, r))[0]));
                        ctx.beginPath();
                        ctx.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, startAngle, endAngle, false);
                        ctx.strokeStyle = 'rgb(220, 220, 0)';
                        ctx.stroke();


                        ctx.beginPath();
                        ctx.moveTo(a, b);
                        ctx.lineTo(d, e);
                        ctx.strokeStyle = 'rgb(220, 220, 0)';
                        ctx.stroke(); //drawing rsr path ends here 


                    }
                    else if (arc_rsl == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        if (rsl(csr, cgl, start, goal, r) !== 0) {
                            var a = rsl(csr, cgl, start, goal, r)[0];
                            var b = rsl(csr, cgl, start, goal, r)[1];
                            var d = rsl(csr, cgl, start, goal, r)[2];
                            var e = rsl(csr, cgl, start, goal, r)[3];
                            var endAngle = Math.atan2(b - ((rightcircle(start, r))[1]), a - ((rightcircle(start, r))[0]));
                            var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
                            ctx.beginPath();
                            ctx.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(0, 220, 220)';
                            ctx.stroke();


                            var startAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
                            var endAngle = Math.atan2(e - ((leftcircle(goal, r))[1]), d - ((leftcircle(goal, r))[0]));
                            ctx.beginPath();
                            ctx.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(0, 220, 220)';
                            ctx.stroke();


                            ctx.beginPath();
                            ctx.moveTo(a, b);
                            ctx.lineTo(d, e);
                            ctx.strokeStyle = 'rgb(0, 220, 220)';
                            ctx.stroke();

                        } //drawing rsl path ends here 
                    }
                    else if (arc_lsr == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        if (lsr(csl, cgr, start, goal, r) !== 0) {
                            var a = lsr(csl, cgr, start, goal, r)[0];
                            var b = lsr(csl, cgr, start, goal, r)[1];
                            var d = lsr(csl, cgr, start, goal, r)[2];
                            var e = lsr(csl, cgr, start, goal, r)[3];
                            var startAngle = Math.atan2(b - ((leftcircle(start, r))[1]), a - ((leftcircle(start, r))[0]));
                            var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
                            ctx.beginPath();
                            ctx.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(20, 15, 22)';
                            ctx.stroke();


                            var endAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
                            var startAngle = Math.atan2(e - ((rightcircle(goal, r))[1]), d - ((rightcircle(goal, r))[0]));
                            ctx.beginPath();
                            ctx.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(20, 15, 22)';
                            ctx.stroke();


                            ctx.beginPath();
                            ctx.moveTo(a, b);
                            ctx.lineTo(d, e);
                            ctx.strokeStyle = 'rgb(20, 15, 22)';
                            ctx.stroke();

                        } //drawing for lsr path ends here 
                    }
                    else if (arc_lrl == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        if (lrl(csl, cgl, start, goal, r) !== 0) {
                            var a = lrl(csl, cgl, start, goal, r)[0];
                            var b = lrl(csl, cgl, start, goal, r)[1];
                            var d = lrl(csl, cgl, start, goal, r)[2];
                            var e = lrl(csl, cgl, start, goal, r)[3];
                            var f = lrl(csl, cgl, start, goal, r)[4];
                            var g = lrl(csl, cgl, start, goal, r)[5];




                            var startAngle = Math.atan2(Number(g) - ((leftcircle(goal, r))[1]), Number(f) - ((leftcircle(goal, r))[0]));
                            var endAngle = Math.atan2(goal[1] - ((leftcircle(goal, r))[1]), goal[0] - ((leftcircle(goal, r))[0]));
                            ctx.beginPath();
                            ctx.arc((leftcircle(goal, r))[0], (leftcircle(goal, r))[1], r, endAngle, startAngle, false);
                            ctx.strokeStyle = 'rgb(220, 0, 0)';
                            ctx.stroke();

                            var startAngle = Math.atan2(Number(e) - ((leftcircle(start, r))[1]), Number(d) - ((leftcircle(start, r))[0]));
                            var endAngle = Math.atan2(start[1] - ((leftcircle(start, r))[1]), start[0] - ((leftcircle(start, r))[0]));
                            ctx.beginPath();
                            ctx.arc((leftcircle(start, r))[0], (leftcircle(start, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(220, 0, 0)';
                            ctx.stroke();

                            var startAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
                            var endAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
                            ctx.beginPath();
                            ctx.arc(Number(a), Number(b), r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(220, 0, 0)';
                            ctx.stroke();

                        } //drawing for lrl path ends here
                    }
                    else if (arc_rlr == Math.min(arc_lsl, arc_rsr, arc_rsl, arc_lsr, arc_lrl, arc_rlr)) {
                        if (rlr(csr, cgr, start, goal, r) !== 0) {
                            var a = rlr(csr, cgr, start, goal, r)[0];
                            var b = rlr(csr, cgr, start, goal, r)[1];
                            var d = rlr(csr, cgr, start, goal, r)[2];
                            var e = rlr(csr, cgr, start, goal, r)[3];
                            var f = rlr(csr, cgr, start, goal, r)[4];
                            var g = rlr(csr, cgr, start, goal, r)[5];

                            var endAngle = Math.atan2(Number(g) - ((rightcircle(goal, r))[1]), Number(f) - ((rightcircle(goal, r))[0]));
                            var startAngle = Math.atan2(goal[1] - ((rightcircle(goal, r))[1]), goal[0] - ((rightcircle(goal, r))[0]));
                            ctx.beginPath();
                            ctx.arc((rightcircle(goal, r))[0], (rightcircle(goal, r))[1], r, endAngle, startAngle, false);
                            ctx.strokeStyle = 'rgb(0, 220, 0)';
                            ctx.stroke();

                            var endAngle = Math.atan2(Number(e) - ((rightcircle(start, r))[1]), Number(d) - ((rightcircle(start, r))[0]));
                            var startAngle = Math.atan2(start[1] - ((rightcircle(start, r))[1]), start[0] - ((rightcircle(start, r))[0]));
                            ctx.beginPath();
                            ctx.arc((rightcircle(start, r))[0], (rightcircle(start, r))[1], r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(0, 220, 0)';
                            ctx.stroke();

                            var endAngle = Math.atan2(Number(e) - Number(b), Number(d) - Number(a));
                            var startAngle = Math.atan2(Number(g) - Number(b), Number(f) - Number(a));
                            ctx.beginPath();
                            ctx.arc(Number(a), Number(b), r, startAngle, endAngle, false);
                            ctx.strokeStyle = 'rgb(0, 220, 0)';
                            ctx.stroke();

                        } //drawing for rlr ends here

                    }
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
        step();
    });

};