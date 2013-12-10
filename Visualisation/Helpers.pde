/** @file Helpers.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief helper functions
 */

/** interval checking, helper method
 * @param num  value to check
 * @param min  lower bound of interval to check
 * @param max  upper bound of interval to check
 */
boolean in(float num, float min, float max) {
  return (num >= min && num <= max);
}

/**
 * general method for shortening text with elipsis
 * @param input      string to be shortened
 * @param maxLength  maximal length of shortened text
 * @return           shortened text
 */
String truncate(String input, int maxLength) {
  if(input.length() > maxLength) {
    return input.substring(0,maxLength-3) + "...";
  }
  return input;
}

/** general method for function cross drawing
 * @param x    x coordinate of top left corner
 * @param y    y coordinate of top left corner
 */
void drawCross(int x, int y, int boxSide) {
  strokeWeight(2);
  stroke(brownDark);
  line(x, y, x+boxSide/2, y+boxSide/2);
  line(x+boxSide/2, y, x, y+boxSide/2);
  noStroke();
}
