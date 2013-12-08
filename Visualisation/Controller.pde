/** @file Controller.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief controller object, adjusts settings and manages control panel drawing
 */
 
import java.awt.event.KeyEvent;

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
  // y position of top bounding box for button choosers
  int topYbuttons = screenHeight-controlPanelHeight+70-12;
  // margin applied for time and velocity slider
  int sliderMargin = 30;
  // x position of center of the first play/pause button
  int buttonsXbegin = 350+130+boxSide/2;
  // y position of center of the top of speed slider
  int speedSliderY = screenHeight-controlPanelHeight+sliderHeight+80;
  // length between play/pause button centers
  int buttonSpacing = (int)(1.5*boxSide);
  
  // button constants
  static final int BUTTON_PLAY = 0;
  static final int BUTTON_PAUSE = 1;
  static final int BUTTON_HOME = 2;
  static final int BUTTON_END = 3;

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
    if (in(x, 45, 45+80) && 
        in(y, topYbuttons, topYbuttons+25*years.size())) {
      clickMeaningful = true;
      selectedYear = (y-topYbuttons)/25;
    }
    // category selector click
    if (in(x, 180, 180+140) && 
        in(y, topYbuttons, topYbuttons+25*3)) {
      clickMeaningful = true;
      selectedCategories[(y-topYbuttons)/25] = !selectedCategories[(y-topYbuttons)/25];
    }
    // time slider click
    int sliderTopPos = screenHeight-controlPanelHeight+sliderHeight+sliderMargin/2;
    if (in(x, 350+sliderMargin, screenWidth-sliderMargin) && 
        in(y, sliderTopPos, sliderTopPos+sliderHeight)) {
      clickMeaningful = true;
      int relativeX = x-(350+sliderMargin);
      int barWidth = screenWidth-350-2*sliderMargin;
      currentTimePoint = (int)(301*changeSliderPosition(relativeX, barWidth, (float)currentTimePoint/301));
    }
    // speed slider click
    if (in(x, screenWidth-300+sliderMargin, screenWidth-sliderMargin) && 
        in(y, speedSliderY, speedSliderY+sliderHeight)) {
      clickMeaningful = true;
      int relativeX = x-(screenWidth-300+sliderMargin);
      globalAnimationSpeed = changeSliderPosition(relativeX, 300-2*sliderMargin, globalAnimationSpeed);
    }
    // animation start/stop/home/end click
    if (in(x, buttonsXbegin-buttonSpacing/2, buttonsXbegin+5*buttonSpacing/2) &&
        in(y, speedSliderY, speedSliderY+buttonSpacing) ) {
      clickMeaningful = true;
      switch ((int)((x-buttonsXbegin+buttonSpacing/2)/buttonSpacing)) {
        case 0: currentTimePoint = 0; break;
        case 1: animate = !animate; animateCounter = 0; break;
        case 2:
        case 3: currentTimePoint = 301; break;
        default: break;
      }
    }
    // 
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
        case ENTER:
        animate = !animate; animateCounter = 0;
        default: return; // not meaningful, do not redraw
      }
    } else {
      switch (key) {
        case '\n':
        case ' ': animate = !animate; animateCounter = 0; break;
        case 'h': currentTimePoint = 0; break;
        case 'e': currentTimePoint = 301; break;
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
    
    // draw year chooser (0-150 pixels from left)
    fill(brownDark);
    textFont(fonts[1]);
    String text = "rocnik";
    text(text, 85-textWidth(text)/2, screenHeight-controlPanelHeight+sliderHeight+20+textAscent()/2);
    textFont(fonts[0]);
    for (int i = 0; i < years.size(); i++) {
      drawBox(60, screenHeight-controlPanelHeight+70+i*25, selectedYear == i);
      text = years.get(i).name;
      text(text, 80, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
    
    // draw categories chooser (150-350 pixels from left)
    fill(brownDark);
    textFont(fonts[1]);
    text = "kategorie";
    text(text, 250-textWidth(text)/2, screenHeight-controlPanelHeight+sliderHeight+20+textAscent()/2);
    textFont(fonts[0]);
    for (int i = 0; i < 3; i++) {
      drawBox(195, screenHeight-controlPanelHeight+70+i*25, selectedCategories[i]);
      switch (i) {
        case 0: text = "stredoskolaci"; break;
        case 1: text = "vysokoskolaci"; break;
        case 2: text = "ostatni"; break;
      }
      text(text, 215, screenHeight-controlPanelHeight+70+i*25+textAscent()/2);
    }
    
    // draw time slider (350-screenWidth pixels from left)
    drawSlider(350+sliderMargin, screenHeight-controlPanelHeight+sliderHeight+sliderMargin/2, 
               screenWidth-350-2*sliderMargin, (float)currentTimePoint/301);
    fill(brownDark);
    textFont(fonts[0]);
    for(int hour = 0; hour <= 5; hour++) {
      text = "" + (hour+15) + ":00";
      int position = (int)map(hour, 0, 5, 350+sliderMargin, screenWidth-sliderMargin-textWidth(text));
      text(text, position, screenHeight-controlPanelHeight+2*sliderHeight+3*sliderMargin/4+textAscent());
    } 
    
    // draw speed slider ((screenWidth-300)-screenWidth pixels from left)
    fill(brownDark);
    textFont(fonts[1]);
    text = "rychlost animace";
    text(text, screenWidth-300+sliderMargin/2-textWidth(text), speedSliderY+textAscent());
    drawSlider(screenWidth-300+sliderMargin, speedSliderY, 300-2*sliderMargin, globalAnimationSpeed);
    
    // draw animation buttons
    fill(brownDark);
    textFont(fonts[1]);
    text = "casova osa";
    text(text, 350+sliderMargin, speedSliderY+textAscent());
    drawButton(buttonsXbegin, speedSliderY+boxSide/2, BUTTON_HOME);
    drawButton(buttonsXbegin + 2*buttonSpacing, speedSliderY+boxSide/2, BUTTON_END);
    if (animate) {
      drawButton(buttonsXbegin+buttonSpacing, speedSliderY+boxSide/2, BUTTON_PAUSE);
    } else {
      drawButton(buttonsXbegin+buttonSpacing, speedSliderY+boxSide/2, BUTTON_PLAY);
    }
    
    // write help
    fill(brownDark);
    textFont(fonts[0]);
    text = "sipky hore/dole menia cas, sipky vpravo/vlavo posuvaju timy \n";
    text += "space/enter to play/pause, h/e posuny na casovej ose (mozno prerob na home/end)";
    text(text, 350+sliderMargin, screenHeight-20-2*textAscent());
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
  
  /** general method for function button drawing
   * @param x      x coordinate of button center
   * @param y      y coordinate of button center
   * @param type   button type (see constants at top)
   */
  void drawButton(int x, int y, int type) {
    strokeWeight(2);
    stroke(brownDark);
    noFill();
    rect(x-boxSide/2, y-boxSide/2, boxSide, boxSide);
    fill(brownDark);
    noStroke();
    switch (type) {
      case BUTTON_PLAY: 
      triangle(x-boxSide/4,y-2*boxSide/6, x-boxSide/4,y+2*boxSide/6, x+2*boxSide/6,y); break;
      case BUTTON_PAUSE:
      rect(x-boxSide/4, y-2*boxSide/6, boxSide/4, 2*boxSide/3);
      rect(x+boxSide/8, y-2*boxSide/6, boxSide/4, 2*boxSide/3);
      break;
      case BUTTON_HOME:
      triangle(x+2*boxSide/6,y-2*boxSide/6, x+2*boxSide/6,y+2*boxSide/6, x-boxSide/6,y);
      rect(x-boxSide/6-boxSide/6, y-2*boxSide/6, boxSide/6, 2*boxSide/3);
      break;
      case BUTTON_END:
      triangle(x-2*boxSide/6,y-2*boxSide/6, x-2*boxSide/6,y+2*boxSide/6, x+boxSide/6,y);
      rect(x+boxSide/6, y-2*boxSide/6, boxSide/6, 2*boxSide/3);
      break;
      default: break;
    }
    noFill();
  }
}

