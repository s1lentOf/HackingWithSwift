import SwiftUI

struct Background: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .ignoresSafeArea()
    }
}

struct ButtonBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.brown)
            .shadow(radius: 5)
            .frame(width: 200, height: 70)
            .padding(.vertical, 5)
    }
}


struct HomePage: View {
    
    @State private var modes = ["Stepper", "Select", "Dragging"]
    
    @State private var selectedModeIndex: Int? = nil
    
    @State private var showRoundsSelection = false
    @State private var selectedRounds = 0
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background(imageName: "HomePage")
                
                VStack(spacing: 10) {
                    Spacer()
                    
                    Text("Edutorium")
                        .font(.largeTitle.bold())
                        .italic()
                        .foregroundStyle(LinearGradient(colors: [.yellow, .red], startPoint: .leading, endPoint: .trailing))
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        ForEach(0..<modes.count, id: \.self) { index in
                            Button(action: {
                                selectedModeIndex = index
                                showRoundsSelection = true
                            }) {
                                ZStack {
                                    ButtonBackground()
                                    Text(modes[index])
                                        .foregroundColor(.white)
                                        .font(.title2.bold())
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .alert("Rounds Amount", isPresented: $showRoundsSelection) {
                
                Button("5 Rounds") {
                    selectedRounds = 5
                    navigateToGame = true
                }
                Button("10 Rounds") {
                    selectedRounds = 10
                    navigateToGame = true
                }
                Button("15 Rounds") {
                    selectedRounds = 15
                    navigateToGame = true
                }
                Button("Cancel") {
                    showRoundsSelection = false // Close the alert
                }
            } message: {
                Text("How many rounds do you want to play?")
            }
            
            // This NavigationLink will trigger when navigateToGame is set to true
            if let selectedModeIndex = selectedModeIndex {
                NavigationLink(
                    destination: destinationView(for: selectedModeIndex, rounds: selectedRounds),
                    isActive: $navigateToGame,
                    label: {
                        EmptyView() // Invisible link
                    }
                )
            }
        }
    }
    
    // Function to return the appropriate view for each game mode
    @ViewBuilder
    func destinationView(for index: Int, rounds: Int) -> some View {
        switch index {
        case 0:
            StepperMode(rounds: rounds)      // Redirects to 'Up to...' mode
        case 1:
            SelectMode(rounds: rounds)   // Redirects to 'Stepper' mode
        case 2:
            DraggingMode(rounds: rounds)  // Redirects to 'Dragging' mode
        default:
            Text("Unknown View")
        }
    }
}


#Preview {
    HomePage()
}
