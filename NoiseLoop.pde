class NoiseLoop {

  float size;
  float min, max;
  float cx, cy;
  
  NoiseLoop(float size ,float min, float max, float cx, float cy) {
    this.size = size;
    this.min = min;
    this.max = max;
    this.cx = cx;
    this.cy = cy;
  }

  float val(float angle, float phase, float freq, float scale) {
    
    float xoff = map(cos(angle+phase)/freq, -1.0, 1.0, this.cx, this.cx + this.size)*scale;
    float yoff = map(sin(angle+phase)/freq, -1.0, 1.0,this.cy, this.cy + this.size)*scale;
    float r = map(noise(xoff, yoff), 0.0, 1.0, this.min, this.max);
    
    return r;
  }
}
