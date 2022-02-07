//
//  WordGuesses.swift
//  wordgameart
//
//  Created by Ken on 2/4/22.
//

import Foundation
import Combine

class WordGuesses: ObservableObject {
    
  @Published var wordGuess1: WordGuess
  @Published var wordGuess2: WordGuess
  @Published var wordGuess3: WordGuess
  @Published var wordGuess4: WordGuess
  @Published var wordGuess5: WordGuess
  @Published var wordGuess6: WordGuess
  
  var anyCancellable1: AnyCancellable? = nil
  var anyCancellable2: AnyCancellable? = nil
  var anyCancellable3: AnyCancellable? = nil
  var anyCancellable4: AnyCancellable? = nil
  var anyCancellable5: AnyCancellable? = nil
  var anyCancellable6: AnyCancellable? = nil
  
  public init() {
    wordGuess1 = WordGuess()
    wordGuess2 = WordGuess()
    wordGuess3 = WordGuess()
    wordGuess4 = WordGuess()
    wordGuess5 = WordGuess()
    wordGuess6 = WordGuess()
    
    anyCancellable1 = wordGuess1.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable2 = wordGuess2.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable3 = wordGuess3.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable4 = wordGuess4.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable5 = wordGuess5.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
    anyCancellable6 = wordGuess6.objectWillChange.sink { [weak self] (_) in
      self?.objectWillChange.send()
    }
  }
  
  public func wordGuesses() -> Array<WordGuess> {
    return [wordGuess1, wordGuess2, wordGuess3, wordGuess4, wordGuess5, wordGuess6]
  }
  
  public func updateGuesses(forAnswer answer: String) {
    DispatchQueue.main.async {
      for wg in self.wordGuesses() {
        wg.updateGuess(forAnswer: answer)
      }
    }    
  }
  
}
