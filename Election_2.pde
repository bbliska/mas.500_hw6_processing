/**
 * Example that loads up election data and draws something with it.
 */

// window size (it's a square)
final int WINDOW_HEIGHT = 400;
final int WINDOW_WIDTH=1200;
// how many milliseconds to show each state for
final int MILLIS_PER_STATE= 500;
// will hold angle values to create pie chart for each state's votes
float a1;
float a2;
//colors
color r=color(210,10,10);
color b=color(10,10,210);
color g=color(10,210,10);
//boolean for sorting red vs blue states
boolean dem = true;
int dem_offset =0;
int rep_offset=0;
int curr_offset=0;
float height_div=0;
float dem_height_div=WINDOW_HEIGHT-50;
float rep_height_div=50;
int demcount=0;
int repcount=0;
// will hold our anti-aliased font
PFont font;
// when did we last change states?
int lastStateMillis = 0;
// loads and holds the data in the election results CSV
ElectionData data;
// holds a list of state postal codes
String[] statePostalCodes;
// what index in the statePostalCodes array are we current showing
int currentStateIndex = 0;
int romneyTotal=0;
int obamaTotal=0;
int statecount=1;
double total=0;
String banner= "test";
/**
 * This is called once at the start to initialize things
 **/
void setup() {
  // create the main window
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  // load the font
  font = createFont("Helvetica Neue",36,true);
  // load in the election results data
  data = new ElectionData(loadStrings("data/2012_US_election_state.csv"));
  statePostalCodes = data.getAllStatePostalCodes();
  print("Loaded data for "+data.getStateCount()+" states");
  background(color(0,0,0));
  fill(color(250,250,250));
  textFont(font,36);
  textAlign(LEFT);
  text("National Results: Total Votes",550,215);
  fill(r);
  text("Romney",550,160);
  fill(b);
  text("Obama",550,265);
}

/**
 * This is called repeatedly
 */
void draw() {
  // only update if it's has been MILLIS_PER_STATE since the last time we updated
  if (millis() - lastStateMillis >= MILLIS_PER_STATE && statecount<43) {
    fill(color(0,0,0));
    rect(0,150,500,100);
    String currentPostalCode = statePostalCodes[ currentStateIndex ];
    StateData state = data.getState(currentPostalCode);
    
    if (state.pctForRomney>state.pctForObama){
      fill(r);
      repcount+=1;
      if (repcount==13){
        rep_height_div=rep_height_div+50;
        repcount=0;
        rep_offset=0;
      }
      height_div=rep_height_div;
      rep_offset+=40;
      curr_offset=rep_offset;
    }
    else{
      fill(b);
      demcount+=1;
      if (demcount==13){
        dem_height_div=dem_height_div-50;
        demcount=0;
        dem_offset=0;
      }
      height_div=dem_height_div;
      dem_offset+=40;
      curr_offset=dem_offset;
    }
    banner=state.name;
    text(banner,40,215);
    // add baby state pie chart
    pieChart(float(35),state.pctForRomney,state.pctForObama,height_div,curr_offset);
    //display state name in color of winning party
    romneyTotal+=(state.votesForRomney/1000);
    obamaTotal+=(state.votesForObama/1000);
    total=(romneyTotal+obamaTotal);  
   // ellipse(1000.,200.,(float)(romneyTotal*100/(romneyTotal+obamaTotal)),(float)(romneyTotal*100/(romneyTotal+obamaTotal)));
   // ellipse(1100.,200.,(float)(obamaTotal*100/(romneyTotal+obamaTotal)),(float)(obamaTotal*100/(romneyTotal+obamaTotal)));
    //pieChart(float(200),(romneyTotal*100)/total,(obamaTotal*100)/total,200,1000);
    fill(r);
    rect(550,30,romneyTotal/85,80);
    fill(b);
    rect(550,290,obamaTotal/85,80);

  
    // update which state we're showing
    currentStateIndex = (currentStateIndex+1) % statePostalCodes.length;
    // update the last time we drew a state
    lastStateMillis = millis();
    statecount+=1;  
    //end loop
    if (statecount==43){
        fill(b);
        text("Obama wins!",550,265);
    }
    }
}

void pieChart(float diameter,double d1,double d2, float height_div, int width_offset) {
  a1= (float) (d1/(100*180)*360*PI);
  a2= (float) (d2/(100*180)*360*PI);
  fill(r);
  arc(width_offset, height_div, diameter,diameter, 0., a1);
  fill(b);
  arc(width_offset, height_div, diameter, diameter, a1, (a1+a2));
  fill(g);
  arc(width_offset, height_div, diameter, diameter, (a1+a2),2*PI);
}

