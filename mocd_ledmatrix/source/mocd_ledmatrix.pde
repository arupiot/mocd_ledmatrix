/**
 * MOCD matrix 
 */
 
import processing.sound.*;

int pixelSize=2;
PGraphics pg;
PImage matrixImage;
boolean showMatrix = false;
String audioFileName = "BW_MoCD_Room_Ambience.mp3";
SoundFile soundfile;

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

}

void keyReleased() {
  // save image
  if (key=='s' || key=='S') saveFrame(timestamp()+".png"); 
  if (key=='m' || key=='M') showMatrix = !showMatrix; 
}

String timestamp() {
  //return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
  return  str(year())+"-"+str(month())+"-"+str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(millis());
}
