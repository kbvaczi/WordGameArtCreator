//
//  LetterGuess.swift
//  wordgameart
//
//  Created by Ken on 2/4/22.
//

import Foundation

class LetterGuess: Identifiable, ObservableObject{
  
  @Published private var letter: Character?
  @Published private var response: ResponseType = .NOT_PRESENT

  
  public init() {
  }
  
  public convenience init (letter: Character) {
    self.init()
    self.letter = letter
  }
  
  public func getLetter() -> Character? {
    return self.letter
  }
  
  public func getLetterAsString() -> String {
    return (self.letter != nil) ? String(self.letter!) : "  "
  }
  
  public func setLetter(_ letter: Character) {
    self.letter = letter
  }
  
  public func getResponse() -> ResponseType {
    return self.response
  }
  
  public func setResponse(_ response: ResponseType) {
    self.response = response
  }
  
  public enum ResponseType {
    case NOT_PRESENT
    case WRONG_POSITION
    case CORRECT
  }
  
}
