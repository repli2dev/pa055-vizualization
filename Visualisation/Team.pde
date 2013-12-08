class Team {
  String name;
  int id;
  int category;
  
  static final int COLLEGE = 1;
  static final int HIGH_SCHOOL = 0;
  static final int OTHER = 2;
  
  State[] states = new State[302];  // Key = minute from beginning of game
  
  /** draw team column
   * @param x          x of lower left corner of bar
   * @param y          y of lower left corner of bar
   * @param maxScore   score corresponding to maxHeight
   * @param maxHeight  maximum allowed bar height
   */
  void draw(int x, int y, int maxScore, int maxHeight) {
    State currentState = states[currentTimePoint];
    int score = currentState.getTotalScore();
    int potentialScore = score + currentState.penalisation;
    float colHeight = map(score, 0, maxScore, 0, maxHeight);
    float ratio = score/colHeight;
    //fill(brownMedium);
    //fill(red(brownLight), green(brownLight), blue(brownLight), 64);
    //rect(x, y-colHeight, teamColumnWidth, colHeight);
    
    fill(red(green), green(green), blue(green), 150);
    rect(x, y-colHeight, teamColumnWidth, currentState.bonus/ratio);
    
    fill(red(red), green(red), blue(red), 150);
    float yPos = y-colHeight-currentState.penalisation/ratio;
    rect(x, yPos, teamColumnWidth, currentState.penalisation/ratio);
   
    //fill(green2);
    fill(red(brownLight), green(brownLight), blue(brownLight), 100);
    rect(x, ceil(y-currentState.scoreLogical/ratio), teamColumnWidth, ceil(currentState.scoreLogical/ratio)); // Overlaps are less problems than holes between -> ceil
 
    //fill(green1);
    fill(red(brownLight), green(brownLight), blue(brownLight), 170);
    rect(x, ceil(y-currentState.scoreLogical/ratio-currentState.scoreProgramming/ratio), teamColumnWidth, ceil(currentState.scoreProgramming/ratio));
    
    //fill(green2);
    fill(red(brownLight), green(brownLight), blue(brownLight), 255);
    rect(x, ceil(y-currentState.scoreLogical/ratio-currentState.scoreProgramming/ratio-currentState.scoreIdea/ratio), teamColumnWidth, ceil(currentState.scoreIdea/ratio));      
  }
  
  void parseAndSetCategory(String category) {
    if(category.equals("college")) {
      this.category = 1;
    } else if(category.equals("high_school")) {
      this.category = 0;
    } else {
      this.category = 2;
    }
  }
}
