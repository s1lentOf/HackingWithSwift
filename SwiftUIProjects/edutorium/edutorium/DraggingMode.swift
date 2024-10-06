import SwiftUI

struct DraggingMode: View {
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
    @State private var buttonValue: [Int] = []
    
    @State private var totalCorrectAnswers = 0
    @State private var mistakes = 0
    @State private var endOfTheGame = false
    @State private var playedRounds = 0
    @State private var isShowingHomePage = false
    
    @State var rectangleIsTargeted = false

    // State for dragging
    @State private var dragAmount = CGSize.zero
    @State private var draggingIndex: Int? // Track which box is being dragged
    
    @State private var answer: String = "Insert Answer"

    var body: some View {
        NavigationView {
            ZStack {
                Background(imageName: "Stepper")
                    .opacity(0.7)
                
                VStack {
                    Text("\(firstNumber) x \(secondNumber) = ?")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Insert Product:")
                        .font(.title2)
                    
                
                    ZStack {
                        Text("\(answer)")
                        // Box for the selected answer
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 55)
                            .cornerRadius(10)
                            .foregroundStyle(.secondary.opacity(rectangleIsTargeted ? 0.3 : 1))
                            .dropDestination(for: String.self) { items, location in
                                guard let firstItem = items.first else {
                                    // if we don't have anything in our first item,
                                    // then something must have gone wrong and we want to let the system know
                                    // so we return false
                                    return false
                                }
                                
                                answer = firstItem
                                
                                //if the drop was successful, we will want to return true
                                return true
                            } isTargeted: { isTargeted in
                                // this lets our state variable know that our drop destination has been targeted
                                // meaning that it could be about to recieve a transferrable object
                                rectangleIsTargeted = isTargeted
                            }
                    }

                    // Draggable boxes for answers
                    HStack {
                        ForEach(buttonValue.indices, id: \.self) { index in
                            let value = buttonValue[index]
                            Text("\(value)")
                                .padding()
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .offset(draggingIndex == index ? dragAmount : .zero)
                                .draggable("\(value)")
                        }
                    }
                    
                    Button(action: {
                        playedRounds += 1
                        if let userAnswer = Int(answer) {
                                checkAnswer(userAnswer)
                        } else {
                            print("Invalid answer: not a number")
                        }
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
                    resetGame()
                }
                Button("Main Menu") {
                    isShowingHomePage = true
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
    
    func generateNewQuestion() {
        firstNumber = Int.random(in: 1...9)
        secondNumber = Int.random(in: 1...9)
        correctAnswer = firstNumber * secondNumber
        answer = "Insert Answer"
        
        var answers = [correctAnswer]
        while answers.count < 3 {
            let randomAnswer = Int.random(in: 1...81)
            if randomAnswer != correctAnswer && !answers.contains(randomAnswer) {
                answers.append(randomAnswer)
            }
        }
        
        buttonValue = answers.shuffled()
    }

    func checkEndCondition() {
        if playedRounds >= rounds {
            endOfTheGame = true
        }
    }

    func resetGame() {
        playedRounds = 0
        totalCorrectAnswers = 0
        mistakes = 0
        generateNewQuestion()
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
    DraggingMode(rounds: 5)
}
