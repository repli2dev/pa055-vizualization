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
