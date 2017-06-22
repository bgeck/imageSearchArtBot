//Global Variables
import http.requests.*;
int imagesToGrab = 2;
String[] rawData = new String[1];
PImage[] sources = new PImage[imagesToGrab];
JSONObject jsonData;
// Get these credentials from Google Image Search API
String googleApiKey = "";
String searchEngineID = "";
int [] widths = new int[sources.length];
int [] heights = new int[sources.length];
float thresholdX;
float thresholdY;
float r;
float g;
float b;

//Search Term
String term = "arjuna";
String searchTerm = term.replace(' ', '+');

void setup() {
  frame.setResizable(true);
  background(0);
  loadImages(searchTerm);
  frame.setSize(min(widths), min(heights));
}

public String sketchRenderer() {
  return P3D;
}

void draw() {
  thresholdX = map(mouseX, 0, width, 1, 254);
  thresholdY = map(mouseY, 0, height, 2, 100);
  println(thresholdX + ", " + thresholdY);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    calculate();
  }
  if (mouseButton == RIGHT) {
    saveFrame();
  }
}

void calculate() {
  for (int i = 0; i < sources.length; i++) {
    sources[i].loadPixels(); 

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {

        int loc = x + y * width;
        if (brightness(sources[i].pixels[loc]  *int(random(2)) ) > thresholdX) {
          r = red(sources[i].pixels[loc]);
          g = green(sources[i].pixels[loc]);
          b = blue(sources[i].pixels[loc]);

          noStroke();
          fill(r, g, b, 50);
          ellipse(x, y, int(random(thresholdY)), int(random(thresholdY)));
        }
      }
    }
  }
}

void loadImages(String searchTerm) {
  GetRequest get = new GetRequest("https://www.googleapis.com/customsearch/v1?cx="+ searchEngineID +"&q="+ searchTerm +"&fileType=jpg&searchType=image&num="+ imagesToGrab +"&key=" + googleApiKey);
  get.send();

  rawData[0] = get.getContent();
  saveStrings("jsonData.json", rawData);
  jsonData = loadJSONObject("jsonData.json");
  println(jsonData);

  JSONArray theItems = jsonData.getJSONArray("items");

  for (int i = 0; i < theItems.size (); i++) {
    JSONObject theCurrentItem = theItems.getJSONObject(i);
    String theImageSource = theCurrentItem.getString("link");
    try {
      PImage theFinalImage = loadImage(theImageSource);
      theFinalImage.resize(int(displayWidth/1.5), 0);
      sources[i] = theFinalImage;
      println(theImageSource);
    }
    catch(Exception e) {
      println("couldn't load");
    }
  }

  for (int i = 0; i < sources.length; i++) {
    widths[i] = sources[i].width; 
    heights[i] = sources[i].height;
  }
}