/** @file Globals.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief global settings, constants and pointers
 */

// Screen settings
int screenHeight = 800;
int screenWidth = 1000;
int controlPanelHeight = 200;

// Current display settings
int selectedYear = 4;
boolean[] selectedCategories = {true, true, true};
int currentTimePoint = 301;
boolean animate = false;
float globalAnimationSpeed = 0.5;

// Display variables
float sliderPosition = 0;
boolean redrawData = true;
boolean dragging = false;
int dragXOffset = 0;
int dragYOffset = 0;

// Shared data and constants
ArrayList<Year> years;
Controller controller;

// data display settings
int teamColumnWidth = 30;
int teamColumnMargin = 20;

// Colors and design
color brownDark = color(45,22,15);
color brownLight = color(216,181,94);
String bgImagePath = "images/background.png";
PImage bgImage;
