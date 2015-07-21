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
int numFrames = 60;
float shutterAngle = .45;

/// If TRUE, will write frames to image files
boolean recording = false;

void setup_() {
  size(500, 500, P2D);
  smooth(8);
  rectMode(CENTER);
  //noStroke();
  //noFill();

  //ortho();
}

float x, y, tt;


void Triangle(int l, int h) {
  beginShape();
  vertex(l, 0);
  vertex(0, -h);
  vertex(-l, 0);
  endShape(CLOSE);
}

/// Ease between 0 and 1
float _ease( float in )
{
  return pow(in, 2) / ( pow(in, 2) + pow(1.-in, 2));
}

void draw_() {
  background(255,255,255);
  pushMatrix();
  translate(width/2, height/2);
  int l = 80;
  int h = 120; //int(l * sqrt(3.));
  translate(0, h/2.);
  int spacing_y = 1;
  int spacing_x = 1;
  int _x_shift = int((7./12.)*l);
  int x_shift = int(_ease(tx)*_x_shift);
  //int triangles_per_side_x = (width /2)/(2*l + spacing_x) + 1;
  //int triangles_per_side_y = (height/2)/(h   + spacing_y) + 3;

  {
    pushMatrix();
    
    for ( int y = -2; y <= 2; ++y ) {
      pushMatrix();
      translate(0,y*(h+spacing_y));
      if ( y%2!=0 )
        translate(x_shift+l,0);
      
      for ( int x = -2; x <= 1; ++x ) {
        /// Draw one group of three triangles
        pushMatrix();
        translate(x*(2*x_shift+2*l),0);
        
        /// Solid triangles
        for ( int i = -1; i <= 1; ++i ) {
          pushMatrix();
          translate(i*x_shift,0); 
          stroke(92, 123, 147);
          fill(92, 123, 147);
          strokeWeight(1);
          Triangle(l, h);
          popMatrix();
        }
        /// Triangle outlines
        for ( int i = -1; i <= 1; ++i ) {
          pushMatrix();
          translate(i*x_shift,0);
          stroke(255, 255, 255);
          noFill();
          strokeWeight(2);
          Triangle(l, h);
          popMatrix();
        }
        popMatrix();
      }
  
      popMatrix();
    }
    popMatrix();
  }


  popMatrix();
}

