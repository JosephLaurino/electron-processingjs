boolean autoplay = false;
boolean showsFPS = false;
boolean clearsBackground = true;
boolean windEnabled = true;
PFont font;
float rotRange = 10;
float rotDecay = 1.1;
float sizeDecay = 0.7;
float lengthDecay = 0.91;
int levelMax = 8;
int leafLevel = 2;
float leafChance = 0.3;
float branchHue = 50;
float leafHue = 150;
float leafSat = 100;
float mouseWind = 0;
float mouseWindV = 0;
float startLength;
float startSize;
color trunkColor;
color bgColor;
int time = 0;
float lengthRand = 1.0;
float bloomWidthRatio = 0.6;
float bloomSizeAverage = 15;

float mDamp = 0.00002;
float wDamp = 0.003;
float mFriction = 0.98;

float flowerChance = 0.1;
color flowerColor;
float flowerWidth = 10;
float flowerHeight = 20;

Node node;

void setup()
{
  size(940, 540);
  colorMode(HSB);
  font = createFont("Helvetica", 24);
  ellipseMode(CENTER);

  randomize();
  reset();
}

void draw()
{
  if (autoplay)
  {
    time++;
    if (time > 600)
    {
      time = 0;
      randomize();
      reset();
    }
  }

  float dx = mouseX - pmouseX;
  mouseWindV += dx * mDamp;
  mouseWindV += (0 - mouseWind) * wDamp;
  mouseWindV *= mFriction;
  mouseWind += mouseWindV;

  if (clearsBackground) background(bgColor);
  if (showsFPS) displayFPS();
  translate(width/2, height);
  node.draw();
}

void reset()
{
  background(bgColor);
  node = new Node(startLength, startSize, rotRange, 0);
}

void randomize()
{
  randomizeBackground();
  randomizeColor();
  rotRange = random(20, 60);
  rotDecay = random(0.9, 1.1);
  startLength = random(20, 80);
  startSize = random(3, 20);
  lengthRand = random(0.0, 0.2);
  leafChance = random(0.3, 0.9);
  sizeDecay = random(0.6, 0.7);
  lengthDecay = map(startLength, 20, 80, 1.1, 0.85);
  leafLevel = random(0, 4);
  bloomWidthRatio = random(0.01, 0.9);
  bloomSizeAverage = random(10, 40);

  mDamp = 0.00002;
  wDamp = 0.005;
  mFriction = 0.96;

  flowerWidth = random(5, 15);
  flowerHeight = random(10, 30);
  flowerChance = 0.1;
}

void randomizeBackground()
{
    bgColor = color(random(255), random(0, 100), 255);
}

void randomizeColor()
{
  branchHue = random(0, 255);
  leafHue = random(0, 255);
  leafSat = random(0, 255);
  flowerColor = color(random(255), random(0, 255), 255);
  if (node) node.randomizeColor();
}

void displayFPS()
{
  textFont(font, 18);
  fill(150);
  String output = "fps=";
  output += (int) frameRate;
  text(output, 10, 30);
}

void keyPressed()
{
  if (key == 'f') showsFPS = !showsFPS;
  if (key == 'a') autoplay = !autoplay;
  if (key == 'p') clearsBackground = !clearsBackground;
  if (key == 'w') windEnabled = !windEnabled;
  if (key == 'r') reset();
  if (key == 'b') randomizeBackground();
  if (key == 'c') randomizeColor();
}

void mousePressed()
{
  time = 0;
  randomize();
  reset();
}
class Node
{
  float len;
  float size;
  float rot;
  int level;
  float s = 0;
  float windFactor = 1.0;
  boolean doesBloom;
  color branchColor;
  float bloomSize;
  color leafColor;
  float leafRot;
  float leafScale = 0.0;
  int leafDelay;
  boolean doesFlower;
  float flowerScale = 0.0;
  float flowerScaleT = 1.0;
  float flowerBright = 255;
  int flowerDelay;

  Node n1;
  Node n2;

  Node(float _len, float _size, float _rotRange, int _level)
  {
    len = _len * (1 + random(-lengthRand, lengthRand));
    size = _size;
    level = _level;
    rot = radians(random(-_rotRange, _rotRange));
    if (level < leafLevel) rot *= 0.3;
    if (level == 0 ) rot = 0;
    windFactor = random(0.2, 1);
    doesBloom = false;
    if (level >= leafLevel && random(1) < leafChance) doesBloom = true;
    bloomSize = random(bloomSizeAverage*0.7, bloomSizeAverage*1.3);
    leafRot = radians(random(-180, 180));
    flowerScaleT = random(0.8, 1.2);
    flowerDelay = round(random(200, 250));
    leafDelay = round(random(50, 150));
    randomizeColor();

    if (random(1) < flowerChance) doesFlower = true;

    float rr = _rotRange * rotDecay;

    if (level < levelMax)
    {
      n1 = new Node(len*lengthDecay, size*sizeDecay, rr, level+1);
      n2 = new Node(len*lengthDecay, size*sizeDecay, rr, level+1);
    }
  }

  void draw()
  {
    strokeWeight(size);
    s += (1.0 - s) / (15 + (level*5));
    scale(s);

    pushMatrix();

    if (level >= leafLevel) stroke(branchColor);
    else stroke(0);
    float rotOffset = sin( noise( (float)millis() * 0.000006  * (level*1) ) * 100 );
    if (!windEnabled) rotOffset = 0;
    rotate(rot + (rotOffset * 0.1 + mouseWind) * windFactor);
    line(0, 0, 0, -len);
    translate(0, -len);

    // draw leaves
    if (doesBloom)
    {
      if (leafDelay < 0)
      {
        leafScale += (1.0 - leafScale) * 0.05;
        fill(leafColor);
        noStroke();
        pushMatrix();
        scale(leafScale);
        rotate(leafRot);
        translate(0, -bloomSize/2);
        ellipse(0, 0, bloomSize*bloomWidthRatio, bloomSize);
        popMatrix();
      }
      else
      {
        leafDelay--;
      }
    }

    // draw flowers
    if (doesFlower && level > levelMax-3)
    {
      if (flowerDelay < 0)
      {
        pushMatrix();
        flowerScale += (flowerScaleT - flowerScale) * 0.1;
        scale(flowerScale);
        rotate(flowerScale*3);
        noStroke();
        fill(hue(flowerColor), saturation(flowerColor), flowerBright);
        ellipse(0, 0, flowerWidth, flowerHeight);
        rotate(radians(360/3));
        ellipse(0, 0, flowerWidth, flowerHeight);
        rotate(radians(360/3));
        ellipse(0, 0, flowerWidth, flowerHeight);
        fill(branchColor);
        ellipse(0, 0, 5, 5);
        popMatrix();
      } else
      {
        flowerDelay--;
      }
    }

    pushMatrix();
    if (n1) n1.draw();
    popMatrix();

    pushMatrix();
    if (n2) n2.draw();
    popMatrix();

    popMatrix();
  }

  void randomizeColor()
  {
    branchColor = color(branchHue, random(170, 255), random(100, 200));
    leafColor = color(leafHue, leafSat, random(100, 255));
    flowerBright = random(200, 255);

    if (n1) n1.randomizeColor();
    if (n2) n2.randomizeColor();
  }
}
