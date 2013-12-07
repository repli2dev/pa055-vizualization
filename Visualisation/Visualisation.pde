// Imports

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

void draw() {
  // if animating, change settings
  if (animate) {
    // ...
    redrawData = true;
  }
  
  // redraw data, if needed
  if (redrawData) {
    years.get(selectedYear).drawDataBackground();
    years.get(selectedYear).drawData();
    years.get(selectedYear).drawDataAxes();
    redrawData = false;
  }
}

void mousePressed() {
  if (mouseY > screenHeight-controlPanelHeight) {
    controller.changeSettingsViaClick(mouseX, mouseY);
  }
}

void keyPressed() {
  controller.changeSettingsViaKey();
}

void mouseDragged() {
  if (dragging) {
    controller.changeSettingsViaClick(mouseX-dragXOffset, mouseY-dragYOffset);
  }
}

void mouseReleased() {
  dragging = false;
}
