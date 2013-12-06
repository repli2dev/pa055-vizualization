class Team {
  String name;
  int id;
  int category;
  State[] states = new State[302];  // Key = minute from beginning of game
  
  void draw(int x, int y, int maxScore, int maxHeight) {
    int score = states[currentTimePoint].getTotalScore();
    fill(brownDark);
    float colHeight = map(score, 0, maxScore, 0, maxHeight);
    rect(x, y-colHeight, teamColumnWidth, colHeight);
  }
}
