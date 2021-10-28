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
            .font(.system(size: 100))
    }
}

struct EmojiButton: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.mint
                .clipShape(Circle())
            
            content
        }
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
    
    @State private var roundsLeft = 10
    @State private var showingRestartGame = false
    
    var body: some View {
        VStack {
            Text("Rock, Paper, Scissors")
                .font(.largeTitle.bold())
            
            VStack {
                MoveEmoji(emoji: moves[currentChoice])
                
                Text("You should")
                Text(shouldWin ? "Win" : "Lose")
            }
            
            VStack {
                Text("Make your move")
                
                HStack {
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
            
            Text("Score: \(score)")
                .font(.title.bold())
        }
        .padding()
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("New round", action: newRound)
        } message: {
            Text("Your score is \(score).")
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
            score += 1
        } else {
            scoreTitle = "Wrong! You should choose \(correctMove)"
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
        score = 0
        newRound()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
