import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.text.*; 


int canvasW = 7680;
int canvasH = 1080;
PGraphics canvas;


// global variables
PFont fontRegular;
float fr = 30;

// offscreen canvases
PGraphics bMap;
PGraphics dMap;
PGraphics flash; 
PGraphics canvasBackground;
PGraphics info;


//var canvasProperties = {
//  width: 1920 * 4,
//  height: 1080 * 4
//};

int canvasPropertiesWidth = 1920 * 4;
int canvasPropertiesHeight =  1080 * 4;

//var infoProperties = {
//  width: 1000,
//  height: 880,
//  x: 6230,
//  y: 120
//};

int infoPropertiesWidth = 1000;
int infoPropertiesHeight = 880;
int infoPropertiesX = 6230;
int infoPropertiesY = 120;

// color variables
int [] cDarkBlue = {1, 6, 25}; // r, g, b
int [] cLightBlue = {0, 60, 91}; // r, g, b
int [] cTurquoise = {65, 217, 242}; // r, g, b
int [] cRed = {230, 5, 14}; // r, g, b

// state variables
float fadeOut = 0;
boolean ready = false;
String phase = "before";

//Table data;
//Table before; 
//Table during;
ArrayList<Tweet> data = new ArrayList<Tweet>();
ArrayList<Tweet> before = new ArrayList<Tweet>();
ArrayList<Tweet> during = new ArrayList<Tweet>();

float timestamp = 0;
int bIndex = 0;
int dIndex = 0;
//var data = (before = during = []);
//var timestamp = (bIndex = dIndex = 0);

// Processing Standard Functions
void settings() 
{
  size(1280, 180, P3D);
  PJOGL.profile=1;
}

void setup() {


  canvas = createGraphics(canvasW, canvasH, P3D);

  // size(7680, 1080,P3D);

  //fontRegular = loadFont("assets/ShareTechMono.ttf");
  fontRegular = createFont("assets/ShareTechMono.ttf", 54);

  textFont(fontRegular);


  // create offscreen canvases
  canvasBackground = createGraphics(width, height, P3D);
  color c1 = color(cLightBlue[0], cLightBlue[1], cLightBlue[2]);
  color c2 = color(cDarkBlue[0], cDarkBlue[1], cDarkBlue[2]);


  createBackground(
    (float)width / 2.0, 
    (float)height / 2.0, 
    (float)width * 1.2f, 
    (float) width * 1.2f, 
    c1, 
    c2
    );


  bMap = createGraphics(canvasPropertiesWidth, canvasPropertiesHeight, P3D);
  bMap.noStroke();
  dMap = createGraphics(canvasPropertiesWidth, canvasPropertiesHeight, P3D);
  dMap.noStroke();
  flash = createGraphics(canvasPropertiesWidth, canvasPropertiesHeight, P3D);
  flash.noStroke();
  info = createGraphics(infoPropertiesWidth, infoPropertiesHeight, P3D);

  infoContent();


  // load csv
  Table csv = loadData("data/natural_disaster_human_mobility_rammasun.csv");

  println(csv);


  // calculate map scale
  MapProperties mapProperties = mapScale(csv);


  // format entries, calculate coordinates, sort entries
  data = formatData(csv, mapProperties);



  // slice data into before/during arrays
  //before = data.slice(39563, 257670); // 2014-07-02 - 2014-07-11
  //during = data.slice(257670, 521008); // 2014-07-12 - 2014-07-21
  // console.log(before, during);
  before = new ArrayList<Tweet>(data.subList(39563, 257670));
  during = new ArrayList<Tweet>(data.subList(257670, 521008));


  frameRate(fr);

  println("before.length " + before.size() );
  println("during.length " + during.size() );


  //ready = false;
  ready = true;
}

void draw() {

  if (!ready) {
    return;
  }



  // clear flash canvas
  flash.beginDraw();
  bMap.beginDraw();
  dMap.beginDraw();

  flash.clear();

  // calculate current time based on frame rate
  float currentTime = (timestamp / fr) * 1000;


  // add dots before catastrophe
  if (phase.equals("before")) {
    Tweet currentTweet = null;

    if (bIndex<before.size()) {
      currentTweet = before.get(bIndex);
    }

    // while (currentTweet != null && currentTweet.timelineMs <= currentTime) {
    while (bIndex < (before.size()-1) && currentTweet.timelineMs <= currentTime) {
      // create "blurry" permanent dots
      bMap.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], 50);
      bMap.ellipse(currentTweet.positionX, currentTweet.positionY, 3, 3);
      bMap.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], 30);
      bMap.ellipse(currentTweet.positionX, currentTweet.positionY, 6, 6);
      bMap.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], 20);
      bMap.ellipse(currentTweet.positionX, currentTweet.positionY, 10, 10);
      bMap.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], 10);
      bMap.ellipse(currentTweet.positionX, currentTweet.positionY, 15, 15);

      // create temporary, flashing points
      flash.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], 75);
      flash.ellipse(currentTweet.positionX, currentTweet.positionY, 20, 20);

      bIndex++;
      currentTweet = before.get(bIndex);
    }
    // end of before array
    if (/*!before[bIndex]*//*currentTweet == null*/bIndex>=(before.size()-1)) {
      phase = "during";
      println(phase);
      // start the recording
      // capturer.start();
    }
  }

  // add dots during catastrophe
  if (phase.equals("during")) {

    //this needs to be reprogrammed to avoid index array out of bounds exception
    //make a do while for example

    Tweet currentTweet = null;

    if (dIndex<during.size()) {
      currentTweet = during.get(dIndex);
    }

    //while (currentTweet != null && currentTweet.timelineMs <= currentTime) {
    while (dIndex < (during.size()-1) && currentTweet.timelineMs <= currentTime) {
      // create "blurry" permanent dots
      dMap.fill(cRed[0], cRed[1], cRed[2], 50);
      dMap.ellipse(currentTweet.positionX, currentTweet.positionY, 3, 3);
      dMap.fill(cRed[0], cRed[1], cRed[2], 30);
      dMap.ellipse(currentTweet.positionX, currentTweet.positionY, 6, 6);
      dMap.fill(cRed[0], cRed[1], cRed[2], 20);
      dMap.ellipse(currentTweet.positionX, currentTweet.positionY, 10, 10);
      dMap.fill(cRed[0], cRed[1], cRed[2], 10);
      dMap.ellipse(currentTweet.positionX, currentTweet.positionY, 15, 15);

      // create temporary, flashing points
      flash.fill(cRed[0], cRed[1], cRed[2], 75);
      flash.ellipse(currentTweet.positionX, currentTweet.positionY, 20, 20);

      dIndex++;
      currentTweet = during.get(dIndex);
    }
    // end of during array
    if (/*!during[dIndex]*//*currentTweet == null*/dIndex>=(during.size()-1)) {
      phase = "end";
      println(phase);
    }
  }

  flash.endDraw();
  bMap.endDraw();
  dMap.endDraw();
  
  
  canvas.beginDraw();
  canvas.background(0);

  // display centecRed background gradient canvas
  canvas.imageMode(CORNER);
  canvas.image(canvasBackground, 0, 0, width, height);

  // display bMap, dMap and flash canvas
  canvas.image(bMap, 1920, 0, 1920 * 3, 1080, 950, 1800, 1920 * 3, 1080);
  canvas.image(dMap, 1920, 0, 1920 * 3, 1080, 950, 1800, 1920 * 3, 1080);
  canvas.image(flash, 1920, 0, 1920 * 3, 1080, 950, 1800, 1920 * 3, 1080);

  // definition figure
  canvas.rectMode(CORNER);
  canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  canvas.strokeWeight(1);
  canvas.stroke(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  canvas.rect(2080, 80, 300, 20);
  canvas.fill(cDarkBlue[0], cDarkBlue[1], cDarkBlue[2], 220);
  canvas.rect(2080, 100, 300, 100);
  canvas.noStroke();

  canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  canvas.ellipse(2110, 130, 20, 20);
  canvas.fill(cRed[0], cRed[1], cRed[2]);
  canvas.ellipse(2110, 170, 20, 20);

  canvas.textSize(20);
  canvas.textAlign(LEFT, TOP);
  canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  canvas.text("tweets before typhoon", 2110 + 20, 118);
  canvas.fill(cRed[0], cRed[1], cRed[2]);
  canvas.text("tweets during typhoon", 2110 + 20, 158);

  // ending overlay
  if (phase.equals("end")) {
    canvas.rectMode(CORNER);
    canvas.fill(cDarkBlue[0], cDarkBlue[1], cDarkBlue[2], fadeOut);
    canvas.rect(0, 0, width, height);
    canvas.rectMode(CENTER);
    canvas.textSize(72);
    canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2], fadeOut);
    canvas.textAlign(CENTER, CENTER);
    canvas.text("play  again", width / 2, height / 2);

    if (fadeOut <= 220) {
      fadeOut += 2;
    } else {
      // capturer.stop();
      // capturer.save();
    }
  }

  // display info table
  canvas.imageMode(CORNER);
  canvas.image(info, infoPropertiesX, infoPropertiesY);

  // display bMap and dMap mini maps
  canvas.imageMode(CENTER);
  canvas.image(bMap, 960, 540, 1920 * 0.75, 1080 * 0.75, 0, 0, 1920 * 4, 1080 * 4);
  canvas.image(dMap, 960, 540, 1920 * 0.75, 1080 * 0.75, 0, 0, 1920 * 4, 1080 * 4);

  // mini map city label
  canvas.textAlign(LEFT, TOP);
  canvas.textSize(30);
  canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  canvas.text("Manila, Philippines", 460, 265);

  // detail area indicator rectangle
  canvas.rectMode(CORNER);
  canvas.noFill();
  canvas.strokeWeight(4);
  if (phase.equals("before")) {
    canvas.stroke(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  } else {
    canvas.stroke(cRed[0], cRed[1], cRed[2]);
  }
  if (!phase.equals("end")) {
    canvas.rect(420, 470, 1080, 202);
  }
  canvas.noStroke();

  // get current number of tweets, format with thousand seperator
  //TODO 
  //var noTweets = (bIndex + dIndex)
  //  .toString()
  //  .replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
  int noTweets =  bIndex +  dIndex;

  // get current date and time (timestamp)
  String displayDate;
  if (phase.equals("before")) {
    displayDate = before.get(bIndex).dateTime;
  } else if (phase.equals("during")) {
    displayDate = during.get(dIndex).dateTime;
  } else {
    // last date
    displayDate = during.get(during.size() - 1).dateTime;
  }

  // split timestamp into date and time
  //displayDate = displayDate.split(" ");
  String [] tokens = split(displayDate, " ");
  //displayDateDay = displayDate[0];
  String displayDateDay = tokens[0];
  //displayDateTime = displayDate[1];
  String displayDateTime = tokens[1];

  // display tweet counter, date and time
  canvas.fill(cDarkBlue[0], cDarkBlue[1], cDarkBlue[2], 220);
  canvas.strokeWeight(1);
  canvas.rectMode(CORNER);
  if (phase.equals("before")) {
    canvas.stroke(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  } else {
    canvas.stroke(cRed[0], cRed[1], cRed[2]);
  }
  canvas.rect(infoPropertiesX, infoPropertiesY + 700, info.width / 2, 135);
  canvas.rect(
    infoPropertiesX + info.width / 2, 
    infoPropertiesX + 700, 
    info.width / 2, 
    135
    );
  if (phase.equals("before")) {
    canvas.fill(cTurquoise[0], cTurquoise[1], cTurquoise[2]);
  } else {
    canvas.fill(cRed[0], cRed[1], cRed[2]);
  }
  canvas.noStroke();
  canvas.rect(infoPropertiesX, infoPropertiesY + 700, info.width, 20);
  canvas.textSize(30);
  canvas.textAlign(LEFT, BASELINE);
  canvas.text("Nº tweets", infoPropertiesX + 20, infoPropertiesY + 810);
  canvas.text(
    "Date", 
    infoPropertiesX + infoPropertiesWidth / 2 + 20, 
    infoPropertiesY + 810
    );
  canvas.textSize(38);
  canvas.textAlign(RIGHT, BASELINE);
  canvas.text(
    noTweets, 
    infoPropertiesX + infoPropertiesWidth / 2 - 20, 
    infoPropertiesY + 810
    );
  canvas.text(
    displayDateTime, 
    infoPropertiesX + infoPropertiesWidth - 20, 
    infoPropertiesY + 770
    );
  canvas.text(
    displayDateDay, 
    infoPropertiesX + infoPropertiesWidth - 20, 
    infoPropertiesY + 810
    );

canvas.endDraw();
image(canvas,0,0, width, height);
  // playback speed
  timestamp = timestamp + 15000;

  // check frame rate
  // if (frameCount % fr == 0) {
  //   console.log(frameRate());
  // }

  // selecte canvas to capture
  // capturer.capture(document.getElementById("defaultCanvas0"));
}

void createBackground(float x, float y, float w, float h, color inner, color outer) {

  canvasBackground.beginDraw();
  canvasBackground.background(0, 255, 0);
  canvasBackground.endDraw();
  ////BEGINCOMMENT
  // println("createBackground 1 ");
  // // create radial gradient
  // canvasBackground.noStroke();
  //  println("createBackground 2 ");
  // canvasBackground.fill(0);
  //  println("createBackground 3 ");
  // for (int i = max((int)w, (int)h); i > 0; i--) {
  //    println("createBackground i " + i);
  //   float step = i / max(w, h);
  //    println("createBackground i step " + step);
  //    color col = lerpColor(inner, outer, step);
  //    println("createBackground i col " + col);
  //   canvasBackground.fill(col);
  //    println("createBackground i ellipse ");
  //   //canvasBackground.ellipse(x, y, step * w, step * h);
  //    canvasBackground.ellipse(0, 0, 100,100);
  //    println("createBackground i end ");
  // }
  //println("createBackground 4 ");
  // // create grid
  // canvasBackground.noFill();
  //  println("createBackground 5 ");
  // canvasBackground.stroke(cTurquoise[0], cTurquoise[1], cTurquoise[2], 10);
  //  println("createBackground 6 ");
  // for (float xx = 0; xx < width; xx += width / 128.0) {
  //    println("createBackground xx " + xx);
  //   canvasBackground.line(xx, 0, xx, height);
  // }
  // for (float yy = 0; yy < height; yy += height / 18.0) {
  //   println("createBackground yy " + yy);
  //   canvasBackground.line(0, yy, width, yy);
  // }

  // //ENDCOMMENT
  println("createBackground end ");
}

ArrayList<Tweet> formatData(Table csv, MapProperties mapProperties) {
  //var startTime = Date.parse("2014-07-02 03:00:32");

  ArrayList<Tweet> tweets = new ArrayList<Tweet>();

  Date startTime = new Date(2014, 
    7, 
    2, 
    3, 
    0, 
    32);

  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
  for (TableRow row : csv.rows()) {

    float lon = row.getFloat("longitude.anon");
    float lat = row.getFloat("latitude");
    String timeString  = row.getString("time");
    Date timestamp = null;
    try { 
      timestamp = df.parse(timeString);
    } 
    catch (ParseException excpt) { 
      excpt.printStackTrace();
    } 
    float timelineMs = timestamp.getTime() - startTime.getTime();
    float positionX =  (lon - mapProperties.mapCenterX) *
      mapProperties.mapScale +
      canvasPropertiesWidth / 2;
    float positionY = (lat - mapProperties.mapCenterY) * mapProperties.mapScale +
      canvasPropertiesHeight / 2;

    Tweet t = new Tweet(lon, lat, timeString, timestamp, timelineMs, positionX, positionY);
    tweets.add(t);
  }

  // sort entries by date/time
  // data = data.sort(compare);
  Collections.sort(tweets);

  return tweets;
}

void infoContent() {
  info.beginDraw();
  info.rectMode(CORNER);
  info.noStroke();
  info.fill(1, 6, 25, 220);
  info.rect(0, 0, info.width, 660);
  info.fill(65, 217, 242);
  info.rect(0, 0, info.width, 20);
  info.rect(0, 0, 1, 660);
  info.rect(info.width - 1, 0, 1, 660);
  info.rect(0, 660, info.width, 1);

  info.textFont(fontRegular);

  String description =
    "Typhoon Rammasun, known in the Philippines as Typhoon Glenda, was one of the only two Category 5 super typhoons on record in the South China Sea, with the other one being Pamela in 1954.\n\nRammasun had destructive impacts across the Philippines, South China, and Vietnam in July 2014. Though initially forecast to make landfall in Cagayan Valley, the storm followed a more westerly path and was later forecast to make landfall in the Bicol Region and then pass through Bataan and Zambales before brushing past Metro Manila.\n\nAt least 90% of the total residents of Metro Manila lost power, as poles were toppled and lines downed. Strong winds from the storm destroyed several homes in the slums. Most of the capital area was also completely shut down.";

  info.fill(65, 217, 242);
  info.textSize(54);
  info.text("Rammasun", 20, 75);
  info.textSize(30);
  info.text("god of thunder", 270, 75);
  info.rect(0, 95, info.width, 1);

  info.textAlign(LEFT, TOP);
  info.textSize(20);
  info.text("Formed:", 20, 109);
  info.text("July 9, 2014, brushed past Metro Manila July, 15th", 200, 109);

  info.rect(0, 140, info.width, 1);
  info.text("Highest winds:", 20, 152);
  info.text("10-minute sustained – 165 km/h (105 mph)", 200, 152);
  info.text("1-minute sustained – 260 km/h (160 mph)", 200, 177);

  info.rect(0, 208, info.width, 1);
  info.text("Fatalities:", 20, 220);
  info.text("222 total", 200, 220);
  info.rect(0, 251, info.width, 1);
  info.text("Damage:", 20, 263);
  info.text("$8.03 billion (2014 USD)", 200, 263);

  info.rect(0, 294, info.width, 1);
  info.text(description, 20, 326, info.width - 40, 400);
  info.endDraw();
}

//function compare(a, b) {
//  var dateA = a.timestamp;
//  var dateB = b.timestamp;

//  var comparison = 0;

//  if (dateA > dateB) {
//    comparison = 1;
//  } else if (dateA < dateB) {
//    comparison = -1;
//  }
//  return comparison;
//}

MapProperties mapScale(Table data) {
  // get longitude center
  //var minLong = d3.min(data, d => d["longitude.anon"]);
  float minLong = min(data, "longitude.anon");
  //var maxLong = d3.max(data, d => d["longitude.anon"]);
  float maxLong = max(data, "longitude.anon");
  float mapWidth = maxLong - minLong;
  float mapCenterX = (maxLong + minLong) / 2;

  // get latitude center
  //var minLat = d3.min(data, d => d.latitude);
  float minLat = min(data, "latitude");
  //var maxLat = d3.max(data, d => d.latitude);
  float maxLat = max(data, "latitude");
  float mapHeight = maxLat - minLat;
  float mapCenterY = (maxLat + minLat) / 2;

  // define map scale dimension (longitude or latitude)
  float mapScale = min(
    (canvasPropertiesWidth / 4 / mapWidth) * 3, 
    (canvasPropertiesHeight / mapHeight) * 3
    );

  return new MapProperties(mapCenterX, mapCenterY, mapScale);

  //return {
  //  mapCenterX: mapCenterX,
  //  mapCenterY: mapCenterY,
  //  mapScale: mapScale
  //};
}

void mousePressed() {
  // reset if sketch is finished
  if (phase.equals("end")) {
    phase = "before";
    timestamp = 0;
    bIndex = 0;
    dIndex = 0;
    fadeOut = 0;
    bMap.clear();
    dMap.clear();
  }
}

class MapProperties {

  float mapCenterX;
  float mapCenterY;
  float mapScale;

  MapProperties(float x, float y, float s) {
    this.mapCenterX  = x;
    this.mapCenterY = y;
    this.mapScale = s;
  }
}


class Tweet  implements Comparable<Tweet> {
  float lon;
  float lat;
  String timeString;
  String dateTime;
  Date timestamp;
  float timelineMs;
  float positionX;
  float positionY;

  Tweet(float lon, float lat, String timeString, Date timestamp, float timelineMs, float positionX, float positionY) {
    this.lon = lon;
    this.lat = lat;
    this.timeString = timeString;
    this.dateTime = timeString;
    this.timestamp = timestamp;
    this.timelineMs = timelineMs;
    this.positionX = positionX;
    this.positionY = positionY;
  }

  @Override
    public int compareTo(Tweet o) {
    return this.timestamp.compareTo(o.timestamp);
  }
}
