

int ind(int x, int y) {
  return x + y * img.width;
}


//void gauss_filter(PImage img) {
//  img.loadPixels();
//  color[] dop = new color[img.pixels.length];
//  for (int i = 0; i < dop.length; i++)
//    dop[i] = img.pixels[i];
//  for (int x = 2; x < img.width - 2; x++) {
//    for (int y = 2; y < img.height - 2; y++) {
//      float r = 0;
//      float g = 0;
//      float b = 0;
//      for (int i = -2; i < 3; i++) {
//        for (int j = -2; j< 3; j++) {
//          r += filter[i + 2][j + 2] * red(dop[ind(x + i, y + j)]);
//          g += filter[i + 2][j + 2] * green(dop[ind(x + i, y + j)]);
//          b += filter[i + 2][j + 2] * blue(dop[ind(x + i, y + j)]);
//        }
//      }
//      r /= filt;
//      g /= filt;
//      b /= filt;
//      img.pixels[ind(x, y)] = color(r, g, b);
//    }
//  }
//  img.updatePixels();
//}

//void gradient(PImage img) {
//  img.loadPixels();
//  for (int x = 1; x < img.width - 1; x++) {
//    for (int y = 1; y < img.height - 1; y++) {
//      int gx = 0;
//      int gy = 0;
//      for (int i = -1; i < 2; i++) {
//        for (int j = -1; j< 2; j++) {
//          gx += maskX[i + 1][j + 1] * int(brightness(img.pixels[ind(x + i, y + j)]));
//          gy += maskY[i + 1][j + 1] * int(brightness(img.pixels[ind(x + i, y + j)]));
//          G[x][y] = new PVector(gx, gy);
//          //println(G[x][y]);
//        }
//      }
//    }
//  }
//}

//void adjust_gradient(PImage img) {
//  for (int x = 0; x < img.width; x++) {
//    for (int y = 0; y < img.height; y++) { 
//      float a = degrees(G[x][y].heading());
//      float mag = G[x][y].mag();
//      if (a >= - 22.5 && a < 22.5) {
//        Ga[x][y] = PVector.fromAngle(0);
//      } else if (a >= 22.5 && a < 67.5) {
//        Ga[x][y] = PVector.fromAngle(QUARTER_PI);
//      } else if (a >= 67.5 && a < 112.5) {
//        Ga[x][y] = PVector.fromAngle(HALF_PI);
//      } else if (a >= 112.5 && a < 157.5) {
//        Ga[x][y] = PVector.fromAngle(HALF_PI * 1.5);
//      } else if (a >=  157.5 && a <= 180) {
//        Ga[x][y] = PVector.fromAngle(-PI);
//      } else if (a >=  -180 && a <= - 157.5) {
//        Ga[x][y] = PVector.fromAngle(-PI);
//      } else if (a >=  - 157.5 && a <  - 112.5) {
//        Ga[x][y] = PVector.fromAngle(- HALF_PI * 1.5);
//      } else if (a >=  - 112.5 && a <  - QUARTER_PI * 67.5) {
//        Ga[x][y] = PVector.fromAngle(- HALF_PI);
//      } else if (a >=  - 67.5 && a <  - 22.5) {
//        Ga[x][y] = PVector.fromAngle(- QUARTER_PI);
//      } else {
//        println("ups", a);
//      }
//      Ga[x][y].setMag(mag);
//      //G[x][y].limit(255);
//      //println(degrees(G[x][y].heading()));
//      //delay(20);
//    }
//  }
//}

//void supress(PImage img) {
//  img.loadPixels();
//  PVector[][] dop = new PVector[Ga.length][Ga[0].length];
//  for (int x = 0; x < img.width; x++) 
//    for (int y = 0; y < img.height; y++) 
//      dop[x][y] = Ga[x][y].copy();

//  for (int x = 0; x < img.width; x++) {
//    for (int y = 0; y < img.height; y++) { 
//      float a = degrees(dop[x][y].heading());
//      float max = dop[x][y].mag();
//      PVector first, second;
//      if (a == 0 || round(a) == 180) {
//        first = new PVector(x - 1, y);
//        second = new PVector(x + 1, y);
//      } else if (a == 45 || a == -135) {
//        first = new PVector(x - 1, y - 1);
//        second = new PVector(x + 1, y + 1);
//      } else if (a == 90 || a == -90) {
//        first = new PVector(x, y + 1);
//        second = new PVector(x, y - 1);
//      } else { //a == 135 || a == -45
//        first = new PVector(x + 1, y - 1);
//        second = new PVector(x - 1, y + 1);
//      } 
//      boolean res = false;
//      if (in_bound(img, first))
//        res = max > dop[int(first.x)][int(first.y)].mag();
//      if (in_bound(img, second))
//        res = res && (max > dop[int(second.x)][int(second.y)].mag());
//      if (!res)
//        G[x][y].setMag(0);
//    }
//  }
//}

//boolean in_bound(PImage img, PVector v) {
//  return v.x >= 0 && v.x < img.width && v.y >= 0 && v.y < img.height;
//}

//void double_threshold(PImage img) {
//  for (int x = 0; x < img.width; x++) {
//    for (int y = 0; y < img.height; y++) { 
//      if (G[x][y].mag() >= low && G[x][y].mag() < high) {
//        boolean edge = false;
//        for (int i = max(x - 1, 0); i < min(img.width, x + 2) && !edge; i++) {
//          for (int j = max(y - 1, 0); j < min(img.height, y + 2) && !edge; j++) {
//            if (G[i][j].mag() >= high)
//              edge = true;
//          }
//        }
//        if (!edge)
//          G[x][y].mult(0);
//      } else if (G[x][y].mag() < low)
//        G[x][y].mult(0);
//      img.pixels[ind(x, y)] = color(G[x][y].mag());
//    }
//  }
//  img.updatePixels();
//}

//void last(PImage img) {
//  for (int x = 0; x < img.width; x++) {
//    for (int y = 0; y < img.height; y++) { 
//      if (x < 2 || x >= img.width - 2 || y < 2 || y >= img.height - 2) {
//        G[x][y].mult(0);
//        img.pixels[ind(x, y)] = color(0);
//      }
//      if (img.pixels[ind(x, y)] != color(0))
//        img.pixels[ind(x, y)] = color(255);
//      //img.pixels[ind(x, y)] = color(G[x][y].mag());
//    }
//  }
//  img.updatePixels();
//}

//void sup(PImage img) {
//  img.loadPixels();
//  PVector[][] dop = new PVector[G.length][G[0].length];
//  for (int x = 0; x < img.width; x++) 
//    for (int y = 0; y < img.height; y++) 
//      dop[x][y] = G[x][y].copy();

//  for (int x = 1; x < img.width - 1; x++) {
//    for (int y = 1; y < img.height - 1; y++) { 
//      boolean loc_max;
//      float alpha = degrees(dop[x][y].heading());
//      float cur_mag = dop[x][y].mag();
//      PVector[] head = new PVector[2];
//      head[0] = new PVector(x, y);
//      head[1] = new PVector(x + dop[x][y].x, y + dop[x][y].y);
//      PVector[] pos = new PVector[2];
//      PVector[] neg = new PVector[2];
//      if (alpha < 0)
//        alpha += 360;
//      if ((alpha >= 0 && alpha < 45) || (alpha >= 180 && alpha < 225)) {
//        pos[0] = new PVector(x - 1, y);
//        pos[1] = new PVector(x - 1, y - 1);
//        neg[0] = new PVector(x + 1, y);
//        neg[1] = new PVector(x + 1, y + 1);
//      } else if ((alpha >= 45 && alpha < 90) || (alpha >= 225 && alpha < 270)) {
//        pos[0] = new PVector(x - 1, y - 1);
//        pos[1] = new PVector(x, y - 1);
//        neg[0] = new PVector(x + 1, y + 1);
//        neg[1] = new PVector(x, y + 1);
//      } else if ((alpha >= 90 && alpha < 135) || (alpha >= 270 && alpha < 315)) {
//        pos[0] = new PVector(x, y - 1);
//        pos[1] = new PVector(x + 1, y - 1);
//        neg[0] = new PVector(x, y + 1);
//        neg[1] = new PVector(x - 1, y + 1);
//      } else {
//        pos[0] = new PVector(x + 1, y - 1);
//        pos[1] = new PVector(x + 1, y);
//        neg[0] = new PVector(x - 1, y + 1);
//        neg[1] = new PVector(x - 1, y);
//      }
//      PVector int1 = inter(pos, head);
//      float near_val = mapping(pos, int1, dop);
//      loc_max = cur_mag > near_val;
//      int1 = inter(neg, head);
//      near_val = mapping(neg, int1, dop);
//      loc_max = loc_max && (cur_mag > near_val);
//      if (!loc_max)
//        G[x][y].mult(0);
//    }
//  }
//}

//PVector inter(PVector[] pos, PVector[] head) {
//  PVector inters = new PVector();
//  float tnum = (pos[0].x - head[0].x) * (head[0].y - head[1].y) - (pos[0].y - head[0].y) * (head[0].x - head[1].x);
//  float tden = (pos[0].x - pos[1].x) * (head[0].y - head[1].y) - (pos[0].y - pos[1].y) * (head[0].x - head[1].x);
//  inters.x = pos[0].x + (tnum / tden) * (pos[1].x - pos[0].x);
//  inters.y = pos[0].y + (tnum / tden) * (pos[1].y - pos[0].y);
//  return inters;
//}

//float mapping(PVector[] v, PVector p, PVector[][] dop) {
//  float xdiff;
//  xdiff = abs(v[0].x - p.x);
//  float ydiff;
//  ydiff = abs(v[0].y - p.y);
//  //if(Double.isNaN(xdiff) || Double.isNaN(ydiff))
//  //println(p);
//  return map(ydiff + xdiff, 0, 1, dop[int(v[0].x)][int(v[0].y)].mag(), dop[int(v[1].x)][int(v[1].y)].mag());
//}

//void dt(PImage img) {
//  ArrayList<PVector> strong = new ArrayList<PVector>();
//  ArrayList<PVector> weak = new ArrayList<PVector>();
//  for (int x = 1; x < img.width - 1; x++) {
//    for (int y = 1; y < img.height - 1; y++) { 
//      if (G[x][y].mag() < low)
//        G[x][y].mult(0);
//      else if (G[x][y].mag() < high)
//        weak.add(new PVector(x, y));
//      else 
//      strong.add(new PVector(x, y));
//    }
//  }

//  int ds = abs(strong.size() - weak.size());
//  int dds = 1;

//  while (dds != 0) {
//    for (int i = 0; i < strong.size(); i++) {
//      for (int x = max(0, int(strong.get(i).x) - 1); x < min(img.width, int(strong.get(i).x) + 2); x++) {
//        for (int y = max(0, int(strong.get(i).y) - 1); y < min(img.height, int(strong.get(i).y) + 2); y++) {
//          PVector v = new PVector(x, y);
//          if (weak.contains(v)) {
//            weak.remove(v);
//            strong.add(v);
//          }
//        }
//      }
//    }
//    dds = abs(ds - abs(strong.size() - weak.size()));
//    ds = abs(strong.size() - weak.size());
//  }

//  for (PVector v : weak) {
//    G[int(v.x)][int(v.y)].mult(0);
//  }

//  for (int x = 1; x < img.width - 1; x++) {
//    for (int y = 1; y < img.height - 1; y++) { 
//      img.pixels[ind(x, y)] = color(G[x][y].mag());
//    }
//  }
//}

//void supr(PImage img) {
//  PVector[][] dop = new PVector[G.length][G[0].length];
//  for (int x = 0; x < img.width; x++) 
//    for (int y = 0; y < img.height; y++) 
//      dop[x][y] = G[x][y].copy();

//  PVector[] neigh = new PVector[8];
//  for (int i = 0; i < neigh.length; i++)
//    neigh[i] = new PVector();

//  for (int x = 1; x < img.width - 1; x++) {
//    for (int y = 1; y < img.height - 1; y++) {
//      set(neigh, x, y);
//      if (!check_dir(x, y, 1, neigh, dop) || !check_dir(x, y, -1, neigh, dop))
//        G[x][y].mult(0);
//    }
//  }
//}

//void set(PVector[] neigh, int x, int y) {
//  neigh[0].set(x - 1, y);
//  neigh[1].set(x - 1, y - 1);
//  neigh[2].set(x, y - 1);
//  neigh[3].set(x + 1, y - 1);
//  neigh[4].set(x + 1, y);
//  neigh[5].set(x + 1, y + 1);
//  neigh[6].set(x, y + 1);
//  neigh[7].set(x - 1, y + 1);
//}

//boolean check_dir(int x, int y, int dir, PVector[] neigh, PVector[][] dop){
//  float a = (dop[x][y].mult(Math.signum(dir))).heading();
//  float mag = dop[x][y].mag();
//  if (a < 0)
//        a += TWO_PI;
//      float diff;
//      if (a != HALF_PI && a != 1.5 * PI)
//        diff = abs(tan(a));
//      else
//        diff = 0;
//      if (diff > 1)
//        diff = 1 / diff;
//      if (diff == 1)
//        diff = 0;
//      int frac = int(degrees(a) / 45);
//      int[] index = new int[2];
//      index[0] = frac;
//      index[1] = (frac + 1) % 8;
//      if (frac % 2 == 1){
//        diff = 1 - diff;
//      }
//      //println(index[0], index[1]);
//      float near = map(diff, 0, 1, dop[int(neigh[index[0]].x)][int(neigh[index[0]].y)].mag(), dop[int(neigh[index[1]].x)][int(neigh[index[1]].y)].mag());
//      return mag > near;
//}


////-1 0//
////-1 -1//
////0 -1//
////1 -1//
////1 0//
////1 1//
////0 1
////-1 1

float[][] kernel(float sigma) {
  int half = 3 * int(sigma);
  int size = 2 * half + 1;  
  float[][] kern = new float[size][size];
  for (int x = - half; x <= half; x++) {
    for (int y = - half; y <= half; y++) {
      float pow = - (x * x + y * y) / (2 * sigma * sigma);
      float k = 1 / (TWO_PI * sigma * sigma);
      kern[x + half][y + half] = k * exp(pow);
    }
  }
  //for (float[] row : kern){
  //  printArray(row);
  //  println();
  //}
  return kern;
}
