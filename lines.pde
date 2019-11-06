class liner{
  int[][] points;
  int[][] copy;
  ArrayList<ArrayList<PVector>> lines;
  //int eps = 5;
  float theta = 0.6;
  float delta = 6;
  
  
  liner(PImage img){
    img.loadPixels();
    points = new int[img.width][img.height];
    copy = new int[img.width][img.height];
    lines = new ArrayList<ArrayList<PVector>>();
    for (int x = 0; x < img.width; x++)
      for (int y = 0; y < img.height; y++){
        if (color(img.pixels[ind(x, y)]) == color(0)){
          points[x][y] = 0;
          copy[x][y] = 0;
        }
        else{
          points[x][y] = 1;
          copy[x][y] = 1;
        }
      }
  }
  
  void align(PVector[][] G){
    for (int x = 0; x < points.length; x++){
      for (int y = 0; y < points[0].length; y++){
        if (points[x][y] == 1){
          ArrayList<PVector> stack = new ArrayList<PVector>();
          int x_ = x;
          int y_ = y;
          int eps;
          boolean more = true;
          while (more){
            points[x_][y_] = -1;
            more = false;
            stack.add(new PVector(x_, y_)); 
            eps = eps_calc(x_, y_);
            for (int i = min(points.length, x_ + eps + 1) - 1; i >= max(0, x_ - eps)  && !more; i--){
              for (int j = min(points[0].length, y_ + eps + 1) - 1; j >= max(0, y_ - eps) && !more; j--){
                if (points[i][j] == 1){
                  if (PVector.angleBetween(G[x_][y_], G[i][j]) <= theta){
                    more = true;
                    x_ = i;
                    y_ = j;
                  }
                }
              }
            }
          }
          lines.add(stack);
          //println("newline");
        }
      }
    }
    
    for (int i = lines.size() - 1; i >= 0; i--){
      float prevx = lines.get(i).get(0).x;
      float prevy = lines.get(i).get(0).y;
      float d = 0;
      for (int j = 1; j < lines.get(i).size(); j++){
        d += dist(prevx, prevy, lines.get(i).get(j).x, lines.get(i).get(j).y);
        prevx = lines.get(i).get(j).x;
        prevy = lines.get(i).get(j).y;
      }
      if (d < delta)
        lines.remove(i);
    }
    println("done lining");
  }
  
  int eps_calc(int x, int y){
    int count = 0;
    for (int i = max(0, x - 1); i < min(points.length, x + 2); i++){
      for (int j = max(0, y - 1); j < min(points[0].length, y + 2); j++){
        if (copy[i][j] == 1)
          count++;
      }
    }
    if (count < 1)
      return 15;
    else if (count < 2)
      return 10;
    else
       return 2;
  }
  
  
}
