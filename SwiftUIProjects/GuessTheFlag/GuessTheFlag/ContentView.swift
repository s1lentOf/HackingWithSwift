//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ігор Іванченко on 12.07.2024.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var rounds = 0
    @State private var gameOver = false
    
    @State private var rotatingAmount = 0.0
    @State private var selectedFlag = -1
    @State private var animationOpacityAmount = 2.0
    @State private var animationZoomAmount = 1.0

    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold().italic())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation(.bouncy(duration: 0.5)) {
                                rotatingAmount += 360
                                selectedFlag = number
                                animationOpacityAmount = 1.75
                                animationZoomAmount = 0.8
                            }
                            // Delay showing the alert until the animation finishes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(imageName: countries[number])  // Custom FlagImage view
                        }
                        .onAppear {
                            animationOpacityAmount = 0
                        }
                        .opacity(number == selectedFlag ? 1 : 2 - animationOpacityAmount)
                        .animation(nil, value: animationOpacityAmount)
                        .scaleEffect(number == selectedFlag ? 1.4 * animationZoomAmount : animationZoomAmount)  // Scale effect for zooming
                        .rotation3DEffect(.degrees(number == selectedFlag ? rotatingAmount : 0.0), axis: (x: 0.0, y: 1, z: 0.0))
                        .disabled(gameOver)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            // It adds the space between phone borders and the app
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if gameOver {
                Button("Restart", action: resetGame)
            } else {
                Button("Continue", action: askQuestion)
            }
        } message: {
            if gameOver {
                Text("Game over! Your final score is: \(score)")
            } else {
                Text("Your score is: \(score)")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
        }
        
        
        
        showingScore = true
        roundsCounter()
    }
    
    func askQuestion() {
        if !gameOver {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            selectedFlag = -1
            rotatingAmount = 0.0
            animationOpacityAmount = 0
            animationZoomAmount = 1.0
        }
    }
    
    func roundsCounter() {
        rounds += 1
        if rounds == 8 {
            scoreTitle = "Game Over!"
            gameOver = true
            showingScore = true
        }
    }
    
    func resetGame() {
        rounds = 0
        score = 0
        gameOver = false
        askQuestion()
    }
}

#Preview {
    ContentView()
}
