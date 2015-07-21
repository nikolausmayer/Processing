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

PShader toonShader;

/// If TRUE, will write frames to image files
boolean recording = false;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  noStroke();
  //strokeWeight(0.05);
  fill(255,255,255);
  
  toonShader = loadShader("ToonFrag.glsl", "ToonVert.glsl");
  toonShader.set("fraction", 1.0);
  
  ortho();
}



void draw_() {
  
  //tx = pow(tx,2.)/(pow(tx,2.)+pow(1.-tx,2.));
  /*if ( tx <= 0.025 )       // 0 to 0.025 -> 0
    tx = 0.;
  else if ( tx <= 0.225 )  // 0.025 to 0.225 -> 0 to 0.25 
    tx = .25 * pow((tx-.025)*5,2.)/(pow((tx-.025)*5,2.)+pow(1.-(tx-.025)*5,2.));
  else if ( tx <= 0.275 )  // 0.025 to 0.275 -> 0.25
    tx = 0.25;
  else if ( tx <= 0.475 )  // 0.275 to 0.475 -> 0.25 to .5
    tx = .25 + .25  * pow((tx-.275)*5,2.)/(pow((tx-.275)*5,2.)+pow(1.-(tx-.275)*5,2.));
  else if ( tx <= 0.525 )  // 0.475 to 0.525 -> 0.5
    tx = .5;
  else if ( tx <= 0.725 )  // 0.525 to 0.725 -> 0.5 to 0.75
    tx = .5 + .25 * pow((tx-.525)*5,2.)/(pow((tx-.525)*5,2.)+pow(1.-(tx-.525)*5,2.));
  else if ( tx <= 0.775 )  // 0.725 to 0.775 -> 0.75
    tx = .75;
  else if ( tx <= 0.975 )  // 0.775 to 0.975 -> 0.75 to 1
    tx = .75 + .25 * pow((tx-.775)*5,2.)/(pow((tx-.775)*5,2.)+pow(1.-(tx-.775)*5,2.));
  else                     // 0.975 to 1 -> 1
    tx = 1.;*/
  //ty = tx;
  
  //shader(toonShader);
  
  background(255);
  //directionalLight(255, 255, 255, 1,1,-1);
  //ambientLight(102, 102, 102);
  pushMatrix();
  translate(width/2, height/2);
  scale(50.);
  int SIZE = 30;
  
  
  /*rotateX(2*ty*-PI/3 + PI/3); 
  rotateY(2*tx*PI/3 - PI/3);*/
  rotateX(-ty*4*PI/2. + PI/2.); 
  rotateY(tx*2*PI - PI);
  
  //float explode = 2.*ty;
  float explode = 4 * (-cos(ty*2*PI)/2. + .5);
  
  //fill(255,0,255);
  pushMatrix();
  translate(explode,explode,explode);
  beginShape(TRIANGLES);
    fill(215,0,215);
    vertex( 1., 1., 1.);
    vertex( 1., 1.,-1.);
    vertex( 1.,-1., 1.);
    
    fill(255,0,255);
    vertex( 1., 1., 1.);
    vertex( 1.,-1., 1.);
    vertex(-1., 1., 1.);
    
    fill(235,0,235);
    vertex( 1., 1., 1.);
    vertex(-1., 1., 1.);
    vertex( 1., 1.,-1.);
    
    fill(195,0,195);
    vertex( 1.,-1., 1.);
    vertex( 1., 1.,-1.);
    vertex(-1., 1., 1.);
  endShape();
  popMatrix();
  
  //fill(255,0,0);
  pushMatrix();
  translate(-explode,-explode,explode);
  beginShape(TRIANGLES);
    fill(255,0,0);
    vertex(-1., 1., 1.);
    vertex( 1.,-1., 1.);
    vertex(-1.,-1., 1.);
    
    fill(195,0,0);
    vertex(-1., 1., 1.);
    vertex(-1.,-1., 1.);
    vertex(-1.,-1.,-1.);
    
    fill(175,0,0);
    vertex( 1.,-1., 1.);
    vertex(-1.,-1.,-1.);
    vertex(-1.,-1., 1.);
    
    fill(155,0,0);
    vertex(-1., 1., 1.);
    vertex(-1.,-1.,-1.);
    vertex( 1.,-1., 1.);
  endShape();
  popMatrix();
  
  //fill(0,255,0);
  pushMatrix();
  translate(explode,-explode,-explode);
  beginShape(TRIANGLES);
    fill(0,175,0);
    vertex( 1.,-1., 1.);
    vertex( 1.,-1.,-1.);
    vertex(-1.,-1.,-1.);
    
    fill(0,235,0);
    vertex( 1.,-1., 1.);
    vertex( 1., 1.,-1.);
    vertex( 1.,-1.,-1.);
    
    fill(0,215,0);
    vertex( 1.,-1., 1.);
    vertex(-1.,-1.,-1.);
    vertex( 1., 1.,-1.);
    
    fill(0,135,0);
    vertex( 1.,-1.,-1.);
    vertex( 1., 1.,-1.);
    vertex(-1.,-1.,-1.);
  endShape();
  popMatrix();
  
  fill(0,0,255);
  pushMatrix();
  translate(-explode,explode,-explode);
  beginShape(TRIANGLES);
    fill(0,0,255);
    vertex(-1., 1., 1.);
    vertex( 1., 1.,-1.);
    vertex(-1.,-1.,-1.);
    
    fill(0,0,225);
    vertex(-1., 1., 1.);
    vertex(-1., 1.,-1.);
    vertex( 1., 1.,-1.);
    
    fill(0,0,195);
    vertex(-1., 1., 1.);
    vertex(-1.,-1.,-1.);
    vertex(-1., 1.,-1.);
    
    fill(0,0,135);
    vertex(-1., 1.,-1.);
    vertex(-1.,-1.,-1.);
    vertex( 1., 1.,-1.);
  endShape();
  popMatrix();
  
  
  /// Hidden fifth tetraeder
  //fill(255,255,255);
  pushMatrix();
  beginShape(TRIANGLES);
    fill(225,225,225);
    vertex(-1., 1., 1.);
    vertex( 1.,-1., 1.);
    vertex(-1.,-1.,-1.);
    
    fill(245,245,245);
    vertex(-1., 1., 1.);
    vertex( 1., 1.,-1.);
    vertex( 1.,-1., 1.);
    
    fill(215,215,215);
    vertex(-1., 1., 1.);
    vertex(-1.,-1.,-1.);
    vertex( 1., 1.,-1.);
    
    fill(195,195,195);
    vertex( 1., 1.,-1.);
    vertex(-1.,-1.,-1.);
    vertex( 1.,-1., 1.);
  endShape();
  popMatrix();
    
   
   
  
  popMatrix();
}
