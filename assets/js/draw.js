
import "yuki-createjs";
import socket from "./socket";

var chan;
var stage;
var segs = [];
var last_down = null;

function draw_init() {
    if ($('body').data('page') != "GameView/show") {
        return;
    }

    $('#clear-btn').on("click", clear_stage);

    stage = new createjs.Stage("draw-canvas");
    refresh_stage();
    stage.on("mousedown", got_down);
    stage.on("pressmove", _.throttle(got_drag, 50));

    join_channel("game0");
}

$(draw_init);

function join_channel(game_id) {
    chan = socket.channel("game:" + game_id, {});
    chan.join()
        .receive("ok", resp => { console.log("Joined successfully", resp); })
        .receive("error", resp => { console.log("Unable to join", resp); });

    chan.on("draw", remote_draw);
}

function remote_draw(msg) {
    draw_seg(msg.seg);
}

function send_seg(seg) {
    chan.push("draw", {seg: seg});
}

function clear_stage() {
    segs = [];
    refresh_stage();
}

function refresh_stage() {
    stage.removeAllChildren();

    var bg = new createjs.Shape();
    bg.graphics.beginFill("White").drawRect(0, 0, 800, 600);
    bg.x = 0;
    bg.y = 0;
    stage.addChild(bg);

    stage.update();
    $('#point-count').text(segs.length);
}

function draw_seg(seg) {
    var [[x0, y0], [x1, y1]] = seg;
    var sh = new createjs.Shape();
    sh.graphics.
       beginStroke("Black").
       setStrokeStyle(5, "round").
       moveTo(x0, y0).
       lineTo(x1, y1);
    stage.addChild(sh);
    stage.update();
}

function got_down(evt) {
    last_down = [evt.stageX, evt.stageY];
}

function got_drag(evt) {
    var next_down = [evt.stageX, evt.stageY];
    var seg = [last_down, next_down];

    segs.push(seg);
    last_down = next_down;

    draw_seg(seg);
    send_seg(seg);

    $('#point-count').text(segs.length);
}

