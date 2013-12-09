/** @file DataLoader.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief load and parse data from csv file which is preprocessed by script, see DataPreprocessing.py
 */
class DataLoader {
  private ArrayList<Year> years = new ArrayList<Year>();
  
  void load(String year, String filePath) {
    Year tempYear = new Year();
    tempYear.name = year;
    BufferedReader reader = createReader(filePath);
    String line;
    String[] temp;
    Team tempTeam;
    try {
      while((line = reader.readLine()) != null) {
        temp = split(line,"$");
        tempTeam = new Team();
        tempTeam.id = Integer.parseInt(temp[0]);
        tempTeam.name = temp[1];
        tempTeam.parseAndSetCategory(temp[2]);
        int OFFSET = 3;
        State tempState;
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
      reader.close();
    } catch (Exception e) {
      e.printStackTrace();
      exit();
    }
    years.add(tempYear);
  }
  
  ArrayList<Year> getAll() {
    return years;
  }
}
