class Team {
  String name;
  int id;
  int category;
  State[] states = new State[302];  // Key = minute from beginning of game
  
  /** draw team column
   * @param x          x of lower left corner of bar
   * @param y          y of lower left corner of bar
   * @param maxScore   score corresponding to maxHeight
   * @param maxHeight  maximum allowed bar height
   */
  void draw(int x, int y, int maxScore, int maxHeight) {
    int score = states[currentTimePoint].getTotalScore();
    fill(brownDark);
    float colHeight = map(score, 0, maxScore, 0, maxHeight);
    rect(x, y-colHeight, teamColumnWidth, colHeight);
  }
}
