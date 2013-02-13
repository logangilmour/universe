Cell[][] buf;
Cell[][] old;

int tThresh = 100000;
float grav=1000;
int tension = 100;

void setup(){
size(400,400);
 buf = new Cell[width][height];
 old = new Cell[width][height];
 for(int i=0; i<width;i++){
   for(int j=0; j<height;j++){
     old[i][j] = new Cell();
     buf[i][j] = new Cell();
     if(random(0,1)>0.9)buf[i][j].mass=(int)random(100,1000);
     if(random(0,1)>0.5)buf[i][j].charge=-1;
  }
}

//buf[100][100].mass=100;
//buf[100][101].mass=100;
//buf[101][100].mass=100;
///buf[101][101].mass=100;
//buf[100][100].xv=-10;
//buf[100][101].xv=10;
//buf[101][100].xv=10;
///buf[101][101].xv=100;

//buf[100][110].mass=1000;
//buf[100][110].yv=400;

buf[20][20].mass=10;
 frameRate(30);
}


  int mod(int num,int mod){
    return ((num%mod)+mod)%mod;
  }
void draw(){
    loadPixels();  
// Loop through every pixel
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      pixels[i+(j*width)]=color(old[i][j].getColour());
    }
  }
// When we are finished dealing with pixels
updatePixels();
text("grav: "+old[mouseX][mouseY].gravity, 15, 30);

step(1);


}

void step(int steps){
  for(int s=0; s<steps; s++){
    for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
            buf[i][j].clone(old[i][j]);
    }
  }
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      buf[i][j].calc(old[i][mod(j-1,height)],
             old[mod(i+1,width)][j],
             old[i][mod(j+1,height)],
             old[mod(i-1,width)][j]);
    }
  }
}
}

class Cell{
  int mass=0;
  int charge=0;
  int gravity=0;
  int xv=0;
  int yv=0;
  int xt=0;
  int yt=0;
  int dir=0;
  
  
  int getColour(){
//    if(mass==0){return 0;}
  //  return 255;
    //return int(map(mass,0,1000000,128,255));
    if(mass>0)return 0;
    return int(map(gravity,0,pow(2,mouseX),10,255));
  }

  public void calc(Cell N,Cell E,Cell S, Cell W){
    if(this.dir!=0){
      this.clear();
    }
    if(N.dir==3){
      this.app(N);
    }
    if(S.dir==1){
      this.app(S);
    }
    if(E.dir==4){
      this.app(E);
    }
    if(W.dir==2){
      this.app(W);
    }
    
    this.gravity=((N.gravity+E.gravity+S.gravity+W.gravity)+(this.mass+this.charge))/4;
    this.gravity-=this.gravity/tension;
    this.xv+=(this.mass==0)?0:((E.gravity-W.gravity)*grav/(this.mass+this.charge)); //fix these for photons
    this.yv+=(this.mass==0)?0:((S.gravity-N.gravity)*grav/(this.mass+this.charge));
    this.xt+=this.xv;
    this.yt+=this.yv;
    
    boolean xturn=false;
    boolean yturn=false;
    if(abs(xt)>tThresh && abs(yt)>tThresh){
      if(random(0,1)>0.5){
        xturn=true;
      }else{
        yturn=true;
      }
    }else{
      xturn=true;
      yturn=true;
    }
    if(xturn){
    if(this.xt>tThresh){
      dir=2;
      this.xt-=tThresh;
    }else if(this.xt*-1>tThresh){
      dir=4;
      this.xt+=tThresh;
    }
    }
    if(yturn){
    if(this.yt>tThresh){
      dir=3;
      this.yt-=tThresh;
    }else if(this.yt*-1>tThresh){
      dir=1;
      this.yt+=tThresh;
    }
    }
    
  }
  
  public void clear(){
    this.xv=0;
    this.yv=0;
    this.xt=0;
    this.yt=0;
    this.dir=0; 
    this.mass=0;
  }
  
  public void app(Cell cell){
    this.mass+=cell.mass;
    this.xv+=(cell.xv)*(cell.mass/this.mass);
    this.yv+=(cell.yv)*(cell.mass/this.mass);
    this.xt+=(cell.xt)*(cell.mass/this.mass);
    this.yt+=(cell.yt)*(cell.mass/this.mass);
  }
    
  public void clone(Cell cell){
   
    cell.mass=this.mass;
    cell.gravity=this.gravity;
    cell.xv=this.xv;
    cell.yv=this.yv;
    cell.xt=this.xt;
    cell.yt=this.yt;
    cell.dir=this.dir;
  }
}
