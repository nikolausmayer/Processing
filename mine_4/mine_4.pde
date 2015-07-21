// by dave @ bees & bombs >:)

int[][] result;
float tx, ty;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3);

void setup() {
  setup_();
  result = new int[width*height][3];
}

void draw() {

  if (!recording) {
    tx = mouseX*1.0/width;
    ty = mouseY*1.0/height;
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    for (int sa=0; sa<samplesPerFrame; sa++) {
      tx = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 |
        int(result[i][0]*1.0/samplesPerFrame) << 16 |
        int(result[i][1]*1.0/samplesPerFrame) << 8 |
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("f###.gif");
    if (frameCount==numFrames)
      exit();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 8;
int numFrames = 30;
float shutterAngle = .45;

/// If TRUE, will write frames to image files
boolean recording = true;

void setup_() {
  size(500, 500, P2D);
  smooth(8);
  rectMode(CENTER);
  //noStroke();
  //noFill();
  stroke(255, 255, 255);
  fill(255, 255, 255);

  //ortho();
}

float x, y, tt;


void draw_() {
  background(92, 123, 147);
  pushMatrix();
  translate(width/2, height/2);
  int l = 20;
  int h = 30; //int(l * sqrt(3.));
  int spacing_y = 2;
  int spacing_x = 2;
  int triangles_per_side_x = (width /2)/(2*l + spacing_x) + 1;
  int triangles_per_side_y = (height/2)/(h   + spacing_y) + 3;

  for ( int x = -triangles_per_side_x; x <= triangles_per_side_x; ++x ) {
    pushMatrix();
    translate(x*2*l + x*spacing_x, 0);
    for ( int y = -triangles_per_side_y; y <= triangles_per_side_y; ++y ) {
      pushMatrix();
      if (x%2!=0) {
        rotate(PI);
        translate(0, h);
      }
      translate(0, y*h + y*spacing_y + (tx*(h+spacing_y)));

      beginShape();
      vertex(l, 0);
      vertex(0, -h);
      vertex(-l, 0);
      endShape(CLOSE);

      popMatrix();
    }
    popMatrix();
  }


  popMatrix();
}

