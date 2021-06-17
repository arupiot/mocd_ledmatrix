/**
 * MOCD matrix 
 */
 
import processing.sound.*;

int pixelSize=2;
int x = 100;
int h = 20;
int w = 5;
PGraphics pg;
PImage matrixImage;
PFont f;
boolean showMatrix = false;
String audioFileName = "BW_MoCD_Room_Ambience.mp3";
SoundFile soundfile;
boolean showRects = true;
boolean showTestRect = false;

void setup(){
  size(918, 120);
  frameRate(50);
  matrixImage = loadImage("led_matrix_cropped.png"); 
  // create a buffered image for storing the plasma effect
  pg = createGraphics(918, 120);
  colorMode(RGB);
  noSmooth();
  soundfile = new SoundFile(this, audioFileName);
  soundfile.loop();
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);
  textAlign(CENTER, CENTER);
}

void draw()
{
  float  xc = 2000;

  int timeDisplacement = int(frameCount*.5);

  // No need to do this math for every pixel
  float calculation1 = sin( radians(timeDisplacement * 0.06));
  float calculation2 = sin( radians(timeDisplacement * -0.09));
  
  // Output into a buffered image for reuse
  pg.beginDraw();
  pg.loadPixels();

  // Plasma algorithm
  for (int x = 0; x < pg.width; x++, xc += pixelSize)
  {
    float  yc    = 2000;
    float s1 = 128 + 128 * sin(radians(xc) * calculation1 );

    for (int y = 0; y < pg.height; y++, yc += pixelSize)
    {
      float s2 = 128 + 128 * sin(radians(yc) * calculation2 );
      float s3 = 128 + 128 * sin(radians((xc + yc + timeDisplacement * 5) / 2));  
      float s  = (s1+ s2 + s3) / 3;
      //float s = s2;
      //pg.pixels[x+y*pg.width] = color(s, 255 - s / 2.0, 255);
      pg.pixels[x+y*pg.width] = color(s, 255 - s / 2.0, 255);
      //pg.pixels[x+y*pg.width] = color(s, 100, 255);
      //pg.pixels[x+y*pg.width] = color(s, 100, 255);
      //pg.pixels[x+y*pg.width] = color(s, 000, 255);
    }
  }   
  pg.updatePixels();
  pg.endDraw();

  // display the results
  image(pg,0,0,width,height); 

  if (showMatrix == true) {
     tint(255, 127);  // Display at half opacity
     image(matrixImage, 0, 0, width, height);
     tint(255, 127);  // Display at half opacity
  }

  color(0,0,0,255);  
  fill(0,0,0,255);
  if (showTestRect) {
    rect(x,height-h,w,h);  
    text(str(x)+"-"+str(h)+"-"+str(w), width/2, height/2);
  }
  if (showRects) {
    //89 44 3
    rect(89,height-44,3,44);
    //257 44 3
    rect(257,height-44,3,44);
    //398 44 3
    rect(398,height-44,3,44);
    //679 44 3
    rect(679,height-44,3,44);
  }
}

void keyReleased() {
  // save image
  if (key=='s' || key=='S') saveFrame(timestamp()+".png"); 
  if (key=='m' || key=='M') showMatrix = !showMatrix; 
}

void keyPressed() {
  if (key=='r' || key=='R') showRects=!showRects;
  if (key=='t' || key=='T') showTestRect=!showTestRect;
  if (key=='w' || key=='W') w=w+1;
  if (key=='x' || key=='X') w=w-1;
  if (w<=1) w=1;
  if (key == CODED) {
      if (keyCode == UP) {
        h+=1;
        if (h>height) h=height;
      } else if (keyCode == DOWN) {
        h-=1;
        if (h<0) h=0;
      } else if (keyCode == RIGHT) {
        x+=1;
        if (x>width) x = 0;
      }
      else if (keyCode == LEFT) {
        x-=1;
        if (x<0) x = width;
      }
  }
}

String timestamp() {
  //return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
  return  str(year())+"-"+str(month())+"-"+str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(millis());
}
