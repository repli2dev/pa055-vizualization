/** @file Visualisation.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief main methods called on events, helper functions
 */

void loadAllData() {
  DataLoader dl = new DataLoader();
  dl.load("2009","../Data/ProcessedDataYear2009.csv");
  dl.load("2010","../Data/ProcessedDataYear2010.csv");
  dl.load("2011","../Data/ProcessedDataYear2011.csv");
  dl.load("2012","../Data/ProcessedDataYear2012.csv");
  dl.load("2013","../Data/ProcessedDataYear2013.csv");
  years = dl.getAll();
}

// Main program
void setup() {
  loadAllData();
  Team tempTeam = years.get(4).teams.get(1); // Last year -> second team
  for(int i = 0; i < 302; i++) {
    println(tempTeam.states[i].getTotalScore());
  }
  controller = new Controller();
}

/** main draw method
 * increases time point, if animating
 * calls data redrawing, if needed
 */ 
void draw() {
  // if animating, increase counter (change based on speed)
  if (animate) {
    animateCounter += globalAnimationSpeed*100;
    if (animateCounter >= 50) {
      currentTimePoint = (currentTimePoint+animateCounter/50) % 301;
      animateCounter = 0;
      controller.drawControlPanel();
      redrawData = true;
    }
  }
  
  // redraw data, if needed
  if (redrawData) {
    years.get(selectedYear).drawDataBackground();
    years.get(selectedYear).drawData();
    years.get(selectedYear).drawDataAxes();
    redrawData = false;
  }
}

/** main mouse click processing method
 * passes click processing to controller or year, depending on location
 */
void mousePressed() {
  if (mouseY > screenHeight-controlPanelHeight) {
    controller.changeSettingsViaClick(mouseX, mouseY);
  } else {
    years.get(selectedYear).processClick(mouseX, mouseY);
  }
}

/** main keyboard processing method
 * passes key processing to controller
 */ 
void keyPressed() {
  controller.changeSettingsViaKey();
}

/** main mouse drag processing method
 * if draggable item is selected, pass processing as click to controller
 * adjust click position first
 */
void mouseDragged() {
  if (dragging) {
    controller.changeSettingsViaClick(mouseX-dragXOffset, mouseY);
  }
}

/** main mouse reseasing method
 * deactivate selection of draggable items
 */
void mouseReleased() {
  dragging = false;
}

/** interval checking, helper method
 */
boolean in(float num, float min, float max) {
  return (num >= min && num <= max);
}
