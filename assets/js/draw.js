
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

  join_channel(draw_cfg.game, draw_cfg.user);

  $('#clear-btn').click(got_clear);
  $('#guess-btn').click(send_guess);
  $('#guess-word').keypress(e => {
    if (e.which == 13) { send_guess(); }
  });

  stage = new createjs.Stage("draw-canvas");
  refresh_stage();

  setup_game();
}

$(draw_init);

function setup_game() {
  $('#draw-word').text(draw_cfg.word);

  if (draw_cfg.host) {
    console.log("you're hosting", draw_cfg);
    stage.on("mousedown", got_down);
    stage.on("pressmove", _.throttle(got_drag, 50));
    $('#draw-controls').show();
    $('#guess-controls').hide();
  }
  else {
    console.log("you're guessing", draw_cfg);
    stage.off("mousedown");
    stage.off("pressmove");
    $('#draw-controls').hide();
    $('#guess-controls').show();
  }
}

function send_guess(evt) {
  var input = $($('#guess-word')[0]);
  var word = input.val();
  input.val('');

  chan.push("guess", {word: word})
    .receive("ok", got_guess_response);
}

function got_guess_response(msg) {
  console.log("resp", msg);

  if (msg.word) {
    draw_cfg.word = msg.word;
    setup_game();
  }
}

function got_guess(msg) {
  var par = $('#guess-result');

  if (msg.status == "win") {
    par.text(`${msg.user} guessed "${msg.word}". Winner!"`);
    draw_cfg.host = (msg.user == draw_cfg.user);
    setup_game();
  }
  else if (msg.status == "bad") {
    par.text(`${msg.user} guessed "${msg.word}". Wrong!`);
  }
}

function got_clear(evt) {
  clear_stage();
  chan.push("clear", {});
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
  chan.push("draw", {seg: seg});
}

function join_channel(game, user) {
  chan = socket.channel("game:" + game, {user: user});
  chan.join()
    .receive("ok", resp => { console.log("Joined successfully", resp); })
    .receive("error", resp => { console.log("Unable to join", resp); });

  chan.on("draw", remote_draw);
  chan.on("clear", clear_stage);
  chan.on("guess", got_guess);
}

function remote_draw(msg) {
  draw_seg(msg.seg);
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

  $('#point-count').text(segs.length);
}

