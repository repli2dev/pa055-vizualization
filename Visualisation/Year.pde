class Year {
  String name;
  ArrayList<Team> teams = new ArrayList<Team>(); // Sorted by total score descending

  int dataBottomMargin = 50;
  int dataTopMargin = 100;
  int dataLeftMargin = 100;

  int titleSize = 35;
  int axesLabelSize = 15;
  int axesStroke = 4;
  int axesPointsInterval = 5000;

  int numAxes() {
    return ceil((float)teams.get(0).states[301].getTotalScore()/axesPointsInterval);
  }

  void drawData() {
    int dataWidth = teams.size()*(teamColumnWidth+teamColumnMargin)+teamColumnMargin;
    int dataShift = (int) map(sliderPosition, 0, 1, 0, dataWidth-screenWidth);
    for (int teamNum = 0; teamNum < teams.size(); teamNum++) {
      // if (!selectedCategories[teams.get(teamNum).category]) continue;
      int x = teamNum*(teamColumnWidth+teamColumnMargin) + teamColumnMargin + dataLeftMargin - dataShift;
      teams.get(teamNum).draw(x, screenHeight-controlPanelHeight-dataBottomMargin, 
                              numAxes()*axesPointsInterval, 
                              screenHeight-controlPanelHeight-dataBottomMargin-dataTopMargin);
    }
  }

  /** background and title in data area
   * puts background image
   * writes title + logo
   * draws data lines
   */
  void drawDataBackground() {
    // place background
    PImage back = loadImage(bgImagePath);
    int numImagesWidth = ceil((float)screenWidth/back.width);
    int numImagesHeight = ceil((float)(screenHeight-controlPanelHeight)/back.height);
    for (int j = 0; j < numImagesHeight; j++) {
      for (int i = 0; i < numImagesWidth; i++) {
        image(back, i*back.width, screenHeight-controlPanelHeight-(j+1)*back.height);
      }
    }

    // make title + logo
    fill(brownDark);
    textSize(titleSize);
    String title = "InterLoS " + name + " -";
    if (selectedCategories[0] && selectedCategories[1] && selectedCategories[2]) {
      title += " vsechny kategorie";
    } 
    else {
      if (selectedCategories[0]) { 
        title += " stredoskolaci";
      }
      if (selectedCategories[1]) { 
        title += " vysokoskolaci";
      }
      if (selectedCategories[2]) { 
        title += " ostatni";
      }
    }
    text(title, screenWidth/2-textWidth(title)/2, dataTopMargin/2+textAscent()/2);

    // draw horisontal axes
    stroke(red(brownLight), green(brownLight), blue(brownLight), 64);
    strokeWeight(axesStroke);
    for (int i = 0; i <= numAxes(); i++) {
      line (dataLeftMargin, map(i, 0, numAxes(), dataTopMargin, screenHeight-controlPanelHeight-dataBottomMargin), 
      screenWidth, map(i, 0, numAxes(), dataTopMargin, screenHeight-controlPanelHeight-dataBottomMargin));
    }
    noStroke();
  }

  void drawDataAxes() {
    // place background to overdraw data parts
    PImage back = loadImage(bgImagePath);
    int numImagesHeight = ceil((float)(screenHeight-controlPanelHeight)/back.height);
    for (int j = 0; j < numImagesHeight; j++) {
      image(back, dataLeftMargin-back.width, screenHeight-controlPanelHeight-(j+1)*back.height);
    }
    stroke(red(brownLight), green(brownLight), blue(brownLight), 64);
    strokeWeight(axesStroke);
    line(dataLeftMargin, screenHeight-controlPanelHeight-dataBottomMargin, 
    dataLeftMargin, dataTopMargin-20);
    noStroke();
    textSize(axesLabelSize);
    for (int i = 0; i <= numAxes(); i++) {
      String text = ""+i*axesPointsInterval;
      text(text, dataLeftMargin-textWidth(text)-10, 
      map(i, 0, numAxes(), screenHeight-controlPanelHeight-dataBottomMargin, dataTopMargin)+
        textAscent()/2);
    }
  }
}

