import SwiftUI

struct ContentView: View {
    @State private var choices = ["🪨", "🧻", "✂️"]
    @State private var botChoice = Int.random(in: 0..<3)
    @State private var currentBotChoice: String = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var rounds = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userMustWin = Bool.random()
    
    let totalRounds = 10
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.blue, .yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                Spacer()
                
                // Bot choice section
                HStack(spacing: 10) {
                    Text("Bot Choice:")
                        .foregroundStyle(.primary)
                        .font(.title.weight(.bold))
                        .padding(.horizontal, 8)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(8)
                    
                    Text(choices[botChoice])
                        .font(.system(size: 60))
                        .shadow(radius: 10)
                        .onAppear {
                            currentBotChoice = choices[botChoice]
                        }
                }
                .padding(.top, 60)
                
                // Prompt for player to either win or lose
                HStack {
                    Text("You must:")
                        .foregroundStyle(.primary)
                        .font(.title2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(8)
                    
                    Text(userMustWin ? "Win" : "Lose")
                        .font(.title2.weight(.bold))
                        .foregroundColor(userMustWin ? .green : .red)
                    
                }
                
                // User choice section
                VStack(spacing: 20) {
                    Text("Your Choice:")
                        .font(.headline.italic())
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { number in
                            Button {
                                buttonTapped(number)
                            } label: {
                                Text(choices[number])
                                    .frame(width: 70, height: 70)
                                    .font(.system(size: 40))
                                    .background(Color.blue.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    
                    Spacer()
                    Text("Score: \(score)")
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
            }
            .padding(.bottom, 80)
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
    
    func askQuestion() {
        if rounds >= totalRounds {
            gameOver = true
        } else {
            botChoice = Int.random(in: 0..<3)
            currentBotChoice = choices[botChoice]
            userMustWin.toggle() // Alternate between win or lose each round
        }
    }
    
    func buttonTapped(_ number: Int) {
        let userChoice = choices[number]
        let result = getResult(userChoice: userChoice, botChoice: currentBotChoice)
        
        if userMustWin {
            // Player needs to win
            if result == "win" {
                score += 1
                scoreTitle = "Correct, you won!"
            } else {
                score -= 1
                scoreTitle = "Wrong, you needed to win!"
            }
        } else {
            // Player needs to lose
            if result == "lose" {
                score += 1
                scoreTitle = "Correct, you lost!"
            } else {
                score -= 1
                scoreTitle = "Wrong, you needed to lose!"
            }
        }
        
        rounds += 1
        showingScore = true
    }
    
    func getResult(userChoice: String, botChoice: String) -> String {
        if userChoice == botChoice {
            return "tie"
        }
        
        switch userChoice {
        case "🪨":
            return botChoice == "✂️" ? "win" : "lose"
        case "🧻":
            return botChoice == "🪨" ? "win" : "lose"
        case "✂️":
            return botChoice == "🧻" ? "win" : "lose"
        default:
            return "lose"
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
