class RectangleTracer {

  ArrayList<Trace> rects;
  int id = 0;

  RectangleTracer() 
  {
    rects = new ArrayList<Trace>();
  }

  void draw() {
    for (int i = 0; i < rects.size (); i++) {
      rects.get(i).draw();
    }
  }

  // returns -1 if no rectangle is added.
  int addRectangle(float x, float y, float width, float height) {
    int myId = -1;
    if (rects.size() < 32) {
      int minDeltaIndex = findMinPosDeltaIndex(x, y);
      if (minDeltaIndex != -1) {
        boolean isSimilar = isSimilar(rects.get(minDeltaIndex), x, y, width, height);
        if (isSimilar) {
          rects.get(minDeltaIndex).update(x, y, width, height);
        } else {
          myId = addNewRectangle(x, y, width, height);
        }
      } else {
        myId = addNewRectangle(x, y, width, height);
      }
    }
    return myId;
  }

  boolean isSimilar(Trace rect, float x, float y, float width, float height) {
    float dist = dist(x, y, rect.x, rect.y);
    boolean isSimilar = (dist < height || (width < 42 && dist < height * 1.5));
    return(isSimilar);
  }

  int addNewRectangle(float x, float y, float width, float height) {
    Trace rect = new Trace(x, y, width, height, id, colors[id % 19 ]);
    id += 1;
    rects.add(rect);
    return rect.id;
  }

  int findMinPosDeltaIndex(float x, float y) {
    int minDeltaIndex = -1;
    float minDelta = 99999;
    for (int i = 0; i < rects.size (); i++) {
      float delta = dist(x, y, rects.get(i).x, rects.get(i).y);
      if (delta < minDelta) {
        minDelta = delta;
        minDeltaIndex = i;
      }
    }
    return minDeltaIndex;
  }

  void update() {
    for (int i = rects.size ()-1; i >= 0; i--) {
      if (rects.get(i).heartbeatOff()) {
        rects.remove(i);
      }
    }
  }
  
  ArrayList<Trace> getTraces() {
    return rects;
  }
}
