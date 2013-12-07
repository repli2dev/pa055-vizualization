/** @file Controller.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief controller object, adjusts settings and manages control panel drawing
 */

class Controller {
  
  // slider change if RIGHT/LEFT arrows are presed
  float keySliderShift = 0.1;
  // minutes passed if UP/DOWN arrows are pressed 
  int keyTimeShift = 1;
  
  // height of the slider bar
  int sliderHeight = 20;
  // part of the bar occupied by actual slider (its relative width)
  float sliderMoverRatio = 0.1;
  // pixel space between slider and bar border
  int sliderOffset = 4;
  
  // tick-box size constant
  int boxSide = 16;

  /** Controller constructor
   * adjusts screen settings
   * loads images and fonts to global variables
   * displays control panel
   */
  Controller() {
    size(screenWidth, screenHeight);
    frameRate(25);
    smooth();
    noStroke();
    // load background
    bgImage = loadImage(bgImagePath);
    // load fonts
    fonts = new PFont[3];
    for (int i = 0; i < 3; i++) {
      fonts[i] = loadFont(fontPaths[i]);
    }
    // load logos
    logoImages = new PImage[3];
    for (int i = 0; i < 3; i++) {
      logoImages[i] = loadImage(logoImagePaths[i]);
    }
    // draw control panel and data
    drawControlPanel();
    redrawData = true;
  }

  /** general method for mouse clicking the control panel
   * calls appropriate subrutine
   * changing settings redraws the control panel and data
   * assumtion: click was placed somewhere in the control area
   */
  void changeSettingsViaClick(int x, int y) {
    boolean clickMeaningful = false;
    // data slider click
    if (y < screenHeight-controlPanelHeight+sliderHeight) {
      clickMeaningful = true;
      dataSliderPosition = changeSliderPosition(x, screenWidth, dataSliderPosition);
    }
    // year selector click
    if (in(x, 34, 120) && 
        in(y, screenHeight-controlPanelHeight+70-8, screenHeight-controlPanelHeight+70-8+25*years.size())) {
      clickMeaningful = true;
      int relativeY = y - (screenHeight-controlPanelHeight+70-8);
      selectedYear = relativeY/25;
    }
    // category selector click
    if (in(x, 234, 370) && 
        in(y, screenHeight-controlPanelHeight+70-8, screenHeight-controlPanelHeight+70-8+25*3)) {
      clickMeaningful = true;
      int relativeY = y - (screenHeight-controlPanelHeight+70-8);
      selectedCategories[relativeY/25] = !selectedCategories[relativeY/25];
    }
    // time slider click
    if (in(x, 400, screenWidth-50) && 
        in(y, screenHeight-controlPanelHeight+50, screenHeight-controlPanelHeight+90)) {
      clickMeaningful = true;
      int relativeX = x-400;
      int barWidth = screenWidth-400-50;
      currentTimePoint = (int)(301*changeSliderPosition(relativeX, barWidth, (float)currentTimePoint/301));
    }
    // speed slider click
    if (in(x, screenWidth-250, screenWidth-50) && 
        in(y, screenHeight-controlPanelHeight+120, screenHeight-controlPanelHeight+160)) {
      clickMeaningful = true;
      int relativeX = x-(screenWidth-250);
      globalAnimationSpeed = changeSliderPosition(relativeX, 200, globalAnimationSpeed);
    }
    // animation start/stop click
    if (false) {
      clickMeaningful = true;
      //...
    }
    // if we clicked something meaningfull, redraw everything
    if (clickMeaningful) {
      drawControlPanel();
      redrawData = true;
    }
  }

  /** general method for keys pressed
   */
  void changeSettingsViaKey() {
    if (key == CODED) {
      switch (keyCode) {
        case RIGHT:
        dataSliderPosition = min(dataSliderPosition+keySliderShift,1); break;
        case LEFT:
        dataSliderPosition = max(dataSliderPosition-keySliderShift,0); break;
        case UP:
        currentTimePoint = min(currentTimePoint+keyTimeShift, 301); break;
        case DOWN:
        currentTimePoint = max(currentTimePoint-keyTimeShift, 0); break;
        default: return; // not meaningful, do not redraw
      }
    } else {
      switch (key) {
        case 'p': animate = !animate; animateCounter = 0; break;
        default: return; // not meaningful, do not redraw
      }
    }
    // redraw everything
    drawControlPanel();
    redrawData = true;
  }

  /** draw the control panel including data slider
   */
  void drawControlPanel() {
    // draw background
    int numImagesWidth = ceil((float)screenWidth/bgImage.width);
    for (int i = 0; i < numImagesWidth; i++) {
      image(bgImage, i*bgImage.width, screenHeight-controlPanelHeight);
    }

    // draw data slider
    drawSlider(0, screenHeight-controlPanelHeight, screenWidth, dataSliderPosition);
    
    // draw year chooser (0-200 pixels from left)
    fill(brownDark);
    textFont(fonts[1]);
    String text = "rocnik";
    text(text, 100-textWidth(text)/2, screenHeight-controlPanelHeight+30+textAscent()/2);
    textFont(fonts[0]);
    for (int i = 0; i < years.size(); i++) {
      drawBox(50, screenHeight-controlPanelHeight+70+i*25, selectedYear == i);
      text = years.get(i).name;
      text(text, 70, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
    
    // draw categories chooser (200-400 pixels from left)
    fill(brownDark);
    textFont(fonts[1]);
    text = "kategorie";
    text(text, 300-textWidth(text)/2, screenHeight-controlPanelHeight+30+textAscent()/2);
    textFont(fonts[0]);
    for (int i = 0; i < 3; i++) {
      drawBox(250, screenHeight-controlPanelHeight+70+i*25, selectedCategories[i]);
      switch (i) {
        case 0: text = "stredoskolaci"; break;
        case 1: text = "vysokoskolaci"; break;
        case 2: text = "ostatni"; break;
      }
      text(text, 270, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
    
    // draw velocity slider
    drawSlider(screenWidth-250, screenHeight-controlPanelHeight+120, 200, globalAnimationSpeed);
    
    // draw time slider
    drawSlider(400, screenHeight-controlPanelHeight+50, screenWidth-400-50, (float)currentTimePoint/301);
    
    // write help
    fill(brownDark);
    text = "sipky hore/dole menia cas, sipky vpravo/vlavo posuvaju timy, p to play/pause";
    text(text, 400, screenHeight-30);;
  }
  
  /** general method for slider drawing
   * @param x              x of the upper left corner of the entire bar
   * @param y              y of the upper left corner of the entire bar
   * @param barWidth       width of the entire bar
   * @param position       slider position given in [0,1] including
   */
  void drawSlider(int x, int y, int barWidth, float position) {
    // draw bar
    fill(red(brownLight), green(brownLight), blue(brownLight), 64);
    rect(x, y, barWidth, sliderHeight);
    // compute relative x slider position
    fill(red(brownLight), green(brownLight), blue(brownLight), 128);
    int sliderWidth = (int)(barWidth*sliderMoverRatio);
    float sliderCenter = map(position, 0, 1, sliderWidth/2, barWidth-sliderWidth/2);
    rect(x+sliderCenter-sliderWidth/2+sliderOffset, y+sliderOffset, 
         sliderWidth-2*sliderOffset, sliderHeight-2*sliderOffset);
  }
  
  /** general method for slider position changing
   * enables dragging if needed
   * @param relativeX      position of the click from the left side of slider bar
   * @param barWidth       width of the entire bar
   * @param position       original slider position given in [0,1] including
   * @return               new slider position in [0,1] including
   */
  float changeSliderPosition(int relativeX, int barWidth, float position) {
    int sliderWidth = (int)(barWidth*sliderMoverRatio);
    int currentSliderPosition = (int)map(position, 0, 1, sliderWidth/2, barWidth-sliderWidth/2);
    // enable dragging if necessary
    if (!dragging 
        && relativeX > currentSliderPosition-sliderWidth/2 
        && relativeX < currentSliderPosition+sliderWidth/2 ) {
      dragging = true;
      dragXOffset = relativeX - currentSliderPosition;
      return position;
    }
    // if clicked outside if the slider, reposition
    relativeX = constrain(relativeX, sliderWidth/2, barWidth-sliderWidth/2);
    return map(relativeX, sliderWidth/2, barWidth-sliderWidth/2, 0, 1);
  }
  
  /** general method for tick-box drawing
   * @param x         x coordinate of box center
   * @param y         y coordinate of box center
   * @param ticked    should tick be placed inside?
   */
  void drawBox(int x, int y, boolean ticked) {
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

