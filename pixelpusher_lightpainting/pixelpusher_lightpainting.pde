
import javax.swing.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

boolean ready_to_go = true;

TestObserver testObserver;
PImage myImage;

int xpos = 0;

void setup() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  registry.setFrameLimit(1000);
  frameRate(1000);

  // get a file to draw.
  
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } catch (Exception e) { 
    e.printStackTrace();  
  } 

  // see if it's an image 
  // (better to write a function and check for all supported extensions) 
  // load the image using the given file path
  myImage = loadImage("31280014-All-seeing-eye-symbol-vector-illustration-Stock-Vector.jpg");
  size(myImage.width, myImage.height);
}

void draw() {
  xpos++;
  image(myImage,0,0);

  // scrape for the strips
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    // for only one strip:
    Strip strip1=strips.get(0);
    Strip strip2=strips.get(1);
    int stripy=0;
    float ystep = height / strip1.getLength();
    if (ystep == 0) {
      ystep = 1;
    }
    
    for (float y=0; y<height; y+=ystep) {
      int pixel = get(xpos,int(y));
      strip1.setPixel(pixel, stripy++);
      strip2.setPixel(pixel, stripy++);
    }
  }
  if (xpos == width)
    xpos = 0;
}

void stop()
{
  super.stop();
}
