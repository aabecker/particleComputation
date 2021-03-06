/**
    Mouse joint demo of box2d in javascript
    Silver Moon (m00n.silv3r@gmail.com)
*/

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
    var canvas_width;
    var canvas_height;
    var mouse_pressed = false;
    var mouse_joint = false;
    var mouse_x, mouse_y;

    //box2d to canvas scale , therefor 1 metre of box2d = 30px of canvas :)
    var scale = 30;

    /*
        Draw a world
        this method is called in a loop to redraw the world
    */
    function draw_world(world, context) {
        //convert the canvas coordinate directions to cartesian coordinate direction by translating and scaling
        ctx.save();
        ctx.translate(0, canvas_height);
        ctx.scale(1, -1);
        world.DrawDebugData();
        ctx.restore();

        ctx.font = 'bold 18px arial';
        ctx.textAlign = 'center';
        ctx.fillStyle = '#fff';
        ctx.fillText('Box2d MouseJoint example in Javascript', canvas_width / 2, 20);
        ctx.font = 'bold 14px arial';
        ctx.fillText('Click on any object and drag it', canvas_width / 2, 40);
    }

    //Create box2d world object
    function createWorld() {
        //Gravity vector x, y - 10 m/s2 - thats earth!!
        //var gravity = new b2Vec2(0, -10);
        //var gravity = new b2Vec2(0, 00);

        //world = new b2World(gravity, true);

        var world = new b2World(
            new b2Vec2(0, -01)    //gravity  setting to zero removes gravity
         ,  true                 //allow sleep
         );

        //setup debug draw
        var debugDraw = new b2DebugDraw();
        debugDraw.SetSprite(document.getElementById("canvas").getContext("2d"));
        debugDraw.SetDrawScale(scale);
        debugDraw.SetFillAlpha(0.5);
        debugDraw.SetLineThickness(1.0);
        debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);

        world.SetDebugDraw(debugDraw);

        //create some objects
        ground = createBox(world, 8.5, 2, 16, 1, { type: b2Body.b2_staticBody, 'user_data': { 'fill_color': 'rgba(204,237,165,1)', 'border_color': '#7FE57F' } });
        createBox(world, 6.50, 3.80, 1, 1, { 'user_data': { 'border_color': '#555' } });
        createBox(world, 8.50, 3.80, 1, 1, { 'user_data': { 'fill_color': 'rgba(204,0,165,0.3)', 'border_color': '#555' } });
        createBall(world, 8.50, 3.80, 1, { 'user_data': { 'fill_color': 'rgba(204,100,0,0.3)', 'border_color': '#555' } });

        return world;
        console.log(world);
    }
    //Function to create a round ball, sphere like object
    function createBall(world, x, y, radius, options) {
        var body_def = new b2BodyDef();
        var fix_def = new b2FixtureDef();

        fix_def.density = options.density || 1.0;
        fix_def.friction = 0.5;
        fix_def.restitution = 0.5;

        var shape = new b2CircleShape(radius);
        fix_def.shape = shape;

        body_def.position.Set(x, y);

        body_def.linearDamping = 0.0;
        body_def.angularDamping = 0.0;

        body_def.type = b2Body.b2_dynamicBody;
        body_def.userData = options.user_data;

        var b = world.CreateBody(body_def);
        b.CreateFixture(fix_def);

        return b;
    }

    //Create standard boxes of given height , width at x,y
    function createBox(world, x, y, width, height, options) {
        //default setting
        options = $.extend(true, {
            'density': 0.0,
            'friction': 1.0,
            'restitution': 0.5,

            'type': b2Body.b2_dynamicBody
        }, options);

        var body_def = new b2BodyDef();
        var fix_def = new b2FixtureDef();

        fix_def.density = options.density;
        fix_def.friction = options.friction;
        fix_def.restitution = options.restitution;

        fix_def.shape = new b2PolygonShape();

        fix_def.shape.SetAsBox(width / 2, height / 2);

        body_def.position.Set(x, y);

        body_def.type = options.type;
        body_def.userData = options.user_data;

        var b = world.CreateBody(body_def);
        var f = b.CreateFixture(fix_def);

        return b;
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

        //redraw the world
        draw_world(world, ctx);

        //call this function again after 1/60 seconds or 16.7ms
        setTimeout(step, 1000 / fps);
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