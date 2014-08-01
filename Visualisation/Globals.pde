/** @file Globals.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief global settings, constants and pointers
 */

// SCREEN CONSTANTS
// Screen resolution, change at will (don't make it smaller than 700x1024)
int screenHeight = 700;
int screenWidth = 1024;
// Height of the panel, this should not be changed 
int controlPanelHeight = 200;

// CURRENT SETTINGS
// selected year as a string (see DataLoader and prepareData())
String selectedYear = null;
// displayed categories [stredoskolaci, vysokoskolaci, ostatni]
boolean[] selectedCategories = {true, true, true};
// time point in [0,301] including (used as index to states array in team)
int currentTimePoint = 301;
// is the animation going?
boolean animate = false;
boolean stopAtAnimationEnd = true;
// should be help displayed?
boolean helpDisplayed = false;
// animation speed in [0,1] including
float globalAnimationSpeed = 0.35;
// currently selected team
int currentTeamLeft = -1;
int currentTeamRight = -1;

// GLOBAL OBJECTS
// storage for all available and already loaded years
DataLoader years;
// global singleton controller object 
Controller controller;
// global object with help
Help help = new Help();

// GLOBAL VARIABLES FOR DRAWING
// position of data slider in [0,1] including
float dataSliderPosition = 0;
// counter for animation speed, new minute as advanced for every 100
int animateCounter = 0;
// should data area be redrawn?
boolean redrawData = true;
// is draggable item selected?
boolean dragging = false;
// dragging offset (how far from center are we holding the slider?)
int dragXOffset = 0;

// GLOBAL DISPLAY CONSTANTS
// width of team column in pixels
int teamColumnWidth = 30;
// margin between 2 team columns in pixels
int teamColumnMargin = 20;
// margin between team detail info box
int teamDetailMargin = 10;

// DATA AREA CONSTANTS
  int dataBottomMargin = 90;
  int dataTopMargin = 120;
  int dataLeftMargin = 100;
  int legendRightMargin = 500;
  int legendTopMargin = 20;
  // width of horisontal axes
  int axesStroke = 4;
  // number of point between 2 horisontal axes
  int axesPointsInterval = 5000;

// COLORS AND DESIGN
color brownDark = color(45,22,15);
color brownMedium = color(226, 201, 143);
color brownLight = color(216,181,94);
color green = color(26, 110, 0);
color red = color(186,13,13);
// background image
String bgImagePath = "images/background.png";
PImage bgImage;
// logos: InterLoS, FI, MU
String[] logoImagePaths = { "images/logo-los.png", "images/logo-fi.png", "images/logo-mu.png" };
PImage[] logoImages;
// used fonts: OpenSans-15, OpenSans-Bold-15, OpenSans-Bold-35, , OpenSans-13
String[] fontPaths = {"fonts/OpenSans-15.vlw", "fonts/OpenSans-Bold-15.vlw", "fonts/OpenSans-Bold-35.vlw", "fonts/OpenSans-13.vlw"};
PFont[] fonts;
