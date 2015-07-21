// by dave @ bees & bombs

int[][] result;
float t;

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
    t = mouseX*1.0/width;
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
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

int samplesPerFrame = 32;
int numFrames = 96;
float shutterAngle = .6;

boolean recording = false;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  rectMode(CENTER);
  stroke(32);
  noFill();
  colorMode(HSB);
}

float x, y, z, tt;
int N = 360;
float R = 120, r = 60;
float th, ph;

void draw_() {
  background(32);
  pushMatrix();
  translate(width/2, height/2 - 20);
  rotateX(-PI*.2);
  beginShape();
  for (int i=0; i<N; i++) {
    th = PI*i/N + TWO_PI*t;
    ph = 12*th + TWO_PI*t;
    x = (R+r*cos(ph))*cos(th);
    y = r*sin(ph);
    z = (R+r*cos(ph))*sin(th);
    stroke((th+TWO_PI*t)*255/TWO_PI % 255, 255, 255);
    strokeWeight(map(cos(TWO_PI*i/(N-1)), 1, -1, 0, 6));
    vertex(x, y, z);
  }
  endShape();
  popMatrix();
}

