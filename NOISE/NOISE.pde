boolean output = false;

float noiseFreq =10;
float noiseFreq2 = 15;
float phase = 0.0;
float r;
float c;

float move = 25;
float dot;


float trail;
float color_dec = 25.5;
float t;

float noiseMax;
float circleResolution = 16;

NoiseLoop rNoise;
NoiseLoop cNoise;
NoiseLoop xNoise;
NoiseLoop yNoise;
NoiseLoop dNoise;


void setup() {

  noiseMax = 300;

  frameRate(30);
  noiseSeed(20);
  // Preview
    size(800, 500);
    rNoise = new NoiseLoop(noiseMax, 0, 150, 50, 50);
    smooth(2);
  // Preview <

  // HD Output
    // size(1920, 1080);
    // rNoise = new NoiseLoop(noiseMax, 200, 500, 50, 50);
  // HD Output <

  cNoise = new NoiseLoop(noiseMax, 0, 360, 350, 1055);

  xNoise = new NoiseLoop(noiseMax, -move, move, 500, 200);
  yNoise = new NoiseLoop(noiseMax, -move, move, 200, 200);

  dNoise = new NoiseLoop(noiseMax-200, -1, 5, 275, 300);

  frameRate(60);
}

void draw() {
  
  background(10);
  colorMode(RGB);
  
  // Raster 
  
  noStroke();
  fill(20);
  translate(0, 0);

  for (float y = 0; y < height/20; y++) {
    for (float x = 0; x < width/20; x++) {

      float scale = 0.05;
      noiseDetail(12, 0.6);
      float noise = noise(x*scale, y*scale);
      float d = map(noise, 0.0, 1.0, -1, 5);
      float a = map(noise, 0.0, 1.0, 10, 60);
      //d= dNoise.val(y*x, phase, 0.5, scale);
      //float a = 20;
      fill(200, a);
      //rect(x,y,1,1);
      circle(x*20+10, y*20+10, d);
    }
  }

  // Blob
  
  translate(width/2, height/2);

  noFill();
  strokeWeight(1);
  noiseDetail(1, 0.2);

  int trailLength = 40;

  for (float j = 0.0; j <= trailLength; j++) {

    trail = -j*0.003;

    colorMode(HSB);
    if (j == trailLength) {
      stroke(c-20, 255, 255);
      strokeWeight(2);
      dot = 4;
    } else {
      //stroke(100, 20 + (235/trailLength * j));150+(105/trailLength * j)
      stroke(c, 150+(105/trailLength * j), 50+(205/trailLength * j), 0+(255/trailLength * j));
      strokeWeight(1);
      dot = 2;
    }
    //filter( BLUR, 1 );
    beginShape();
    for (float i = 0; i < TWO_PI+TWO_PI/(circleResolution/2.5); i+=TWO_PI/circleResolution ) {
      c = cNoise.val(i, (phase-trail), noiseFreq, 3);
      r = rNoise.val(i, (phase-trail), noiseFreq, 1)+(4*j);

      float x = r * cos(i);
      float y = r * sin(i);

      x += xNoise.val(t, -trail, noiseFreq2, 1);
      y += yNoise.val(t, -trail, noiseFreq2, 1);

      curveVertex(x, y);
      circle(x, y, dot);
    }
    endShape(CLOSE);
  }

  float phaseIncrement = TWO_PI/(12.0*300);
  t += phaseIncrement;
  phase += phaseIncrement;

  if (output == true) {
    int currentFrame = int(phase/phaseIncrement);
    int frames = int(TWO_PI/phaseIncrement);
    saveFrame("output/noise-500x500-####.png");
    println(phaseIncrement+" / "+phase+" / "+ TWO_PI +" / " + currentFrame + " / "+frames);
    if (phase>=TWO_PI) {
      println("DONE: "+phaseIncrement+" / "+phase+" / "+ TWO_PI +" / " + currentFrame + " / "+frames);
      exit();
    }
  }
}
