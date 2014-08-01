/** @file Year.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief holds data for 1 year, manages data area drawing
 */

class Year {
  String name;
  ArrayList<Team> teams = new ArrayList<Team>(); // Sorted by total score descending

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
      teams.get(teamNum).draw(
        x,
        screenHeight-controlPanelHeight-dataBottomMargin, 
        numAxes()*axesPointsInterval, 
        screenHeight-controlPanelHeight-dataBottomMargin-dataTopMargin
      );
      if(currentTeamLeft == teamNum || currentTeamRight == teamNum) {
        if(currentTeamLeft == teamNum) {
          fill(green);
          stroke(green,155);
        }
        if(currentTeamRight == teamNum) {
          fill(red);
          stroke(red,155);
        }
        ellipse(x+teamColumnWidth/2, screenHeight-controlPanelHeight-dataBottomMargin+3, 10, 10);
        strokeWeight(2);
        float y = teams.get(teamNum).getLevel(
          screenHeight-controlPanelHeight-dataBottomMargin, 
          numAxes()*axesPointsInterval, 
          screenHeight-controlPanelHeight-dataBottomMargin-dataTopMargin
        ); 
        if (y != 0) line(dataLeftMargin, y, screenWidth, y);
        noStroke();
      }
      
      renderedTeams += 1;
    }
  }

  /** 
   * Draw data legend left from logos
   */  
  void drawDataLegend() {
    int baseX = screenWidth - legendRightMargin;
    fill(red(brownLight), green(brownLight), blue(brownLight), 100);
    rect(baseX, legendTopMargin, 20,20);
        fill(red(brownLight), green(brownLight), blue(brownLight), 255);
    text("Logické",baseX+30, legendTopMargin+textAscent()*1.3);
 
    fill(red(brownLight), green(brownLight), blue(brownLight), 170);
    rect(baseX,legendTopMargin+30, 20,20);
    fill(red(brownLight), green(brownLight), blue(brownLight), 255);
    text("Programovací",baseX+30, legendTopMargin+30+textAscent()*1.3);
    
    fill(red(brownLight), green(brownLight), blue(brownLight), 255);
    rect(baseX, legendTopMargin+60, 20,20);
    text("Šifrovací", baseX+30, legendTopMargin+60+textAscent()*1.3);
    
    fill(red(green), green(green), blue(green), 150);
    rect(baseX+180, legendTopMargin, 20,20);
    text("Bonus",baseX+210, legendTopMargin+textAscent()*1.3);
    
    fill(red(red), green(red), blue(red), 150);
    rect(baseX+180, legendTopMargin+30, 20,20);
    text("Penalizace",baseX+210, legendTopMargin+30+textAscent()*1.3);
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
    drawDataLegend();
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
      categsText += "všechny kategorie";
    } 
    else {
      if (selectedCategories[0]) { 
        categsText += "středoškoláci";
        numCategories++;
      }
      if (selectedCategories[1]) {
        if (numCategories > 0) { 
          categsText += ", ";
        } 
        categsText += "vysokoškoláci";
        numCategories++;
      }
      if (selectedCategories[2]) { 
        if (numCategories > 0) { 
          categsText += ", ";
        } 
        categsText += "ostatní";
        numCategories++;
      }
    }
    categsText += ")";
    text(categsText, afterTitle+10, 3*dataTopMargin/5);
  }

  /**
   * Draw team details boxes for currently selected teams.
   */  
  void drawTeamInfo() {
    if(currentTeamLeft >= 0  && currentTeamLeft < teams.size()) {
      teams.get(currentTeamLeft).drawInfo(0, dataLeftMargin, screenHeight-controlPanelHeight-dataBottomMargin+teamDetailMargin);  
    }
    if(currentTeamRight >= 0  && currentTeamRight < teams.size()) {
      teams.get(currentTeamRight).drawInfo(450, dataLeftMargin, screenHeight-controlPanelHeight-dataBottomMargin+teamDetailMargin);  
    }
      
  }
  
  /** processes click in data area
   */
  void processClick(int x, int y) {
    int baseX = dataLeftMargin;
    int baseY = screenHeight-controlPanelHeight-dataBottomMargin+teamDetailMargin;
    // Check closing click on team detail boxes cross
    if(in(x,baseX+415, baseX+415+25) &&
       in(y, baseY, baseY+25)) {
       currentTeamLeft = -1;
       redrawData = true;
       return;
    }
    if(in(x,baseX+415+450, baseX+415+450+25) &&
       in(y, baseY, baseY+25)) {
       currentTeamRight = -1;
       redrawData = true;
       return;
    }
    // Check click on team bar -> select this team
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
      int teamX = renderedTeams*(teamColumnWidth+teamColumnMargin) + teamColumnMargin + dataLeftMargin - dataShift;
      int teamY = screenHeight-controlPanelHeight-dataBottomMargin;
      if(in(x, teamX, teamX + teamColumnWidth) &&
         in(y, teamY - (screenHeight-controlPanelHeight-dataBottomMargin-dataTopMargin), teamY)) {
           if(mouseButton == LEFT) { // LEFT/RIGHT - for selecting two teams into two different areas
             currentTeamLeft = teamNum;
           } else if (mouseButton == RIGHT) {
             currentTeamRight = teamNum;
           }
           redrawData = true;
      }
      renderedTeams += 1;
    }
  }
}

