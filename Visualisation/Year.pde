/** @file Year.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief holds data for 1 year, manages data area drawing
 */

class Year {
  String name;
  ArrayList<Team> teams = new ArrayList<Team>(); // Sorted by total score descending

  // DATA AREA MARGINS
  int dataBottomMargin = 50;
  int dataTopMargin = 120;
  int dataLeftMargin = 100;

  // width of horisontal axes
  int axesStroke = 4;
  // number of point between 2 horisontal axes
  int axesPointsInterval = 5000;

  /** number of horisontl axws behind bars
   * determined from total score of the best team at the end
   */
  int numAxes() {
    return ceil((float)teams.get(0).states[301].getTotalScore()/axesPointsInterval);
  }

  /** total number of teams in selected categories
   */
  int numSelectedTeams() {
    int numTeams = 0;
    for (int i = 0; i < teams.size(); i++) {
      if (selectedCategories[teams.get(i).category]) numTeams++;
    } 
    return numTeams;
  }

  /** draw actual team data
   * to be done after background drawing and before scale drawing
   * calls individual temas's draw with correct offsets
   */
  void drawData() {
    int dataWidth = numSelectedTeams()*(teamColumnWidth+teamColumnMargin)+teamColumnMargin;
    int dataShift;
    if (dataWidth + dataLeftMargin < screenWidth) {
      dataShift = 0;
    } else {
      dataShift = (int) map(dataSliderPosition, 0, 1, 0, dataWidth-screenWidth);
    }
    int renderedTeams = 0;
    for (int teamNum = 0; teamNum < teams.size(); teamNum++) {
      if (!selectedCategories[teams.get(teamNum).category]) continue;
      int x = renderedTeams*(teamColumnWidth+teamColumnMargin) + teamColumnMargin + dataLeftMargin - dataShift;
      teams.get(teamNum).draw(x, screenHeight-controlPanelHeight-dataBottomMargin, 
      numAxes()*axesPointsInterval, 
      screenHeight-controlPanelHeight-dataBottomMargin-dataTopMargin);
      renderedTeams += 1;
    }
  }

  /** background and horisontal axes in data area
   * puts background image
   * draws data lines
   * to be called before data drawing
   */
  void drawDataBackground() {
    // place background
    int numImagesWidth = ceil((float)screenWidth/bgImage.width);
    int numImagesHeight = ceil((float)(screenHeight-controlPanelHeight)/bgImage.height);
    for (int j = 0; j < numImagesHeight; j++) {
      for (int i = 0; i < numImagesWidth; i++) {
        image(bgImage, i*bgImage.width, screenHeight-controlPanelHeight-(j+1)*bgImage.height);
      }
    }

    // draw horisontal axes
    stroke(red(brownLight), green(brownLight), blue(brownLight), 64);
    strokeWeight(axesStroke);
    for (int i = 0; i <= numAxes(); i++) {
      line (dataLeftMargin, map(i, 0, numAxes(), dataTopMargin, screenHeight-controlPanelHeight-dataBottomMargin), 
      screenWidth, map(i, 0, numAxes(), dataTopMargin, screenHeight-controlPanelHeight-dataBottomMargin));
    }
    noStroke();
  }

  /** draws vertical scale, title and logos
   * to be called after data drawing
   */
  void drawDataAxes() {
    // place background to overdraw data parts on the left
    int numImagesHeight = ceil((float)(screenHeight-controlPanelHeight)/bgImage.height);
    for (int j = 0; j < numImagesHeight; j++) {
      image(bgImage, dataLeftMargin-bgImage.width, screenHeight-controlPanelHeight-(j+1)*bgImage.height);
    }
    
    // draw axis
    stroke(red(brownLight), green(brownLight), blue(brownLight), 64);
    strokeWeight(axesStroke);
    line(dataLeftMargin, screenHeight-controlPanelHeight-dataBottomMargin, dataLeftMargin, dataTopMargin-20);
    noStroke();
    
    // draw text labels on axis
    for (int i = 0; i <= numAxes(); i++) {
      String text = ""+i*axesPointsInterval;
      fill(brownDark);
      text(text, dataLeftMargin-textWidth(text)-10, 
      map(i, 0, numAxes(), screenHeight-controlPanelHeight-dataBottomMargin, dataTopMargin)+
        textAscent()/2);
    }

    // draw title + InterLoS logo
    fill(brownDark);
    textFont(fonts[2]);
    String title = "InterLoS " + name;
    text(title, logoImages[0].width+10, 3*dataTopMargin/5);
    float afterTitle = logoImages[0].width+10+textWidth(title);
    image(logoImages[0], 10, -10);
    
    // place university and faculty logo
    image(logoImages[2], screenWidth-logoImages[2].width-10, 10);
    image(logoImages[1], screenWidth-logoImages[2].width-10-logoImages[1].width-10, 10);

    // draw categories text
    textFont(fonts[0]);
    String categsText = "(";
    int numCategories = 0;
    if (selectedCategories[0] && selectedCategories[1] && selectedCategories[2]) {
      categsText += "vsechny kategorie";
    } 
    else {
      if (selectedCategories[0]) { 
        categsText += "stredoskolaci";
        numCategories++;
      }
      if (selectedCategories[1]) {
        if (numCategories > 0) { 
          categsText += ", ";
        } 
        categsText += "vysokoskolaci";
        numCategories++;
      }
      if (selectedCategories[2]) { 
        if (numCategories > 0) { 
          categsText += ", ";
        } 
        categsText += "ostatni";
        numCategories++;
      }
    }
    categsText += ")";
    text(categsText, afterTitle+10, 3*dataTopMargin/5);
  }
  
  /** processes click in data area
   */
  void processClick(int x, int y) {
    
  }
}

