PImage Im, Io;
int type, angle, traslation_X, traslation_Y;
float scale, shear_V, shear_H;
boolean forwarding;
void settings() {
  Im = loadImage("lenna.png");
  size(Im.width, Im.height+160);
}
void setup() {
  Io = Im.copy();
  type = 0;
  forwarding = true;
  init();
}

void draw() {
  background(0);
  image(Im, 0, 0);
  textSize(20);
  text("Press 'c' to change transformation", 0, Im.height+25);
  text("Press 'v' to change mapping [ "  + (forwarding ? "Forwarding" : "Inverse") + " ]", 0, Im.height+50);
  text("Press 's' to save the current state as origin", 0, Im.height+75);
  text("Press 'r' to revert to the origin", 0, Im.height+100);
  text("Press 'R' to reset the image", 0, Im.height+125);
  String mode_status = "";
  if (type==0) {
    mode_status = "mode: Rotation (Degree = "  + angle + ")" +  "  [ + | - ]";
  } else if (type==1) {
    mode_status = "mode: Scaling (" + scale +  ")" +  "  [ + | - ]";
  } else if (type==2) {
    mode_status = "mode: Traslation (X: "+ traslation_X +  ")" +  "  [ + | - ] (Y: "+ traslation_Y +  ")" +  "  [ * | / ]";
  } else if (type==3) {
    mode_status = "mode: Shear (Vertical) (Degree = "  + shear_V + ")" +  "  [ + | - ]";
  } else if (type==4) {
    mode_status = "mode: Shear (Horizontal) (Degree = "  + shear_H + ")" +  "  [ + | - ]";
  }
  text(mode_status, 0, Im.height+150);
}

void keyPressed() {
  if (key=='c' || key=='C') {
    type = (type+1)%5;
  } else if (key == 's' || key=='S') {
    Io = Im;
    init();
  } else if (key == 'r') {
    Im = Io;
    init();
  } else if (key=='R') {
    Io = loadImage("lenna.png");
    Im = Io;
    init();
  } else {
    if (key=='v' || key=='V') {
      forwarding = !forwarding;
    } else if (type == 0 && (key == '+' || key == '-')) {
      if (key=='+')
        angle++;
      else
        angle--;
    } else if (type == 1 && (key == '+' || key == '-')) {
      if (key=='+')
        scale+=0.2;
      else
        scale-=0.2;
    } else if (type == 2 && (key == '+' || key == '-'|| key == '*'|| key == '/')) {
      switch(key) {
      case '+':
        traslation_X++;
        break;
      case '-':
        traslation_X--;
        break;
      case '*':
        traslation_Y++;
        break;
      case '/':
        traslation_Y--;
        break;
      }
    } else if (type == 3 && (key == '+' || key == '-')) {
      if (key=='+')
        shear_V+=0.05;
      else
        shear_V-=0.05;
    } else if (type == 4 && (key == '+' || key == '-')) {
      if (key=='+')
        shear_H+=0.05;
      else
        shear_H-=0.05;
    }
    transform();
  }
}

void transform() {
  if (type==0) {
    if (forwarding)
      Im = rotateForwarding(Io);
    else
      Im = rotateInverse(Io);
  } else if (type==1) {
    if (forwarding)
      Im = scaleForwarding(Io);
    else
      Im = scaleInverse(Io);
  } else if (type==2) {
    if (forwarding)
      Im = traslationForwarding(Io);
    else
      Im = traslationInverse(Io);
  } else if (type==3) {
    if (forwarding)
      Im = shearVerForwarding(Io);
    else
      Im = shearVerInverse(Io);
  } else if (type==4) {
    if (forwarding)
      Im = shearHorForwarding(Io);
    else
      Im = shearHorInverse(Io);
  }
}

PImage scaleForwarding(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float new_x, new_y, tmp_x, tmp_y;
  for (int original_x = 0; original_x<I.width; original_x++) {
    for (int original_y = 0; original_y<I.height; original_y++) {
      tmp_x = original_x-I.width/2;
      tmp_y = original_y-I.height/2;
      new_x = tmp_x*scale+I.width/2;
      new_y = tmp_y*scale+I.height/2;
      R.set((int)new_x, (int)new_y, I.get(original_x, original_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage scaleInverse(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float tmp_x, tmp_y, original_x, original_y;
  for (int new_x = 0; new_x<I.width; new_x++) {
    for (int new_y = 0; new_y<I.height; new_y++) {
      tmp_x = new_x-I.width/2;
      tmp_y = new_y-I.height/2;
      original_x = tmp_x/scale+I.width/2;
      original_y = tmp_y/scale+I.width/2;
      R.set(new_x, new_y, I.get(int(original_x), int(original_y)));
    }
  }
  R.updatePixels();
  return R;
}

PImage rotateForwarding(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  float theta = radians(angle);
  R.loadPixels();
  float new_x, new_y, tmp_x, tmp_y;
  for (int original_x = 0; original_x<I.width; original_x++) {
    for (int original_y = 0; original_y<I.height; original_y++) {
      tmp_x = original_x-I.width/2;
      tmp_y = original_y-I.height/2;
      new_x = tmp_x*cos(theta)-tmp_y*sin(theta)+I.width/2;
      new_y = tmp_x*sin(theta)+tmp_y*cos(theta)+I.height/2;
      R.set((int)new_x, (int)new_y, I.get(original_x, original_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage rotateInverse(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  float theta = radians(angle);
  R.loadPixels();
  float tmp_x, tmp_y, original_x, original_y;
  for (int new_x = 0; new_x<I.width; new_x++) {
    for (int new_y = 0; new_y<I.height; new_y++) {
      tmp_x = new_x-I.width/2;
      tmp_y = new_y-I.height/2;
      original_x = tmp_x*cos(theta)+tmp_y*sin(theta)+I.width/2;
      original_y = -tmp_x*sin(theta)+tmp_y*cos(theta)+I.width/2;
      R.set(new_x, new_y, I.get(int(original_x), int(original_y)));
    }
  }
  R.updatePixels();
  return R;
}

PImage traslationForwarding(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float new_x, new_y, tmp_x, tmp_y;
  for (int original_x = 0; original_x<I.width; original_x++) {
    for (int original_y = 0; original_y<I.height; original_y++) {
      tmp_x = original_x-I.width/2;
      tmp_y = original_y-I.height/2;
      new_x = tmp_x+traslation_X+I.width/2;
      new_y = tmp_y+traslation_Y+I.height/2;
      R.set((int)new_x, (int)new_y, I.get(original_x, original_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage traslationInverse(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float tmp_x, tmp_y, original_x, original_y;
  for (int new_x = 0; new_x<I.width; new_x++) {
    for (int new_y = 0; new_y<I.height; new_y++) {
      tmp_x = new_x-I.width/2;
      tmp_y = new_y-I.height/2;
      original_x = tmp_x-traslation_X+I.width/2;
      original_y = tmp_y-traslation_Y+I.width/2;
      R.set(new_x, new_y, I.get(int(original_x), int(original_y)));
    }
  }
  R.updatePixels();
  return R;
}

PImage shearVerForwarding(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float new_x, tmp_x;
  for (int original_x = 0; original_x<I.width; original_x++) {
    for (int original_y = 0; original_y<I.height; original_y++) {
      tmp_x = original_x-I.width/2;
      new_x = tmp_x+shear_V*(original_y-I.height/2)+I.width/2;
      R.set((int)new_x, original_y, I.get(original_x, original_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage shearVerInverse(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float tmp_x, original_x;
  for (int new_x = 0; new_x<I.width; new_x++) {
    for (int new_y = 0; new_y<I.height; new_y++) {
      tmp_x = new_x-I.width/2;
      original_x = tmp_x-shear_V*(new_y-I.height/2)+I.width/2;
      R.set(new_x, new_y, I.get(int(original_x), new_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage shearHorForwarding(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float new_y, tmp_y;
  for (int original_x = 0; original_x<I.width; original_x++) {
    for (int original_y = 0; original_y<I.height; original_y++) {
      tmp_y = original_y-I.height/2;
      new_y = tmp_y+shear_H*(original_x-I.width/2)+I.width/2;
      R.set(original_x, (int)new_y, I.get(original_x, original_y));
    }
  }
  R.updatePixels();
  return R;
}

PImage shearHorInverse(PImage I) {
  PImage R = createImage(I.width, I.height, RGB);
  R.loadPixels();
  float tmp_y, original_y;
  for (int new_x = 0; new_x<I.width; new_x++) {
    for (int new_y = 0; new_y<I.height; new_y++) {
      tmp_y = new_y-I.height/2;
      original_y = tmp_y-shear_H*(new_x-I.width/2)+I.width/2;
      R.set(new_x, new_y, I.get(new_x, int(original_y)));
    }
  }
  R.updatePixels();
  return R;
}

void init() {
  angle = 0;
  scale = 1;
  traslation_X = 0;
  traslation_Y = 0;
  shear_V = 0;
  shear_H = 0;
}
