/** @file DataLoader.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief load and parse data from csv file which is preprocessed by script, see DataPreprocessing.py
 */
class DataLoader {  
  private HashMap<String, String> availableYears = new HashMap<String, String>();
  private HashMap<String, Year> years = new HashMap<String,Year>();
  private ArrayList<String> yearsOrder = new ArrayList<String>();
  
  void addAvailableYear(String year, String filePath) {
    availableYears.put(year, filePath);
    yearsOrder.add(year);
  }
  
  Year get(String year) {
   if (!availableYears.containsKey(year)) {
      return null; 
    }
    if (!years.containsKey(year)) {
      load(year, availableYears.get(year));
    }
    return years.get(year);
  }
  
  String getLastYear() {
    if (yearsOrder.isEmpty()) {
      return null;
    }
    return yearsOrder.get(yearsOrder.size()-1);
  }
  
  String getNext(String current) {
    for (int i = 0; i < yearsOrder.size(); i++) {
      if (yearsOrder.get(i).equals(current)) {
        return yearsOrder.get((i + 1) % yearsOrder.size());
      }
    }
    return current;
  }
  
  String getPrev(String current) {
    for (int i = 0; i < yearsOrder.size(); i++) {
      if (yearsOrder.get(i).equals(current)) {
        return yearsOrder.get(((i + yearsOrder.size()) - 1) % yearsOrder.size());
      }
    }
    return current;
  }
  
  private void load(String year, String filePath) {
    Year tempYear = new Year();
    tempYear.name = year;
    //BufferedReader reader = createReader(filePath);
    String lines[] = loadStrings(filePath);
    String line;
    String[] temp;
    Team tempTeam;
    for (int j = 0 ; j < lines.length; j++) {
      line = lines[j];
      temp = split(line,"$");
      tempTeam = new Team();
      tempTeam.id = Integer.parseInt(temp[0]);
      tempTeam.name = temp[1];
      tempTeam.parseAndSetCategory(temp[2]);
      int OFFSET = 3;
      State tempState;
      // Load all states into array
      for(int i = 0; i < 302; i++) {
        tempState = new State();
        tempState.numberOfLogical = Integer.parseInt(temp[OFFSET + 1 + i*9]);
        tempState.numberOfProgramming = Integer.parseInt(temp[OFFSET + 2 + i*9]);
        tempState.numberOfIdea = Integer.parseInt(temp[OFFSET + 3 + i*9]);

        tempState.scoreLogical = Integer.parseInt(temp[OFFSET + 4 + i*9]);
        tempState.scoreProgramming = Integer.parseInt(temp[OFFSET + 5 + i*9]);
        tempState.scoreIdea = Integer.parseInt(temp[OFFSET + 6 + i*9]);

        tempState.bonus = Integer.parseInt(temp[OFFSET + 7 + i*9]);

        tempState.penalisation = Integer.parseInt(temp[OFFSET + 8 + i*9]);
        
        tempTeam.states[i] = tempState;
      }
      
      tempYear.teams.add(tempTeam);
    }
    years.put(year, tempYear);
  }
}
