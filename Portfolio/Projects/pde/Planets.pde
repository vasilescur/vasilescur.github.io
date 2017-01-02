// Global Settings
final color BACKGROUND = #F2FBFF;
final color DEFAULT_COLOR = #000000;
final int TARGET_FRAMERATE = 100000;
final float MASS_RADIUS_RATIO = 0.1;  // RADIUS = Mass * Ratio
final int MIN_RADIUS = 5;
final float SIM_SPEED = 3;

// Constants
final float G = 0.5;  // TODO: Replace with actual constant (6.67 E -11); see java.math.bigDecimal (?)

// Global variables
int fr;  // Framerate buffer

void setup()
{
  size(800, 600);
  background(BACKGROUND);
  smooth(2);
  frameRate(TARGET_FRAMERATE);
  
}

Planet[] planets = { new Planet(10,     5,   #FF8103,   new PVector(300, 300),   new PVector(30,   -3),     new PVector(0, 0)),
                     new Planet(500,    30,  #0EFF03,   new PVector(500, 500),   new PVector(-3,  -3),     new PVector(0, 0)),
                     new Planet(100000, 10,  #000000,   new PVector(250, 250),   new PVector(-0,    0),     new PVector(0, 0))  };

void draw()
{
  // Calculations
  for (int i = 0; i < planets.length; i++)
  {
    for (int p = 0; p < planets.length; p++)
    {
      if (p != i)
      {
        planets[i].acceleration.x += -(planets[p].mass * (planets[i].position.x - planets[p].position.x)) / ( planets[i].position.dist(planets[p].position) * 
                                                                                                             planets[i].position.dist(planets[p].position) * 
                                                                                                             planets[i].position.dist(planets[p].position)   );
                                                                                                             
        planets[i].acceleration.y += -(planets[p].mass * (planets[i].position.y - planets[p].position.y)) / ( planets[i].position.dist(planets[p].position) * 
                                                                                                             planets[i].position.dist(planets[p].position) * 
                                                                                                             planets[i].position.dist(planets[p].position)   );
      }
    }
    
    planets[i].acceleration.x = planets[i].acceleration.x * G;
    planets[i].acceleration.y = planets[i].acceleration.y * G;
    
    planets[i].velocity.x += planets[i].acceleration.x / (frameRate / SIM_SPEED);
    planets[i].velocity.y += planets[i].acceleration.y / (frameRate / SIM_SPEED);
    
    planets[i].position.x += planets[i].velocity.x / (frameRate / SIM_SPEED);
    planets[i].position.y += planets[i].velocity.y / (frameRate / SIM_SPEED);
  }
  
  
  background(BACKGROUND);
  for (int i = 0; i < planets.length; i++)
  {
    planets[i].render();
  }
  
  pushStyle();
  fill(#ffffff);
  rect(5, 5, 105, 25);
  fill(0);
  text("Framerate: " + fr, 10, 20);
  popStyle();
  
  if (frameCount % 10 == 0)
  {
    fr = round(frameRate);
  }
}

class Planet
{
  // Constructor
  Planet(float massIN, int radiusIN, color planetColorIN, PVector positionIN, PVector velocityIN, PVector accelerationIN)
  {
    mass = massIN;
    radius = radiusIN == 0 ? max(round(mass / MASS_RADIUS_RATIO), MIN_RADIUS) : radiusIN;  // Use radiusIN = 0 to specify auto-sizing
    planetColor = planetColorIN == 0 ? DEFAULT_COLOR : planetColorIN;  // Use color = 0 to specify auto-color
    position.set(positionIN.x, positionIN.y);
    velocity.set(velocityIN.x, velocityIN.y);
    acceleration.set(accelerationIN.x, accelerationIN.y);
  }
  
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  
  float mass = 0;  
  int radius = 0;
  color planetColor = 0;
  
  // Draw the planet to the screen
  public void render()
  {
    // Backup style
    pushStyle(); 
    
    fill(planetColor);
    // Darken the stroke color by 40 from the fill color (or bottom out at black)
    stroke(color(max(0, red(planetColor) - 40), max(0, green(planetColor) - 40), max(0, blue(planetColor) - 40)));
    strokeWeight(3);
    
    // Draw the planet
    ellipse(position.x, position.y, radius, radius);
    
    // Restore style
    popStyle();
  }  
}


// Implements utilities for rapid swapping of drawing style.  
color tempFillColor;
color tempStrokeColor;
float tempStrokeWeight;

public void popStyle()  // Restore the style from backup
{
  fill(tempFillColor);
  stroke(tempStrokeColor);
  strokeWeight(tempStrokeWeight);
}
   
public void pushStyle()  // Backup the current style
{
  tempFillColor = g.fillColor;
  tempStrokeColor = g.strokeColor;
  tempStrokeWeight = g.strokeWeight;
}