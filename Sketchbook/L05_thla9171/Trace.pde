class Trace {
  float x;
  float y;
  float dx;
  float dy;
  float width;
  float height;
  color objectColor;
  int lifetime;
  int lastseen;
  int id;

  Trace(float _x, float _y, float _width, float _height, int _id, color _color) {
    x = _x;
    y = _y;
    height = _height;
    width = _width;
    id = _id;
    objectColor = _color;
    lifetime = 0;
    lastseen = 0;
    dx = 0;
    dy = 0;
  }

  boolean heartbeatOff() {
    lifetime += 1;
    lastseen += 1;
    if (lastseen > 1) {
      x += dx;
      y += dy;
      dx *= 0.9;
      dy *= 0.9;
    }
    if (lifetime > 72) {
      return(lastseen > 48);
    }
    if (lifetime > 48) {
      return(lastseen > 24);
    }
    if (lifetime > 18) {
      return(lastseen > 8);
    }
    if (lifetime > 12) {
      return(lastseen > 6);
    }
    return(lastseen > 4);
  }

  void update(float _x, float _y, float _width, float _height) {
    dx = x - _x;
    dy = y - _y;
    x = _x;
    y = _y;
    height = _height;
    width = _width;
    lastseen = 0;
  }

  void draw() {
    pushStyle();
    noFill();
    stroke(objectColor);
    strokeWeight(3);
    rect(x, y, width, height);
    popStyle();
  }
}

