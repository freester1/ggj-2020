
import "yuki-createjs";
import "./socket";

var stage;
var points = [];
var last_point = null;

function draw_init() {
    if ($('body').data('page') != "GameView/show") {
        return;
    }

    $('#clear-btn').on("click", clear_stage);

    stage = new createjs.Stage("draw-canvas");
    stage.on("mousedown", got_down);
    stage.on("pressmove", _.throttle(got_drag, 50));

    clear_stage();
}

$(draw_init);

function clear_stage() {
    points = [];
    stage.removeAllChildren();

    var bg = new createjs.Shape();
    bg.graphics.beginFill("White").drawRect(0, 0, 800, 600);
    bg.x = 0;
    bg.y = 0;
    stage.addChild(bg);

    stage.update();
    $('#point-count').text(points.length);
}

function got_down(evt) {
    last_point = [evt.stageX, evt.stageY];
}

function got_drag(evt) {
    var [px, py] = last_point;
    var [cx, cy] = [evt.stageX, evt.stageY];
    var seg = new createjs.Shape();
    seg.graphics.
        beginStroke("Black").
        setStrokeStyle(5, "round").
        moveTo(px, py).
        lineTo(cx, cy);
    stage.addChild(seg);
    stage.update();

    points.push([[px, py], [cx, cy]]);
    last_point = [cx, cy];

    $('#point-count').text(points.length);
}

