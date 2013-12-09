/** @file State.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief class for representing state of team in fixed minute from the beginning of game
 */

class State {
  int numberOfLogical;
  int numberOfProgramming;
  int numberOfIdea;
  
  int scoreLogical;
  int scoreProgramming;
  int scoreIdea;
  
  int bonus;
  
  int penalisation;
  
  int getTotalScore() {
    return scoreLogical + scoreProgramming + scoreIdea + bonus - penalisation;
  }
}
