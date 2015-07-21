// by dave @ bees & bombs >:)

int[][] result;
float tx, ty;

float ease(float p) 
{
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) 
{
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3);

void setup() 
{
  setup_();
  result = new int[width*height][3];
}

void draw() 
{
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
int numFrames = 90;
float shutterAngle = .45;

/// If TRUE, will write frames to image files
boolean recording = true;

void setup_() 
{
  size(500, 500, P2D);
  smooth(8);
  rectMode(CENTER);
  stroke(92, 123, 147);
  strokeWeight(2);
  strokeCap(SQUARE);
  strokeJoin(BEVEL);
  noFill();
}

float x, y, tt;


int a = 50;
int h_half = round(a/2. * sqrt(3.) * .5);


void Triangle( int x, int y, boolean rightward_pointing, boolean closed) 
{
  beginShape();

  pushMatrix();
  translate(x, y);

  vertex(0, 0);

  if ( rightward_pointing )
    vertex(a, h_half);
  else
    vertex(-a, h_half);

  vertex(0, h_half*2);

  if ( closed )
    endShape(CLOSE);
  else
    endShape();

  popMatrix();
}

void draw_() 
{
  background(255, 255, 255);
  pushMatrix();
  translate(width/2, height/2);


  for ( int x = -5; x <= 5; ++x ) {
    pushMatrix();
    if ( x%2==0 )
      translate(x*a, 0);
    else 
      translate(x*a, -3*h_half);

    for ( int y = -2; y <= 2; ++y ) {
      pushMatrix();
      translate(0, y*6*h_half);

      /** 
       * Hexagon slices:
       *   5 0
       *  4   1
       *   3 2
       */
      //float phase = 1.-tx + 1.;
      float phase;
      if ( tx < .25 )
        phase = -2.;
      else if ( tx > .75 )
        phase = -1.;
      else
        phase = (-sin(tx*PI*2.)/2.-1.5);
        //phase = - (2. - (tx -.25)*2. );
      
      Triangle( 0, 0, true, false);  // 0
      Triangle( int(phase*a), int(phase*h_half), false, true);  // 1
      Triangle( 0, int(phase*2*h_half), true, false);  // 2
      Triangle( 0, int(phase*2*h_half), false, false);  // 3
      Triangle(int(phase*-a), int(phase*h_half), true, true);  // 4
      Triangle( 0, 0, false, false);  // 5

      popMatrix();
    }
    popMatrix();
  }

  /*for ( int y = -10; y <= 10; ++y ) { 
   Line(PI/6.,0.,y*50.);
   Line(-PI/6.,0.,y*50.);
   }*/

  popMatrix();
}

