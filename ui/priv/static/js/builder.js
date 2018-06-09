class HpglBuilder {
  constructor(init) {
    this.commands = init === true ? ["IN", "DF", "SC", "SP1"] : [];
  }

  // Initialize
  in() {
    this.commands.push("IN");
  }

  // Default
  df() {
    this.commands.push("DF");
  }

  // Select pen
  sp(pen) {
    this.commands.push(`SP${pen}`);
  }

  // Position absolute
  pa(x, y) {
    this.commands.push(`PA${x},${y}`);
  }

  // Position relative
  pr(x, y) {
    this.commands.push(`PR${x},${y}`);
  }

  // Pen up
  pu(x, y) {
    if (x === undefined && y === undefined) {
      this.commands.push("PU");
    } else {
      this.commands.push(`PU${x},${y}`);
    }
  }

  // Pen down
  pd(x, y) {
    if (x === undefined && y === undefined) {
      this.commands.push("PD");
    } else {
      this.commands.push(`PD${x},${y}`);
    }
  }

  // Absolute character size
  // 0.0-1.0
  si(x, y) {
    this.commands.push(`SI${x},${y}`);
  }

  // Relative character size
  sr(x, y) {
    this.commands.push(`SR${x},${y}`);
  }

  // Absolute direction
  // text direction
  // -1,0,1
  // 0,1 -> horizontal
  di(run, rise) {
    this.commands.push(`DI${run},${rise}`);
  }

  // Scale
  sc(x_min, x_max, y_min, y_max) {
    this.commands.push(`SC${x_min},${x_max},${y_min},${y_max}`);
  }

  // Define Label Terminator
  dt(terminator) {
    this.commands.push(`DT${terminator}`);
  }

  // Label
  lb(text, eot) {
    if (eot === undefined) {
      eot = String.fromCharCode(3);
    }

    this.commands.push(`LB${text}${eot}`);
  }

  // Circle
  ci(radius) {
    this.commands.push(`CI${radius}`);
  }

  get() {
    return this.commands.join(";\r\n");
  }
}
