//
//  ContentView.swift
//  wordgameart
//
//  Created by Ken on 2/4/22.
//

import SwiftUI
import Combine

struct ContentView: View {
  @State private var answer: String = ""
  @StateObject private var wordGuesses = WordGuesses()
  
  var body: some View {
    
    VStack {
      
      Text("Word Game Art Creator")
        .multilineTextAlignment(.center)
        .font(.largeTitle)
        .textInputAutocapitalization(.characters)
        .textCase(.uppercase)

        .frame(width: 400, height: 120, alignment: .center)
      
      TextField("5-letter word answer", text: $answer)
        .keyboardType(.alphabet)
        .onReceive(Just(answer)) { newValue in
          let filtered = newValue.filter { String($0).range(of: "[^a-zA-Z]", options: .regularExpression) == nil }
          if filtered != newValue || newValue.count > 5 {
            self.answer = String(filtered.prefix(5))
          }
        }.onSubmit {
          wordGuesses.updateGuesses(forAnswer: answer)
          AppStoreReviewManager.requestReviewIfAppropriate()
        }
        .textFieldStyle(OvalTextFieldStyle())
        
      VStack {
        ForEach(wordGuesses.wordGuesses()) { wg in
          HStack {
            ForEach(wg.getLetterGuesses()) { lg in
              Button(lg.getLetterAsString(), action: {
                buttonTapped(lg, wg)
              }).frame(width: 60, height: 60, alignment: .center)
                .background(colorByResponse(lg.getResponse()))
                .foregroundColor(.white)
                .font(.largeTitle)
                .textCase(.uppercase)
                .cornerRadius(2)
            }
          }
        }
      }
      
    }.ignoresSafeArea(.keyboard)
    
  }
  
  private func buttonTapped(_ letterGuess: LetterGuess, _ wordGuess: WordGuess) {
    let currentResponse = letterGuess.getResponse()
    var nextResponse: LetterGuess.ResponseType
    switch currentResponse {
    case .NOT_PRESENT:
      nextResponse = .WRONG_POSITION
      break
    case .WRONG_POSITION:
      nextResponse = .CORRECT
      break
    case .CORRECT:
      nextResponse = .NOT_PRESENT
      break
    }
    letterGuess.setResponse(nextResponse)
    wordGuess.updateGuess(forAnswer: answer)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct OvalTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(10)
      .background(.white)
      .cornerRadius(20)
      .multilineTextAlignment(.center)
      .textInputAutocapitalization(.characters)
      .shadow(color: .black, radius: 1)
      .frame(width: 200, height: 100, alignment: .top)
  }
}

private func colorByResponse(_ response: LetterGuess.ResponseType) -> Color {
  switch response {
  case .NOT_PRESENT:
    return Color(.sRGB, red: 120/255, green: 124/255, blue: 126/255, opacity: 1)
  case .WRONG_POSITION:
    return Color(.sRGB, red: 201/255, green: 180/255, blue: 88/255, opacity: 1)
  case .CORRECT:
    return Color(.sRGB, red: 106/255, green: 170/255, blue: 100/255, opacity: 1)
  }
}
