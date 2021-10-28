//
//  ContentView.swift
//  BrainTrainingGame
//
//  Created by Dmitry Sharabin on 28.10.2021.
//

import SwiftUI

struct MoveEmoji: View {
    var emoji: String
    
    var body: some View {
        Text(emoji)
            .font(.system(size: 80))
    }
}

struct EmojiButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

extension View {
    func emojiButton() -> some View {
        modifier(EmojiButton())
    }
}

struct ContentView: View {
    let moves = ["✊🏻", "✋🏻", "✌🏻"]
    
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var correctMoveCount = 0
    @State private var wrongMoveCount = 0
    
    @State private var roundsLeft = 10
    @State private var showingRestartGame = false
    
    var message: String {
        "\(roundsLeft) round\(roundsLeft > 1 ? "s" : "") left"
    }
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(stops: [
                .init(color: Color(red: 0.2, green: 0.2, blue: 0.2), location: 0.8),
                .init(color: Color(red: 0.75, green: 0.75, blue: 0.75), location: 0.8)
            ]), center: .bottom, startRadius: 200, endRadius: 670)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Group {
                    Text("Rock, Paper, Scissors")
                        .font(.largeTitle.weight(.heavy))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    VStack {
                        MoveEmoji(emoji: moves[currentChoice])
                        
                        Text("You should")
                        Text(shouldWin ? "Win" : "Lose")
                            .textCase(.uppercase)
                            .font(.title.weight(.semibold))
                    }
                }
                
                Spacer()
                Spacer()
                
                VStack {
                    Text("Make your move")
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { number in
                            Button {
                                moveTapped(number)
                            } label: {
                                MoveEmoji(emoji: moves[number])
                                    .emojiButton()
                            }
                        }
                    }
                }
                
                Spacer()
                Spacer()
                
                HStack(spacing: 50) {
                    VStack {
                        Text("Correct")
                            .textCase(.uppercase)
                            
                        Text("\(correctMoveCount)")
                            .font(.title.bold())
                    }
                    
                    VStack {
                        Text("Wrong")
                            .textCase(.uppercase)
                        
                        Text("\(wrongMoveCount)")
                            .font(.title.bold())
                    }
                    
                }
            }
            .foregroundColor(.white)
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("New round", action: newRound)
        } message: {
            Text(message)
        }
        .alert(scoreTitle, isPresented: $showingRestartGame) {
            Button("Restart game", action: reset)
        } message: {
            Text("Gave over! Your score is \(score).")
        }
    }
    
    func moveTapped(_ move: Int) {
        let correctMove: String
        
        switch moves[currentChoice] {
            case "✊🏻":
                correctMove = shouldWin ? "✋🏻" : "✌🏻"
            case "✋🏻":
                correctMove = shouldWin ? "✌🏻" : "✊🏻"
            default:
                correctMove = shouldWin ? "✊🏻" : "✋🏻"
        }
        
        if moves[move] == correctMove {
            scoreTitle = "Correct"
            correctMoveCount += 1
            score += 1
        } else {
            scoreTitle = "You should choose \(correctMove)"
            wrongMoveCount += 1
            if score > 0 {
                score -= 1
            }
        }
        
        roundsLeft -= 1
        if roundsLeft == 0 {
            showingRestartGame = true
        } else {
            showingScore = true
        }
    }
    
    func newRound() {
        currentChoice = Int.random(in: 0...2)
        shouldWin.toggle()
    }
    
    func reset() {
        roundsLeft = 10
        correctMoveCount = 0
        wrongMoveCount = 0
        score = 0
        newRound()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
