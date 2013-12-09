/** @file Team.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief Class which holds informations about team and all states during the game.
 *        Manages data area drawing.
 */
 
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
    
    fill(red(brownLight), green(brownLight), blue(brownLight), 100);
    rect(x, ceil(y-currentState.scoreLogical/ratio), teamColumnWidth, ceil(currentState.scoreLogical/ratio)); // Overlaps are less problems than holes between -> ceil
 
    fill(red(brownLight), green(brownLight), blue(brownLight), 170);
    rect(x, ceil(y-currentState.scoreLogical/ratio - currentState.scoreProgramming/ratio), teamColumnWidth, ceil(currentState.scoreProgramming/ratio));
    
    fill(red(brownLight), green(brownLight), blue(brownLight), 255);
    rect(x, ceil(y-currentState.scoreLogical/ratio - currentState.scoreProgramming/ratio - currentState.scoreIdea/ratio), teamColumnWidth, ceil(currentState.scoreIdea/ratio));
    
    fill(red(green), green(green), blue(green), 150);
    rect(x, ceil(y-currentState.scoreLogical/ratio - currentState.scoreProgramming/ratio - currentState.scoreIdea/ratio - currentState.bonus/ratio), teamColumnWidth, ceil(currentState.bonus/ratio));

    fill(red(red), green(red), blue(red), 150);
    float yPos = ceil(y-currentState.scoreLogical/ratio - currentState.scoreProgramming/ratio - currentState.scoreIdea/ratio - currentState.bonus/ratio);
    rect(x, yPos, teamColumnWidth, currentState.penalisation/ratio);

    // Render notification about changes above the team bar
    if(currentTimePoint == 301) {  // Ignore when on the end of animation
      return;
    }
    int[] changes = getChanges();
    int notificationRendered = 0;
    textFont(fonts[3]);
    textAlign(CENTER);
    for(int i = 0; i < changes.length; i++) {
      if(changes[i] != 0) {
        if(changes[i] < 0) {
          fill(red(red), green(red), blue(red), map(i, changes.length, 0, 40, 255));
        } else {
          fill(red(green), green(green), blue(green), map(i, changes.length, 0, 40, 255));
        }
        text(changes[i], x+teamColumnWidth/2, yPos-5-15*notificationRendered);
        notificationRendered++;
      }
    }
    textAlign(LEFT);
    textFont(fonts[0]);
  }
  
  int computeHistoryLength() {
    return floor(map(globalAnimationSpeed*10, 0, 10, 1, 25));
  }
  
  int[] getChanges() {
    int historyLength = computeHistoryLength();
    int[] changes = new int[historyLength];
    int last = 0;
    for(int i = currentTimePoint; i > 0 && currentTimePoint - i < historyLength; i--) {
      changes[last++] = (getChangeBetweenStates(i, i-1));
    } 
    return changes;
  }
  
  int getChangeBetweenStates(int currentID, int previousID) {
    State current = states[currentID];
    State previous = states[previousID];
    int diff = 0;
    diff += current.scoreProgramming - previous.scoreProgramming;
    diff += current.scoreLogical - previous.scoreLogical;
    diff += current.scoreIdea - previous.scoreIdea;
    diff += current.bonus - previous.bonus;
    diff -= current.penalisation - previous.penalisation;
    return diff;
  }
  
  void drawInfo(int XOffset, int x, int y) {
    int boxLeft = x + XOffset;
    int boxTop = y;
    fill(red(brownLight), green(brownLight), blue(brownLight), 64);
    rect(boxLeft, boxTop, 440, 70);
    if(XOffset == 0) {
      fill(green);
    } else {
      fill(red);
    }
    ellipse(x+XOffset+10, y+15, 10, 10);
    fill(brownDark);
    // Team name
    textFont(fonts[1]);
    String truncatedName = truncate(name,20);
    text(truncatedName, boxLeft+20, boxTop+20);
    // Team category
    float nameWidth = textWidth(truncatedName);
    textFont(fonts[0]);
    text("(" + getCategoryName() + ")", boxLeft+40+nameWidth, boxTop+20);
    // Tasks and penalisation
    text("Logické:", boxLeft+20, boxTop+40);
    text("Programovací:", boxLeft+20, boxTop+60);
    text("Šifrovací:", boxLeft+220, boxTop+40);
    text("Penalizace:", boxLeft+220, boxTop+60);

    State currentState = states[currentTimePoint];
    textAlign(RIGHT);
    text("(" + currentState.numberOfLogical + ")", boxLeft+210, boxTop+40);
    text("(" + currentState.numberOfProgramming + ")", boxLeft+210, boxTop+60);
    text("(" + currentState.numberOfIdea + ")", boxLeft+400, boxTop+40);
    text("(" + currentState.penalisation/30 + ")", boxLeft+400, boxTop+60);
    
    text(currentState.scoreLogical + " b", boxLeft+180, boxTop+40);
    text(currentState.scoreProgramming + " b", boxLeft+180, boxTop+60);
    text(currentState.scoreIdea + " b", boxLeft+360, boxTop+40);
    text(currentState.penalisation + " b", boxLeft+360, boxTop+60);
    
    textFont(fonts[1]);
    text(currentState.getTotalScore() + " b", boxLeft+360, boxTop+20);
    textFont(fonts[0]);
    textAlign(LEFT);
    
    drawCross(boxLeft+415, boxTop+8, 25);
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
  String getCategoryName() {
    if(category == 0) {
      return "středoškoláci";
    } else if (category == 1) {
      return "vysokoškoláci";
    } else {
      return "ostatní";
    }
  }
}
