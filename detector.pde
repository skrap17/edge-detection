class detector {
  int[][] maskX ={
    {-1, -2, -1}, 
    { 0, 0, 0}, 
    { 1, 2, 1}
  };

  int[][] maskY ={
    {-1, 0, 1}, 
    {-2, 0, 2}, 
    {-1, 0, 1}
  };

  int [][] filter ={
    {2, 4, 5, 4, 2}, 
    {4, 9, 12, 9, 4}, 
    {5, 12, 15, 12, 5}, 
    {4, 9, 12, 9, 4}, 
    {2, 4, 5, 4, 2}
  };
  int [][] filter1 ={
    {1, 4, 7, 4, 1}, 
    {4, 16, 26, 16, 4}, 
    {7, 26, 41, 26, 7}, 
    {4, 16, 26, 16, 4}, 
    {1, 4, 7, 4, 1}
  };
  float filt = 159;
  float fil1 = 273;

  PVector[][] G;

  int low = 40;
  int high = 80;
  float th = 0.1;

  PImage img;
  int w, h;

  detector(String fname) {
    img = loadImage(fname);
    w = img.width;
    h = img.height;
    img.filter(GRAY);
    G = new PVector[w][h];
    for (int i = 0; i < w; i++)
      for (int j = 0; j < h; j++)
        G[i][j] = new PVector();
  }

  void gauss_filter() {
    color[] dop = new color[img.pixels.length];
    for (int i = 0; i < dop.length; i++)
      dop[i] = img.pixels[i];
    for (int x = 2; x < w - 2; x++) {
      for (int y = 2; y < h - 2; y++) {
        float r = 0;
        float g = 0;
        float b = 0;
        int h = filter.length / 2;
        for (int i = - h; i <= h; i++) {
          for (int j = - h; j <= h; j++) {
            r += filter[i + h][j + h] * red(dop[ind(x + i, y + j)]);
            g += filter[i + h][j + h] * green(dop[ind(x + i, y + j)]);
            b += filter[i + h][j + h] * blue(dop[ind(x + i, y + j)]);
          }
        }
        r /= filt;
        g /= filt;
        b /= filt;
        img.pixels[ind(x, y)] = color(r, g, b);
      }
    }
  }


  void gradient() {
    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) {
        int gx = 0;
        int gy = 0;
        for (int i = -1; i < 2; i++) {
          for (int j = -1; j< 2; j++) {
            gx += maskX[i + 1][j + 1] * int(brightness(img.pixels[ind(x + i, y + j)]));
            gy += maskY[i + 1][j + 1] * int(brightness(img.pixels[ind(x + i, y + j)]));
            G[x][y] = new PVector(gx, gy);
            //println(G[x][y]);
          }
        }
      }
    }
  }

  void supress() {
    PVector[][] dop = new PVector[G.length][G[0].length];
    for (int x = 0; x < w; x++) 
      for (int y = 0; y < h; y++) 
        dop[x][y] = G[x][y].copy();

    PVector[] neigh = new PVector[8];
    for (int i = 0; i < neigh.length; i++)
      neigh[i] = new PVector();

    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) {
        set(neigh, x, y);
        if (!check_dir(x, y, 1, neigh, dop) || !check_dir(x, y, -1, neigh, dop))
          G[x][y].mult(0);
      }
    }
  }

  void set(PVector[] neigh, int x, int y) {
    neigh[0].set(x - 1, y);
    neigh[1].set(x - 1, y - 1);
    neigh[2].set(x, y - 1);
    neigh[3].set(x + 1, y - 1);
    neigh[4].set(x + 1, y);
    neigh[5].set(x + 1, y + 1);
    neigh[6].set(x, y + 1);
    neigh[7].set(x - 1, y + 1);
  }

  boolean check_dir(int x, int y, int dir, PVector[] neigh, PVector[][] dop) {
    float a = (dop[x][y].mult(Math.signum(dir))).heading();
    float mag = dop[x][y].mag();
    if (a < 0)
      a += TWO_PI;
    float diff;
    if (a != HALF_PI && a != 1.5 * PI)
      diff = abs(tan(a));
    else
      diff = 0;
    if (diff > 1)
      diff = 1 / diff;
    if (diff == 1)
      diff = 0;
    int frac = int(degrees(a) / 45);
    int[] index = new int[2];
    index[0] = frac;
    index[1] = (frac + 1) % 8;
    if (frac % 2 == 1) {
      diff = 1 - diff;
    }
    //println(index[0], index[1]);
    float near = map(diff, 0, 1, dop[int(neigh[index[0]].x)][int(neigh[index[0]].y)].mag(), dop[int(neigh[index[1]].x)][int(neigh[index[1]].y)].mag());
    return mag > near;
  }

  void double_thresholding() {
    ArrayList<PVector> strong = new ArrayList<PVector>();
    ArrayList<PVector> weak = new ArrayList<PVector>();
    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) { 
        if (G[x][y].mag() < low)
          G[x][y].mult(0);
        else if (G[x][y].mag() < high)
          weak.add(new PVector(x, y));
        else 
        strong.add(new PVector(x, y));
      }
    }

    int ds = abs(strong.size() - weak.size());
    int dds = 1;

    while (dds != 0) {
      for (int i = 0; i < strong.size(); i++) {
        for (int x = max(0, int(strong.get(i).x) - 1); x < min(w, int(strong.get(i).x) + 2); x++) {
          for (int y = max(0, int(strong.get(i).y) - 1); y < min(h, int(strong.get(i).y) + 2); y++) {
            PVector v = new PVector(x, y);
            if (weak.contains(v)) {
              weak.remove(v);
              strong.add(v);
            }
          }
        }
      }
      dds = abs(ds - abs(strong.size() - weak.size()));
      ds = abs(strong.size() - weak.size());
    }

    for (PVector v : weak) {
      G[int(v.x)][int(v.y)].mult(0);
    }
  }

  PImage detect() {
    img.loadPixels();
    println("started");
    gauss_filter();
    println("filtered");
    gradient();
    println("gradiented");
    supress();
    println("supressed");
    double_thresholding2();
    println("thresholded");
    PImage edges = createImage(w, h, RGB);
    edges.loadPixels();
    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) { 
        if (G[x][y].mag() != 0)
          edges.pixels[ind(x, y)] = color(255);
        else 
        edges.pixels[ind(x, y)] = color(0);
      }
    }
    edges.updatePixels();
    return edges;
  }



  void double_thresholding2() {
    HashSet<PVector> strong = new HashSet<PVector>();
    HashSet<PVector> weak = new HashSet<PVector>();
    HashSet<PVector> mixed = new HashSet<PVector>();
    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) { 
        if (G[x][y].mag() < low)
          G[x][y].mult(0);
        else if (G[x][y].mag() < high)
          weak.add(new PVector(x, y));
        else 
        strong.add(new PVector(x, y));
      }
    }

    int ds = abs(strong.size() - weak.size());
    int dds = 1;

    while (dds != 0) {
      //Iterator<PVector> i = strong.iterator();
      for (Iterator<PVector> i = strong.iterator(); i.hasNext(); ) {
        PVector cur = i.next();
        for (int x = max(0, int(cur.x) - 1); x < min(w, int(cur.x) + 2); x++) {
          for (int y = max(0, int(cur.y) - 1); y < min(h, int(cur.y) + 2); y++) {
            PVector v = new PVector(x, y);
            if (weak.contains(v)) {
              weak.remove(v);
              mixed.add(v);
            }
          }
        }
      }
      strong.addAll(mixed);
      mixed.clear();
      dds = abs(ds - abs(strong.size() - weak.size()));
      ds = abs(strong.size() - weak.size());
    }

    for (PVector v : weak) {
      G[int(v.x)][int(v.y)].mult(0);
    }
  } 
  void double_thresholding3() {
    HashSet<PVector> strong = new HashSet<PVector>();
    HashSet<PVector> weak = new HashSet<PVector>();
    HashSet<PVector> mixed = new HashSet<PVector>();
    for (int x = 1; x < w - 1; x++) {
      for (int y = 1; y < h - 1; y++) { 
        if (G[x][y].mag() < low)
          G[x][y].mult(0);
        else if (G[x][y].mag() < high)
          weak.add(new PVector(x, y));
        else 
        strong.add(new PVector(x, y));
      }
    }

    int ds = abs(strong.size() - weak.size());
    int dds = 1;

    while (dds != 0) {
      //Iterator<PVector> i = strong.iterator();
      for (Iterator<PVector> i = strong.iterator(); i.hasNext(); ) {
        PVector cur = i.next();
        for (int x = max(0, int(cur.x) - 1); x < min(w, int(cur.x) + 2); x++) {
          for (int y = max(0, int(cur.y) - 1); y < min(h, int(cur.y) + 2); y++) {
            PVector v = new PVector(x, y);
            if (weak.contains(v)) {
              weak.remove(v);
              mixed.add(v);
            }
          }
        }
      }
      strong.addAll(mixed);
      mixed.clear();
      dds = abs(ds - abs(strong.size() - weak.size()));
      ds = abs(strong.size() - weak.size());
    }
    
    
    mixed.clear();
    for (Iterator<PVector> it = strong.iterator(); it.hasNext(); ) {
      PVector cur = it.next();
      int x = int(cur.x);
      int y = int(cur.y);
      for (int i = max(x - 1, 0); i < min(x + 2, w); i++) {
        for (int j = max(y - 1, 0); j < min(y + 2, h); j++) {
          PVector check = new PVector(i, j);
          if (weak.contains(check)) {
            if (PVector.angleBetween(cur, check) < th){
              weak.remove(check);
              mixed.add(check);
            }
          }
        }
      }
      strong.addAll(mixed);
    }

    for (PVector v : weak) {
      G[int(v.x)][int(v.y)].mult(0);
    }
  }
}
