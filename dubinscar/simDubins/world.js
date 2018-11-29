//Create box2d world object
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

//box2d to canvas scale , therefore 1 metre of box2d = 30px of canvas
var scale = 30;

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


    //long rod with a notch
    bodyDef.type = b2Body.b2_dynamicBody;
    bodyDef.position.Set(40, 24);
    bodyDef.userData = 'rod1';
    bodyDef.angle = 3.142;
    //bodyDef.angle = 1.67;
    fixDef.density = 1000.0;
    fixDef.friction = 1000.0;
    fixDef.restitution = 0.2;
    var body = world.CreateBody(bodyDef);
    var polys = [
        //[{ x: -0.5, y: -0.01 }, { x: 0.5, y: -0.6 }, { x: 0.5, y: 0.6 }, { x: -0.5, y: 0.01 }],
        [{ x: 0.5, y: -0.6 }, { x: 0.5, y: 0.6 }, { x: -0.45, y: 0 }],
        [{ x: 0.5, y: -4.0 }, { x: 1.5, y: -4.0 }, { x: 1.5, y: 4.0 }, { x: 0.5, y: 4.0 }]

        //[{ x: 1.5, y: 4.0 }, { x: 2.5, y: 4.0 }, { x: 2.5, y: 12.0 }, { x: 1.5, y: 12.0 }, { x: 1.5, y: 8.6 }, { x: 0.5, y: 8.0 }, { x: 1.5, y: 7.4 }]
    ]

    for (var j = 0; j < polys.length; j++) {
        var points = polys[j];
        var vecs = [];
        for (var i = 0; i < points.length; i++) {
            var vec = new b2Vec2();
            vec.Set(0.5 + points[i].x, points[i].y);
            vecs[i] = vec;
        }
        fixDef.shape = new b2PolygonShape;
        fixDef.shape.SetAsArray(vecs, vecs.length);
        body.CreateFixture(fixDef);
        body.m_angularDamping = 8000.0;
        body.m_linearDamping = 8000.0;
    }

    //mirrored rod (has a slot for the notch)
    bodyDef.type = b2Body.b2_dynamicBody;
    bodyDef.position.Set(20, 18);
    bodyDef.userData = 'rod2';
    fixDef.density = 1000.0;
    fixDef.friction = 1000.0;
    fixDef.restitution = 0.2;
    var body = world.CreateBody(bodyDef);
    var polys = [
        [{ x: 0.5, y: -5.0 }, { x: 2.5, y: -5.0 }, { x: 2.5, y: -1.75 }, { x: 1.5, y: -1.0 }, { x: 0.5, y: -1.0 }],
        [{ x: 0.5, y: -1.0 }, { x: 1.5, y: -1.0 }, { x: 2.5, y: -0.25 }, { x: 2.5, y: 3.0 }, { x: 0.5, y: 3.0 }]

        //[{x:0.5,y:3.0},{x:2.5,y:3.0},{x:2.5,y:-0.25},{x:1.5,y:-1.0},{x:2.5,y:-1.75},{x:2.5,y:-5.0},{x:0.5,y:-5.0},{x:0.5,y:-1.0}]

        //[{ x: 0.5, y: 1.0 }, { x: 2.5, y: 1.0 }, { x: 2.5, y: 4.25 }, { x: 1.5, y: 5.0 }, { x: 2.5, y: 5.75 }, { x: 2.5, y: 9.0 }, { x: 0.5, y: 9.0 }]
    ]

    for (var j = 0; j < polys.length; j++) {
        var points = polys[j];
        var vecs = [];
        for (var i = 0; i < points.length; i++) {
            var vec = new b2Vec2();
            vec.Set(-1.5 + points[i].x, 1.0 + points[i].y);
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