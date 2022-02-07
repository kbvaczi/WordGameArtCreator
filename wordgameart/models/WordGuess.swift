//
//  WordGuess.swift
//  wordgameart
//
//  Created by Ken on 2/4/22.
//

import Foundation
import Combine

class WordGuess: Identifiable, ObservableObject {
  
  @Published var letterGuess1: LetterGuess
  @Published var letterGuess2: LetterGuess
  @Published var letterGuess3: LetterGuess
  @Published var letterGuess4: LetterGuess
  @Published var letterGuess5: LetterGuess
  
  var anyCancellable1: AnyCancellable? = nil
  var anyCancellable2: AnyCancellable? = nil
  var anyCancellable3: AnyCancellable? = nil
  var anyCancellable4: AnyCancellable? = nil
  var anyCancellable5: AnyCancellable? = nil
  
  public init() {
    letterGuess1 = LetterGuess()
    letterGuess2 = LetterGuess()
    letterGuess3 = LetterGuess()
    letterGuess4 = LetterGuess()
    letterGuess5 = LetterGuess()
    
    anyCancellable1 = letterGuess1.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable2 = letterGuess2.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable3 = letterGuess3.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable4 = letterGuess4.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable5 = letterGuess5.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
  }
  
  private func setGuessesWithWord(word: String) {
    letterGuess1.setLetter(char(at: 0, inWord: word))
    letterGuess2.setLetter(char(at: 1, inWord: word))
    letterGuess3.setLetter(char(at: 2, inWord: word))
    letterGuess4.setLetter(char(at: 3, inWord: word))
    letterGuess5.setLetter(char(at: 4, inWord: word))
  }
  
  private func char(at pos: Int, inWord word: String) -> Character {
    return word[word.index(word.startIndex, offsetBy: pos)]
  }
  
  private func charCount(char: Character, inWord word: String) -> Int {
    return word.lowercased().filter { $0 == Character(String(char).lowercased()) }.count
  }
  
  public func getLetterGuesses() -> [LetterGuess] {
    return [letterGuess1, letterGuess2, letterGuess3, letterGuess4, letterGuess5]
  }
  
  public func updateGuess(forAnswer answer: String) {
    
    guard answer.count == 5 else { return }
    
    let answerLowercase = answer.lowercased()
    var validWords: [String] = []
    
    for word in WordList.list {
      var isValid = true
      for (i, ch) in word.lowercased().enumerated() {
        let letterGuess = self.getLetterGuesses()[i]
        switch letterGuess.getResponse() {
          case .NOT_PRESENT:
            if answerLowercase.contains(ch) {
              isValid = false
              break
            }
          case .WRONG_POSITION:
            let charCountAnswer = charCount(char: ch, inWord: answer)
            let charCountWord = charCount(char: ch, inWord: word)
            let isCorrectCharCount = charCountWord <= charCountAnswer
            if !answerLowercase.contains(ch) || char(at: i, inWord: answerLowercase) == ch || !isCorrectCharCount {
              isValid = false
              break
            }
          case .CORRECT:
            if !answerLowercase.contains(ch) || char(at: i, inWord: answerLowercase) != ch {
              isValid = false
              break
            }
        }
      }
      if isValid {
        validWords.append(word)
      }
    }
    self.setGuessesWithWord(word: validWords.randomElement() ?? "     ")
    
  }
  
}
