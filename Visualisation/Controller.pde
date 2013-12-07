/** @file Controller.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief controller object, adjusts settings and manages drawing
 */

class Controller {

  int sliderHeight = 20;
  int sliderWidth = 100;
  int sliderOffset = 4;
  
  float keySliderShift = 0.1;
  int keyTimeShift = 1;
  
  int controlTextSize = 15;

  /** Controller constructor
   * adjusts screen settings, displays control panel
   */
  Controller() {
    size(screenWidth, screenHeight); // size always goes first!
    frameRate(25);
    smooth();
    noStroke();
    bgImage = loadImage(bgImagePath);
    drawControlPanel();
    redrawData = true;
  }

  /** general method for clicking the control panel
   * calls appropriate subrutine, if clicked on settings
   * changing settings redraws the control panel
   * assumtion: click was placed somewhere in the control area
   */
  void changeSettingsViaClick(int x, int y) {
    boolean clickMeaningful = false;
    if (y < screenHeight-controlPanelHeight+sliderHeight) {
      clickMeaningful = true;
      changeSliderPosition(x,y);
    }
    if (x > 34 && x < 120 && y > screenHeight-controlPanelHeight+70-8 
        && y < screenHeight-controlPanelHeight+70-8+25*years.size()) {
      clickMeaningful = true;
      changeYear(x, y);
    }
    if (x > 234 && x < 370 && y > screenHeight-controlPanelHeight+70-8 
        && y < screenHeight-controlPanelHeight+70-8+25*3) {
      clickMeaningful = true;
      changeCategory(x, y);
    }
    
    //...

    if (clickMeaningful) {
      drawControlPanel();
      redrawData = true;
    }
  }

  void changeSettingsViaKey() {
    if (key == CODED) {
      switch (keyCode) {
        case RIGHT:
        sliderPosition = min(sliderPosition+keySliderShift,1);
        break;
        case LEFT:
        sliderPosition = max(sliderPosition-keySliderShift,0);
        break;
        case UP:
        currentTimePoint = min(currentTimePoint+keyTimeShift, 301);
        break;
        case DOWN:
        currentTimePoint = max(currentTimePoint-keyTimeShift, 0);
        break;
        default: return;
      }
    } else {
      switch (key) {
        default: return;
      }
    }
    drawControlPanel();
    redrawData = true;
  }

  /** put the slider elsewhere
   * assumtion: slider bar was clicked
   */
  void changeSliderPosition(int x, int y) {
    int currentSliderPosition = (int)map(sliderPosition, 0, 1, sliderWidth/2, screenWidth-sliderWidth/2);
    if (!dragging && x > currentSliderPosition-sliderWidth/2 && x < currentSliderPosition+sliderWidth/2 ) {
      dragging = true;
      dragXOffset = x - currentSliderPosition;
      dragYOffset = y - (screenHeight-controlPanelHeight+sliderHeight/2);
      return;
    }
    x = max(x, sliderWidth/2);
    x = min(x, screenWidth-sliderWidth/2);
    sliderPosition = map(x, sliderWidth/2, screenWidth-sliderWidth/2, 0, 1);
  }

  void changeCategory(int x, int y) {
    // make y relative
    int relativeY = y - (screenHeight-controlPanelHeight+70-8);
    selectedCategories[relativeY/25] = !selectedCategories[relativeY/25];
  }

  void changeYear(int x, int y) {
    // make y relative
    int relativeY = y - (screenHeight-controlPanelHeight+70-8);
    selectedYear = relativeY/25;
  }

  void changeTimePoint(int x, int y) {
  }

  void changeSpeed(int x, int y) {
  }

  void changeAnimation(int x, int y) {
  }

  void drawControlPanel() {
    // draw background
    int numImagesWidth = ceil((float)screenWidth/bgImage.width);
    for (int i = 0; i < numImagesWidth; i++) {
      image(bgImage, i*bgImage.width, screenHeight-controlPanelHeight);
    }

    // draw slider
    fill(red(brownLight), green(brownLight), blue(brownLight), 64);
    rect(0, screenHeight-controlPanelHeight, screenWidth, sliderHeight);
    fill(red(brownLight), green(brownLight), blue(brownLight), 128);
    float sliderCenter = map(sliderPosition, 0, 1, sliderWidth/2, screenWidth-sliderWidth/2);
    rect(sliderCenter-sliderWidth/2+sliderOffset, screenHeight-controlPanelHeight+sliderOffset, 
    sliderWidth-2*sliderOffset, sliderHeight-2*sliderOffset);
    
    // draw year chooser (0-200 pixels from left)
    textSize(controlTextSize);
    fill(brownDark);
    String text = "rocnik";
    text(text, 100-textWidth(text)/2, screenHeight-controlPanelHeight+30+textAscent()/2);
    for (int i = 0; i < years.size(); i++) {
      drawBox(50, screenHeight-controlPanelHeight+70+i*25, selectedYear == i);
      text = years.get(i).name;
      text(text, 70, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
    
    // draw categories chooser (200-400 pixels from left)
    textSize(controlTextSize);
    fill(brownDark);
    text = "kategorie";
    text(text, 300-textWidth(text)/2, screenHeight-controlPanelHeight+30+textAscent()/2);
    for (int i = 0; i < 3; i++) {
      drawBox(250, screenHeight-controlPanelHeight+70+i*25, selectedCategories[i]);
      switch (i) {
        case 0: text = "stredoskolaci"; break;
        case 1: text = "vysokoskolaci"; break;
        case 2: text = "ostatni"; break;
      }
      text(text, 270, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
  }
  
  void drawBox(int x, int y, boolean ticked) {
    int boxSide = 16;
    strokeWeight(2);
    stroke(brownDark);
    noFill();
    rect(x-boxSide/2, y-boxSide/2, boxSide, boxSide);
    strokeWeight(5);
    if (ticked) {
      line(x-boxSide/2, y, x-boxSide/8, y+boxSide/3);
      line(x+boxSide/2, y-boxSide/2, x-boxSide/8, y+boxSide/3);
    }
    noStroke();
  }
}

