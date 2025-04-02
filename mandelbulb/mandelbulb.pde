import peasy.*;

// dimensions of a cube
int DIM = 100;
PeasyCam cam;
ArrayList<PVector> mandelbulb = new ArrayList<PVector>();

void setup() {
  size(600, 600, P3D);
  // automatically centers the object to the window
  // and use the mouse to look around, rotate, zoom out and in
  // of the 3D object
  // 500 = how close or far away from the object the camera is
  cam = new PeasyCam(this, 500);
  
  // calculate the mandelbulb once
  // for every i, j, and k in the dimensions of the cube,
  // create a z, y, and z point in 3 dimensional space
  for(int i = 0; i < DIM; i++) {
    for(int j = 0; j < DIM; j++) {
      
      boolean edge = false;
      
      for(int k = 0; k < DIM; k++) {
        float x = map(i, 0, DIM, -1, 1);
        float y = map(j, 0, DIM, -1, 1);
        float z = map(k, 0, DIM, -1, 1);
        
        PVector zeta = new PVector(0, 0, 0);
        // n is the power to which we are setting the formula to
        // we can play with it to change the look
        // formula is z = z^n + c
        int n = 6;
        int max_iterations = 20;
        int iteration = 0;
        
        while(true) {
          Spherical spherical_zeta = spherical(zeta.x, zeta.y, zeta.z);
          float newx = pow(spherical_zeta.r, n) * sin(spherical_zeta.theta*n) * cos(spherical_zeta.phi*n);
          float newy = pow(spherical_zeta.r, n) * sin(spherical_zeta.theta*n) * sin(spherical_zeta.phi*n);
          float newz = pow(spherical_zeta.r, n) * cos(spherical_zeta.theta*n);
          
          zeta.x = newx + x;
          zeta.y = newy + y;
          zeta.z = newz + z;
          
          iteration++;
          
          // r is the distance from the center
          // can contain the mandelbulb by adjusting this
          if (spherical_zeta.r > 16) {
            if(edge) {
              edge = false;
            }
            break;
          }
          
          if(iteration > max_iterations) {
            if(!edge) {
              edge = true;
              mandelbulb.add(new PVector(x*100, y*100, z*100));
            }
            break;
          }
        }
      }
    }
  }
}

// creating a class to hold a spherical coordinate instead
// of a PVector, which uses x, y, z, and is confusing as we
// are calculating to get away from the cartesian triplex
class Spherical {
  float r, theta, phi;
  
  Spherical(float r, float theta, float phi) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
  }
}

// convert from cartesian to polar coordinates
Spherical spherical(float x, float y, float z) {
  // convert triplex coordinates to spherical coordinates
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x + y*y), z);
  float phi = atan2(y, x);
  
  return new Spherical(r, theta, phi);
}

void draw() {
  background(0);
  
  // actually drawing the array list of PVectors for the mandelbulb
  for(PVector v : mandelbulb) {
    float redStroke = map(v.x, -100, 100, 0, 255);
    float greenStroke = map(v.y, -100, 100, 0, 255);
    float blueStroke = map(v.z, -100, 100, 0, 255);
    stroke(int(redStroke), int(greenStroke), int(blueStroke));
    point(v.x, v.y, v.z);
  }
}
