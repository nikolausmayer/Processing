  // by dave @ bees & bombs >:)

int[][] result;
float tx,ty;


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
int numFrames = 240;
float shutterAngle = .45;

/// If TRUE, will write frames to image files
boolean recording = false;

PImage tex;
//PImage eyeTex;

float separation = 0.;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  noStroke();
  //strokeWeight(0.05);

  tex = loadImage("img/tex2.png");
  
  ortho();
}


/// Catch scroll wheel event
void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  separation = constrain(separation+e*.01, 0., 1.);
}


/*void Base() {
  beginShape(TRIANGLES);
    texture(tex);

    vertex(0, 0, 0,  483, 0);
    vertex(1, 1, 0,  483, 177);
    vertex(3, 0, 0,  849, 277);

    vertex(1, 1, 0,  483, 177);
    vertex(3, 1, 0,  733, 360);
    vertex(3, 0, 0,  849, 277);

    vertex(0, 0, 0,  483, 0);
    vertex(0, 3, 0,  111, 277);
    vertex(1, 1, 0,  483, 177);

    vertex(0, 3, 0,  111, 277);
    vertex(1, 3, 0,  233, 360);
    vertex(1, 1, 0,  483, 177);
  endShape();
}


void LeftLeg() {
  beginShape(TRIANGLES);
    texture(tex);

    vertex(0, 3, 0,  0, 1834);
    vertex(0, 3, -2, 0, 2116);
    vertex(1, 3, 0,  121, 1916);

    vertex(0, 3, -2, 0, 2116);
    vertex(1, 3, -1, 121, 2061);
    vertex(1, 3, 0,  121, 1916);

    vertex(0, 3, -2, 0, 2116);
    vertex(3, 3, -2, 371, 2387);
    vertex(1, 3, -1,  121, 2061);

    vertex(3, 3, -2, 371, 2387);
    vertex(3, 3, -1, 371, 2244);
    vertex(1, 3, -1,  121, 2061);
  endShape();
}*/

void BOX(float x, float y, float z)
{
  pushMatrix();
  translate(x,y,z);
  box(1);
  popMatrix();
}


void draw_() {
  
  background(255,255,255);
  ambientLight(100,100,100);
  directionalLight(255,255,255,-1,1,1);
  directionalLight(255,255,255,1,-1,-1);


  pushMatrix();
  translate(width/2, height/2);
  scale(50);

  rotateX(-ty*4*PI/2. + PI/2.); 
  rotateY(tx*2*PI - PI);

  translate(-1*(1+separation),-1*(1+separation),-.5*(1+separation));



  /// Lower arc
  BOX(0,0,0);
  BOX(1*(1+separation),0,0);
  BOX(2*(1+separation),0,0);
  BOX(0,1*(1+separation),0);
  BOX(0,2*(1+separation),0);

  /// Upper arc
  BOX(2*(1+separation),0,1*(1+separation));
  BOX(2*(1+separation),1*(1+separation),1*(1+separation));
  BOX(2*(1+separation),2*(1+separation),1*(1+separation));
  BOX(1*(1+separation),2*(1+separation),1*(1+separation));
  BOX(0,2*(1+separation),1*(1+separation));
  
  
  //beginShape();
  //texture(eyeTex);
  //endShape();

  popMatrix();
}
