import java.awt.Robot;

//color pallette
color black = #000000;  //oak planks
color white = #FFFFFF;  //empty space
color dullBlue = #7092BE;  //mossy bricks

//textures
PImage mossyStone;
PImage oakPlanks;

//Map variables
int gridSize;
PImage map;

//Robot for mouse control
Robot rbt;

//camera variables
float eyex, eyey, eyez;
float focusx, focusy, focusz; 
float upx, upy, upz;

boolean wkey, akey, skey, dkey;

//rotation variable
float leftRightAngle;
float upDownAngle;

void setup() {
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  oakPlanks = loadImage("Oak_Planks.png");
  textureMode(NORMAL);
  //noCursor();
  try {
    rbt = new Robot(); 
  }
  catch(Exception e) {
    e.printStackTrace();  
  }
  size(displayWidth, displayHeight, P3D); 
  
  eyex = width/2;
  eyey = 9*height/11;
  eyez = height/2;
  
  focusx = eyex;
  focusy = eyey;
  focusz = eyez - 100;
  
  upx = 0;
  upy = 1;
  upz = 0;
  
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);
  
  pointLight(255, 255, 255, eyex, eyey, eyez);
  
  camera(eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz);
  
  move();
  drawAxis();
  drawFloor(-2000, 2000, height, gridSize);               //floor
  drawFloor(-2000, 2000, height - gridSize*4, gridSize);  //ceiling
  drawMap();
}

void drawMap() {
  for(int x = 0; x < map.width; x++) {
    for(int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if(c == dullBlue || c == black) {
        for(int i = 1; i < 4; i++) 
          texturedCube(x*gridSize - 2000, height-gridSize*i, y*gridSize - 2000, mossyStone, gridSize);
      }
    }
  }
}

//void drawInterface() {
//  stroke(255, 0, 0);
//  strokeWeight(5);
//  line(width/2 - 15, height/2, width/2 + 15, height/2);
//  line(width/2, height/2 - 15, width/2, height/2 + 15);
//}

void drawAxis() {
  stroke(255,0,0);
  strokeWeight(1);
  line(0,0,0, 1000,0,0); //x axis
  line(0,0,0, 0,1000,0); //y axis
  line(0,0,0, 0,0,1000); //z axis
}

void drawFloor(int floorStart, int floorEnd, int floorHeight, int floorSpacing) {
  stroke(255);
  strokeWeight(3);
  for(int i = floorStart; i < floorEnd; i += floorSpacing) 
    for(int f = floorStart; f < floorEnd; f += floorSpacing) 
      texturedCube(i, floorHeight, f, oakPlanks, floorSpacing);
  
  //for(int i = floorStart; i < floorEnd; i += floorSpacing) {
  //  line(i, floorHeight, floorStart, i, floorHeight, floorEnd);
  //  line(floorStart, floorHeight, i, floorEnd, floorHeight, i);
  //}
  //line(width/2 -100, height, -1000, width/2 -100, height, 1000);
  //line(width/2 +100, height, -1000, width/2 +100, height, 1000);
}

void move() {
  
  pushMatrix();
  translate(focusx, focusy, focusz);
  stroke(255, 0, 0);
  sphere(0.5);
  popMatrix();
  
  if(akey) {
    eyex -= cos(leftRightAngle + PI/2)*10;
    eyez -= sin(leftRightAngle + PI/2)*10;
  }
  
  if(dkey) {
    eyex += cos(leftRightAngle + PI/2)*10;
    eyez += sin(leftRightAngle + PI/2)*10;
  }
  
  if(wkey && canMoveForward()) {
    eyex += cos(leftRightAngle)*10;
    eyez += sin(leftRightAngle)*10;
  }
  
  if(skey) {
    eyex -= cos(leftRightAngle)*10;
    eyez -= sin(leftRightAngle)*10;
  }
  
  focusx = eyex + cos(leftRightAngle)*300;
  focusy = eyey + tan(upDownAngle)*300;
  focusz = eyez + sin(leftRightAngle)*300;
  
  leftRightAngle += (mouseX - pmouseX)*0.01;
  upDownAngle += (mouseY - pmouseY)*0.01;
  if(upDownAngle > PI/2.5) upDownAngle = PI/2.5;
  if(upDownAngle < -PI/2.5) upDownAngle = -PI/2.5;
  
  if(mouseX > width-2) rbt.mouseMove(3, mouseY);
  if(mouseX < 2) rbt.mouseMove(width-3, mouseY);
  
  if(abs(mouseX - pmouseX) < width - 10) leftRightAngle += (mouseX - pmouseX)*0.01;
  upDownAngle += (mouseY - pmouseY)*0.01;
}

boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  float leftx, lefty, leftz;
  float rightx, righty, rightz;
  int mapx, mapy;
  fwdx = eyex + cos(leftRightAngle)*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle)*200;
  
  mapx = int(fwdx + 2000) / gridSize;
  mapy = int(fwdz + 2000) / gridSize;
  
  if(map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}
