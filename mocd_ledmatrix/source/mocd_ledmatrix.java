import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class mocd_ledmatrix extends PApplet {

/**
 * MOCD matrix 
 */
 


int pixelSize=2;
PGraphics pg;
PImage matrixImage;
boolean showMatrix = false;
String audioFileName = "BW_MoCD_Room_Ambience.mp3";
SoundFile soundfile;

public void setup(){
  
  frameRate(50);
  matrixImage = loadImage("led_matrix_cropped.png"); 
  // create a buffered image for storing the plasma effect
  pg = createGraphics(918, 120);
  colorMode(RGB);
  
  soundfile = new SoundFile(this, audioFileName);
  soundfile.loop();
}

public void draw()
{
  float  xc = 2000;

  int timeDisplacement = PApplet.parseInt(frameCount*.5f);

  // No need to do this math for every pixel
  float calculation1 = sin( radians(timeDisplacement * 0.06f));
  float calculation2 = sin( radians(timeDisplacement * -0.09f));
  
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
      pg.pixels[x+y*pg.width] = color(s, 255 - s / 2.0f, 255);
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

}

public void keyReleased() {
  // save image
  if (key=='s' || key=='S') saveFrame(timestamp()+".png"); 
  if (key=='m' || key=='M') showMatrix = !showMatrix; 
}

public String timestamp() {
  //return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
  return  str(year())+"-"+str(month())+"-"+str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(millis());
}
  public void settings() {  size(918, 120);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "mocd_ledmatrix" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
