import processing.sound.*;

import java.util.*; 


String[] fnames = {"shrek.jpg", "land.jpg", "owl.jpg", "bridge.jpg", "test1.jpg", 
  "test2.jpg", "lisa.jpg", "tree.jpg", "aaa.png", "hog.jpg", 
  "butter.jpg", "car.jpg", "panda.jpg", "test3.jpeg"};

PImage img, res;
detector d;
int countl, countp, per = 0;
liner l;
float prx, pry;

int num = int(random(fnames.length));
String fname;

PrintWriter output;

SoundFile sound;

void setup() {
  size(500, 500);
  surface.setResizable(true);
  selectInput("Select a file to process:", "fileSelected");
  //sound = new SoundFile(this, "undertale.mp3");
}

void fileSelected(File selection) {
  if (selection == null) {
    //fname = "input/" + fnames[num];
    exit();
  } else {
    //println("User selected " + selection.getAbsolutePath().lastIndexOf('/'));
    fname = selection.getAbsolutePath();
  }

  img = loadImage(fname);
  println(img.width);

  surface.setSize(img.width, img.height);
  surface.setLocation(displayWidth / 2 - width / 2, displayHeight / 2 - height / 2);

  background(255);
  //img.filter(GRAY);

  String name, resol;
  name = fname.substring(fname.lastIndexOf('/') + 1, fname.indexOf('.'));
  resol = fname.substring(fname.lastIndexOf('.') + 1);

  d = new detector(fname);
  res = d.detect().copy();

  res.save("results/" + name + "_edges." + resol);

  println("done edging");
  background(0);

  l = new liner(res);
  l.align(d.G);
  Collections.shuffle(l.lines);


  countl = 0;
  countp = 0;
  prx = l.lines.get(0).get(0).x;
  pry = l.lines.get(0).get(0).y;

  output = createWriter("lines/" + name + ".txt");
  output.println("total lines: " + str(l.lines.size()));
  int cl = 1;
  for (ArrayList<PVector> line : l.lines) {
    output.println(str(cl) + ") line size: " + str(line.size()));
    int cp = 1;
    for (PVector point : line) {
      output.println("  " + str(cp) + ") x: " + str(int(point.x)) + "  y: " + str(int(point.y)));
      cp++;
    }
    cl++;
  }
  output.close();
  
   background(0);
}

void draw() {
  draw1();
}

void draw1() {
  if (img != null && res != null && l != null){
    //if (!sound.isPlaying())
    //  sound.play();
    for (int iter = 0; iter < 20 && countl < l.lines.size(); iter++) {
      if (iter == 0 && countl == 0 && countp == 0)
        //image(img, 0, 0);
        background(0);
      stroke(255);
      if (countl < l.lines.size() - 1) {
        if (countp < l.lines.get(countl).size() - 1) {
          countp++;
          line(prx, pry, l.lines.get(countl).get(countp).x, l.lines.get(countl).get(countp).y);
          prx = l.lines.get(countl).get(countp).x;
          pry = l.lines.get(countl).get(countp).y;
        } else {
          countp = 0;
          countl++;
          prx = l.lines.get(countl).get(0).x;
          pry = l.lines.get(countl).get(0).y;
        }
      } else {
        println("done drawing");
        countl++;
        noLoop();
      }
    }
  }
}

void draw2() {
  if (img != null && res != null) {
    //if (!sound.isPlaying())
    //  sound.play();
    if (per <= width) {
      image(img, 0, 0);
      image(res.get(0, 0, per, height), 0, 0);
      per++;
      delay(25);
    } else {
      println("done drawing");
      noLoop();
    }
  }
}
