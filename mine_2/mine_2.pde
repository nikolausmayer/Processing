// by dave @ bees & bombs >:)

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

int samplesPerFrame = 8;
int numFrames = 120;
float shutterAngle = .45;
float cameraZ = ((500./2.0) / tan(PI*60.0/360.0)); 

/// If TRUE, will write frames to image files
boolean recording = false;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  rectMode(CENTER);
  noStroke();
  fill(204);
}

void draw_() {
  background(32);

  ambientLight(128, 128, 128);
  directionalLight(128, 128, 128, 1, 1, -1); 
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);

  //translate(0.,0.,t*100.);

  perspective(PI/3.0, 1., cameraZ/10.0, cameraZ*10.0);
  //camera(250., 250., 250. / tan(PI*30.0 / 180.0), 250., 250., 0, 0, 1, 0);
  //ortho();

  pushMatrix();


  translate(width/2, height/2);
  rotateX(PI/3); 
  rotateZ(-PI/3);
  /*rotateX(-PI/5); 
   rotateY(PI/4);*/

  //printProjection();
  frustum(-.1, .1, -.1, .1, .1, 1000.);
  //printProjection();
  box(160);

  /*pushMatrix();
   translate(80,80,80);
   box(20);
   popMatrix();*/

  popMatrix();
}

