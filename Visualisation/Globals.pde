/** @file Globals.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief global settings, constants and pointers
 */

// SCREEN CONSTANTS
// Screen resolution, change at will (don't make it too small)
int screenHeight = 800;
int screenWidth = 1000;
// Height of the panel, this should not be changed 
int controlPanelHeight = 200;

// CURRENT SETTINGS
// selected year id (used as index to years array)
int selectedYear = 4;
// displayed categories [stredoskolaci, vysokoskolaci, ostatni]
boolean[] selectedCategories = {true, true, true};
// time point in [0,301] including (used as index to states array in team)
int currentTimePoint = 301;
// is the animation going?
boolean animate = false;
// animation speed in [0,1] including
float globalAnimationSpeed = 0.5;

// GLOBAL OBJECTS
// list of years data, typically indexed by selectedYear
ArrayList<Year> years;
// global singleton controller object 
Controller controller;

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

// COLORS AND DESIGN
color brownDark = color(45,22,15);
color brownMedium = color(226, 201, 143);
color brownLight = color(216,181,94);
//color green1 = color(164,209,146);
//color green2 = color(194,224,182);
//color red = color(247,198,198);
color green = color(26, 110, 0);
color red = color(186,13,13);
// background image
String bgImagePath = "images/background.png";
PImage bgImage;
// logos: InterLoS, FI, MU
String[] logoImagePaths = { "images/logo-los.png", "images/logo-fi.png", "images/logo-mu.png" };
PImage[] logoImages;
// used fonts: OpenSans-15, OpenSans-Bold-15, OpenSans-Bold-35
String[] fontPaths = {"fonts/OpenSans-15.vlw", "fonts/OpenSans-Bold-15.vlw", "fonts/OpenSans-Bold-35.vlw"};
PFont[] fonts;
