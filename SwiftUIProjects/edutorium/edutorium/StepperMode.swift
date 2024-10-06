//
//  Stepper.swift
//  edutorium
//
//  Created by Ігор Іванченко on 21.09.2024.
//

import SwiftUI

struct StepperMode: View {
    var rounds: Int
    
    struct ButtonBackgroundStepper: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.brown)
                .shadow(radius: 5)
                .frame(width: 140, height: 50)
                .padding(.vertical, 5)
        }
    }
    
    @State private var firstNumber = Int.random(in: 1...9)
    @State private var secondNumber = Int.random(in: 1...9)
    @State private var correctAnswer = 0
    @State private var stepperDefaultValue = 0
    @State private var userAnswer = 0
    @State private var buttonValue: [Int] = []
    
    @State private var totalCorrectAnswers = 0
    @State private var mistakes = 0
    
    @State private var endOfTheGame = false
    @State private var playedRounds = 0
    @State private var isShowingHomePage = false

    var body: some View {
        NavigationView {
            ZStack {
                Background(imageName: "Stepper")
                    .opacity(0.7)
                
                VStack {
                    Text("\(firstNumber) x \(secondNumber) = ?")
                        .font(.largeTitle)
                        .padding()
                    Text ("Select Product:")
                        .font(.title2)
                    Picker("Select Product", selection: $stepperDefaultValue) {
                        ForEach(1...81, id: \.self) { value in
                            Text("\(value)")
                                .font(.title) // Change the font size here
                                .tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .clipped()

                    

                    
                    Button(action: {
                        playedRounds += 1
                        checkAnswer(stepperDefaultValue)
                    }, label: {
                        ZStack {
                            ButtonBackgroundStepper()
                                .frame(width: 60)
                            Text("Submit")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                .shadow(radius: 2)
                        }
                    })
                    
                    


                }
                .frame(maxWidth: 300)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                .onAppear {
                    generateNewQuestion()
                }
                
                // Navigation link to the home page
                NavigationLink(
                    destination: HomePage()
                        .navigationBarBackButtonHidden(true), // Correct application of the modifier
                    isActive: $isShowingHomePage,
                    label: {
                        EmptyView() // Invisible link
                    }
                )
            }
            .alert("The game is over", isPresented: $endOfTheGame) {
                Button("Restart") {
                    playedRounds = 0
                    totalCorrectAnswers = 0
                    mistakes = 0
                    generateNewQuestion()
                }
                Button("Main Menu") {
                    playedRounds = 0
                    totalCorrectAnswers = 0
                    mistakes = 0
                    isShowingHomePage = true // Trigger navigation to home page
                }
            } message: {
                Group {
                    Text("""
                         Correct answers: \(totalCorrectAnswers)
                         Mistakes: \(mistakes)
                        """)
                }
            }
        }
    }
    
    // Function to generate a new question and button values
    func generateNewQuestion() {
        firstNumber = Int.random(in: 1...9)
        secondNumber = Int.random(in: 1...9)
        correctAnswer = firstNumber * secondNumber
        
        var answers = [correctAnswer]
        while answers.count < 3 {
            let randomAnswer = Int.random(in: 1...81)
            if randomAnswer != correctAnswer && !answers.contains(randomAnswer) {
                answers.append(randomAnswer)
            }
        }
        
        buttonValue = answers.shuffled()
    }
    
    // Function to check if the selected value is correct
    func checkAnswer(_ value: Int) {
        if value == correctAnswer {
            totalCorrectAnswers += 1
        } else {
            mistakes += 1
        }
        
        if playedRounds != rounds {
            generateNewQuestion() // Generate a new question after answering
        } else {
            endOfTheGame = true
        }
    }
}

#Preview {
    StepperMode(rounds: 5)
}

