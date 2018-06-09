class HpglPreview {
  /*
  # some ranges from
  # https://github.com/tobiastoft/SymbolicDisarray
  # -- PLOTTER --
  # --  front  --
  # 0 - 602 - y - 10602 - ?
  # |
  # 170
  # |
  # x
  # |
  # 15370
  # |
  # ?
  */

  constructor(canvas) {
    const resolution = 800;

    this.x = 0;
    this.y = 0;
    this.xMin = 0;
    this.xMax = 15370;
    this.yMin = 0;
    this.yMax = 10602;
    this.lines = [];

    this.ctx = canvas.getContext("2d");
    this.ctx.lineJoin = "round";
    this.ctx.lineCap = "round";
    this.ctx.strokeStyle = "rgba(0,0,0,1)";
    this.ctx.lineWidth = 0.5;

    this.canvas = canvas;

    // aspect ratio
    // 1:1.41
    this.w = resolution;
    this.h = resolution * 1.41;

    if (window.devicePixelRatio >= 2) {
      this.canvas.width = this.w * 2;
      this.canvas.height = this.h * 2;
      this.ctx.scale(2, 2);
    } else {
      this.canvas.width = this.w;
      this.canvas.height = this.h;
    }
  }

  _canvasWidth() {
    return this.w;
    //return this.ctx.canvas.width;
  }

  _canvasHeight() {
    return this.h;
    //return this.ctx.canvas.height;
  }

  _map(num, in_min, in_max, out_min, out_max) {
    return ((num - in_min) * (out_max - out_min)) / (in_max - in_min) + out_min;
  }

  batch(hpgl) {
    let commands = hpgl.split(/[\r\n;]+/);
    _.each(commands, command => {
      this.single(command, false);
    });
    this.redraw();
  }

  single(cmd, draw) {
    if (cmd.startsWith("PU")) {
      let params = cmd.match(/(\d+),(\d+)/);
      if (params != null) {
        this.x = parseInt(params[1]);
        this.y = parseInt(params[2]);
      }
    }

    if (cmd.startsWith("PD")) {
      let params = cmd.match(/(\d+),(\d+)/);
      if (params != null) {
        let pX = parseInt(params[1]);
        let pY = parseInt(params[2]);

        // map x to height an y to width...
        let fromX = this._map(this.x, this.xMin, this.xMax, 1, this.h - 1);
        let fromY = this._map(this.y, this.yMin, this.yMax, 1, this.w - 1);
        let toX = this._map(pX, this.xMin, this.xMax, 1, this.h - 1);
        let toY = this._map(pY, this.yMin, this.yMax, 1, this.w - 1);
        // ...then flip positions
        let line = [[fromY, fromX], [toY, toX]];
        // since canvas and paper coordinate systems are flipped

        this.lines.push([[fromY, fromX], [toY, toX]]);

        if (draw === true) {
          this.draw_line(line);
        }

        this.x = pX;
        this.y = pY;
      }
    }

    if (cmd.startsWith("SC")) {
      let params = cmd.match(/(\d+),(\d+),(\d+),(\d+)/);
      if (params != null) {
        this.xMin = parseInt(params[1]);
        this.xMax = parseInt(params[2]);
        this.yMin = parseInt(params[3]);
        this.yMax = parseInt(params[4]);
      }
    }
  }

  draw_line(line) {
    console.log("draw_line()");
    if (line === undefined) {
      return;
    }

    let from = line[0];
    let to = line[1];
    this.ctx.moveTo(from[0], from[1]);
    this.ctx.lineTo(to[0], to[1]);

    this.ctx.stroke();
  }

  redraw() {
    console.log("redraw()");
    this.ctx.clearRect(0, 0, this.w, this.h);

    _.each(this.lines, line => {
      let from = line[0];
      let to = line[1];
      this.ctx.moveTo(from[0], from[1]);
      this.ctx.lineTo(to[0], to[1]);
    });

    this.ctx.stroke();
  }
}
