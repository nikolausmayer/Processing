 // by dave @ bees & bombs >:)

int[][] result;
float tx,ty;

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
int numFrames = 120;
float shutterAngle = .45;

/// If TRUE, will write frames to image files
boolean recording = false;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  rectMode(CENTER);
  noStroke();
  noFill();
  
  ortho();
}

float x, y, tt;
int N = 12;
float sp = 39;

void draw_cube(int size) {
    fill(254,229,60);
    beginShape();
    vertex(0,0,0);
    vertex(size,0,0);
    vertex(size,size,0);
    vertex(0,size,0);
    endShape();
    
    fill(229,50,40);
    beginShape();
    vertex(0,0,0);
    vertex(0,0,-size);
    vertex(0,size,-size);
    vertex(0,size,0);
    endShape();
    
    fill(10,100,255);
    beginShape();
    vertex(0,0,0);
    vertex(0,0,-size);
    vertex(size,0,-size);
    vertex(size,0,0);
    endShape();
}

void draw_() {
  background(32);
  pushMatrix();
  translate(width/2, height/2);
  int SIZE = 30;
  
  pushMatrix();
  /*rotateX(2*ty*-PI/3 + PI/3); 
  rotateY(2*tx*PI/3 - PI/3);*/
  rotateX(-PI/3.5); 
  rotateY(PI/4);
    
  for ( int i=-18; i<=18; i++ ) {
    pushMatrix();
    if ( i % 2 == 0 )
      translate(-i/2*SIZE, 0, i/2*SIZE);
    else
      translate(0, 0, i*SIZE);
      
    
    for ( int j=-15; j<=15; j++ ) {
      pushMatrix();
      translate(j*SIZE, sin(-2*PI*tx+i/2.)*(15-abs(j))/15*SIZE*1.5, j*SIZE);
      draw_cube(SIZE);
      popMatrix();
    }
    
    popMatrix();
  }
  
  popMatrix();
  
  

  


  popMatrix();
}
