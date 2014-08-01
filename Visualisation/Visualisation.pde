/** @file Visualisation.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief main methods called on events, helper functions
 */

/**
 * method for initializing data loading
 * NOTE: order of addition specifies order of years in app
 */
void prepareData() {
  years = new DataLoader();
  years.addAvailableYear("2009","../Data/ProcessedDataYear2009.csv");
  years.addAvailableYear("2010","../Data/ProcessedDataYear2010.csv");
  years.addAvailableYear("2011","../Data/ProcessedDataYear2011.csv");
  years.addAvailableYear("2012","../Data/ProcessedDataYear2012.csv");
  years.addAvailableYear("2013","../Data/ProcessedDataYear2013.csv");
  
  selectedYear = years.getLastYear();
}

// Main program
void setup() {
  prepareData();
  controller = new Controller();
}

/** main draw method
 * increases time point, if animating
 * calls data redrawing, if needed
 */ 
void draw() {
  if (helpDisplayed) {
    help.draw();
    return;
  }
  // if animating, increase counter (change based on speed)
  if (animate) {
    animateCounter += globalAnimationSpeed*100;
    if (animateCounter >= 50) {
      if((currentTimePoint+animateCounter/50) == 301 && stopAtAnimationEnd) {
        animate = false;
        currentTimePoint = 301;
      } else {
        currentTimePoint = (currentTimePoint+animateCounter/50) % 301;
      }
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
    years.get(selectedYear).drawTeamInfo();
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
