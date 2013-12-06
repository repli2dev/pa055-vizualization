// Imports


// Shared data and constants
ArrayList<Year> years;

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
  size(640, 360);
}

void draw() {  
}

